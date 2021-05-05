library eanalytics;

import 'package:eanalytics/models/EAGlobalParams.dart';
import 'package:eanalytics/models/EAProperties.dart';
import 'package:eanalytics/utils/post.dart';
import 'package:eanalytics/utils/storage.dart';
import 'package:eanalytics/utils/systemInfo.dart';
import 'package:flutter/widgets.dart';
import 'package:logger/logger.dart';

class Eulerian {
  static final Eulerian _instance = Eulerian._internal();
  static final logger = Logger(printer: PrettyPrinter(methodCount: 0));
  static const SDK_VERSION = "0.0.1";

  bool initialized = false;
  String? domain;
  PostHandler? postHandler;

  factory Eulerian() {
    return _instance;
  }

  Eulerian._internal();

  static Future<void> init(String domain, {bool requestTrackingAuthorization = false}) async {
    try {
      assert(!domain.contains('.eulerian.com'), 'Domain cannot contain ".eulerian.com"');
      assert(Uri.parse('https://$domain').isAbsolute, 'Domain is not well formed');

      /* if called during initState, delay initialization */
      if (requestTrackingAuthorization) WidgetsBinding.instance!.addPostFrameCallback((_) => getAdvertiserId(true));

      await EAGlobalParams.init();
      Eulerian._instance.initialized = true;
      Eulerian._instance.postHandler = createPostHandler(domain, logger);

      /* sync saved properties */
      Eulerian._instance._post(await getStoredProperties());

      logger.d('[EAnalytics] - Initilization succeeded for domain $domain');
    } catch (e) {
      logger.e('[EAnalytics] - Initialization failed ${e.toString()}');
    }
  }

  static Future<void> track(List<EAProperties> properties) async {
    assert(Eulerian._instance.initialized, 'Eulerian Tracker was not initialized. You must call Eulerian.Init()');
    if (!Eulerian._instance.initialized) return;

    Eulerian._instance._post(await Eulerian._instance._sync(properties.fold(<Map<String, dynamic>>[], (acc, prop) {
      acc.add(prop.toJson());
      return acc;
    })));
  }

  Future<List<Map<String, dynamic>>> _sync(List<Map<String, dynamic>> body) async {
    final synced = body.toList();
    synced.addAll(await getStoredProperties());

    return synced;
  }

  Future<void> _post(List<Map<String, dynamic>> payloads) async {
    if (payloads.isEmpty) return;

    logger.d('[EAnalytics] - Request to track : \n${payloads.join('\n ')}');

    Eulerian._instance.postHandler!(payloads, onSuccess: (_) async {
      clearStorage();
    }, onFail: (body) async {
      logger.e('[EAnalytics] - POST request failed, storing payloads to storage');
      save(body);
    });
  }
}
