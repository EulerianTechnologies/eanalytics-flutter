import 'package:eanalytics/src/utils/logger.dart';
import 'package:eanalytics/src/utils/post.dart';
import 'package:eanalytics/src/utils/storage.dart';
import 'package:eanalytics/src/utils/systemInfo.dart';
import 'package:flutter/widgets.dart';

import 'models/EAGlobalParams.dart';
import 'models/EAProperty.dart';

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

  PostHandler? _postHandler;

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
  static Future<void> init(String domain, {bool requestTrackingAuthorization = false}) async {
    try {
      assert(!domain.contains('.eulerian.com'), 'Domain cannot contain ".eulerian.com"');
      assert(Uri.parse('https://$domain').isAbsolute, 'Domain is not well formed');

      /* if called during initState, delay initialization */
      if (requestTrackingAuthorization) WidgetsBinding.instance!.addPostFrameCallback((_) => getAdvertiserId(true));

      await EAGlobalParams.init();
      Eulerian._instance.initialized = true;
      Eulerian._instance._postHandler = createPostHandler(domain, _logger);

      /* sync saved properties */
      Eulerian._instance._post(await getStoredProperties(logger: _logger));

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
    assert(Eulerian._instance.initialized, 'Eulerian Tracker was not initialized. You must call Eulerian.Init()');
    if (!Eulerian._instance.initialized) return;

    _logger.info('Tracking properties $properties');

    Eulerian._instance._post(await Eulerian._instance._sync(properties.fold(<Map<String, dynamic>>[], (acc, prop) {
      acc.add(prop.toJson());
      return acc;
    })));
  }

  Future<List<Map<String, dynamic>>> _sync(List<Map<String, dynamic>> body) async {
    final synced = body.toList();
    synced.addAll(await getStoredProperties(logger: _logger));

    return synced;
  }

  Future<void> _post(List<Map<String, dynamic>> payloads) async {
    if (payloads.isEmpty) return;

    _logger.debug('Request to track : \n${payloads.join('\n ')}');

    Eulerian._instance._postHandler!(payloads, onSuccess: (_) async {
      clearStorage(logger: _logger);
    }, onFail: (body) async {
      _logger.error('POST request failed, storing payloads to storage');
      save(body, logger: _logger);
    });
  }
}
