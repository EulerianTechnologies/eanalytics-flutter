import 'package:eanalytics/src/utils/logger.dart';
import 'package:eanalytics/src/utils/post.dart';
import 'package:eanalytics/src/utils/storage.dart';
import 'package:eanalytics/src/utils/systemInfo.dart';
import 'package:flutter/widgets.dart';
import 'package:logger/logger.dart';

import 'models/EAGlobalParams.dart';
import 'models/EAProperty.dart';
import 'models/EATpClick.dart';
import 'models/EATpView.dart';
import 'utils/get.dart';

/// Result of splitting stored payloads into merchandise events (re-sent via
/// GET) and plain collector payloads (re-sent via POST).
class PartitionedStored {
  final List<EAProperty> merchandise;
  final List<Map<String, dynamic>> postPayloads;
  PartitionedStored(this.merchandise, this.postPayloads);
}

/// Splits a stored payload list by the `_ea_kind` discriminator written by
/// `EATpView.toStorageJson()` / `EATpClick.toStorageJson()`.
PartitionedStored partitionStoredItems(List<Map<String, dynamic>> stored) {
  final merchandise = <EAProperty>[];
  final postPayloads = <Map<String, dynamic>>[];

  for (final item in stored) {
    final kind = item['_ea_kind'];
    if (kind == 'tpview') {
      merchandise.add(EATpView.fromStorageJson(item));
    } else if (kind == 'tpclick') {
      merchandise.add(EATpClick.fromStorageJson(item));
    } else {
      postPayloads.add(item);
    }
  }

  return PartitionedStored(merchandise, postPayloads);
}

/// Eulerian Analytics singleton class
class Eulerian {
  static final Eulerian _instance = Eulerian._internal();
  static final _logger = EALogger();

  /// EAnalytics SDK version
  static const SDK_VERSION = "0.0.1";

  /// Flag indicating the initialization status of the EAnalytics SDK
  bool initialized = false;

  /// Domain attached to the EAnalytics SDK instance
  String? domain;

  String? euidl;

  PostHandler? _postHandler;
  GetHandler? _getHandlerView;
  GetHandler? _getHandlerClick;

  /// Singleton factory constructor
  factory Eulerian() {
    return _instance;
  }

  Eulerian._internal();

  /// Asynchronously initializes the EAnalytics SDK
  ///
  /// Call it *ONCE* before any tracking request at the top-level of your app.
  /// It will try to sync any failed tracking attemps locally stored.
  /// You can optionnally request tracking authorization for iOS devices by
  /// passing the requestTrackingAuhtorization flag to the init method.
  ///
  /// ```dart
  ///   await Eulerian.init('test.domain.dev', requestTrackingAuthorization: true)
  /// ```
  static Future<void> init(String domain,
      {bool requestTrackingAuthorization = false,
      bool enableLogger = true}) async {
    try {
      EALogger.setLevel(enableLogger ? Level.all : Level.off);

      assert(!domain.contains('.eulerian.com'),
          'Domain cannot contain ".eulerian.com"');
      assert(
          Uri.parse('https://$domain').isAbsolute, 'Domain is not well formed');

      /* if called during initState, delay initialization */
      if (requestTrackingAuthorization)
        WidgetsBinding.instance
            .addPostFrameCallback((_) => getAdvertiserId(true));

      await EAGlobalParams.init( Eulerian._instance );
      Eulerian._instance.initialized = true;
      Eulerian._instance._postHandler = createPostHandler(domain, _logger);
      Eulerian._instance._getHandlerView = createGetHandler(domain + "/tpview/", _logger);
      Eulerian._instance._getHandlerClick = createGetHandler(domain + "/tpclick/", _logger);

      /* sync saved properties */
      await Eulerian._instance._replayStored();

      _logger.info('Initilization succeeded for domain $domain');
    } catch (e) {
      _logger.error('Initialization failed ${e.toString()}');
    }
  }

  /// Tracks a list of properties extending EAProperties
  ///
  /// EAProperties include EACart, EAEstimate, EAOrder, EAProducts, EASearch.
  /// If the POST request fails, it will be stored in local storage for future retry.
  /// ```dart
  ///   Eulerian.track([
  ///     EAProducts(path: '/add/products')
  ///       ..addProduct(Product(ref: 'p1', name: 'Product 1', group: 'test_group'))
  ///   ])
  /// ```
  static Future<void> track(List<EAProperty> properties) async {
  assert(Eulerian._instance.initialized,
      'Eulerian Tracker was not initialized. You must call Eulerian.Init()');
  if (!Eulerian._instance.initialized) return;

  _logger.info('Tracking properties $properties');

  final List<EAProperty> postProps = [];

  for (final prop in properties) {
    if (prop is EATpView || prop is EATpClick) {
      await Eulerian._instance._get(prop);
    } else {
      postProps.add(prop);
    }
  }

  // Retry any previously failed events with transport-aware routing.
  await Eulerian._instance._replayStored();

  // POST batch for the new collector events of this call.
  if (postProps.isNotEmpty) {
    Eulerian._instance._post(
      postProps.fold<List<Map<String, dynamic>>>([], (acc, prop) {
        acc.add(prop.toJson());
        return acc;
      }),
    );
  }
}

  static String? uid() {
    if (!Eulerian._instance.initialized) return "";
    return Eulerian._instance.euidl;
  }

  Future<void> _replayStored() async {
    final stored = await getStoredProperties(logger: _logger);
    if (stored.isEmpty) return;

    // Take ownership of the backlog: clear it, then re-dispatch. Each failed
    // re-send re-appends itself via _get/_post onFail.
    await clearStorage(logger: _logger);

    final partition = partitionStoredItems(stored);

    for (final event in partition.merchandise) {
      await Eulerian._instance._get(event);
    }

    if (partition.postPayloads.isNotEmpty) {
      Eulerian._instance._post(partition.postPayloads);
    }
  }

  Future<void> _post(List<Map<String, dynamic>> payloads) async {
    if (payloads.isEmpty) return;

    _logger.debug('Request to track : \n${payloads.join('\n ')}');

    Eulerian._instance._postHandler!(payloads, onSuccess: (_) async {
      // A successful POST transmitted only its own `payloads`, which are no
      // longer in storage (new events were never stored; replayed events were
      // cleared up front by _replayStored). Clearing here would wipe unrelated
      // backlog items (e.g. a merchandise GET that just failed and re-appended).
    }, onFail: (body) async {
      _logger.error('POST request failed, storing payloads to storage');
      await appendStored(body, logger: _logger);
    });
  }

  Future<void> _get(EAProperty value) async {
    String path;
    GetHandler? handler;
    Map<String, dynamic> storageJson;

    if (value is EATpView) {
      path = value.toQueryString();
      handler = Eulerian._instance._getHandlerView;
      storageJson = value.toStorageJson();
    } else if (value is EATpClick) {
      path = value.toQueryString();
      handler = Eulerian._instance._getHandlerClick;
      storageJson = value.toStorageJson();
    } else {
      return;
    }

    if (handler == null) return;

    _logger.debug('GET request to track: $path');

    await handler(
      path,
      // A successful live GET must NOT clear storage: it transmitted none of
      // the pending fallback payloads.
      onSuccess: (_) async {},
      onFail: (_) async {
        _logger.error('GET request failed, storing payload to storage');
        await appendStored([storageJson], logger: _logger);
      },
    );
  }
}
