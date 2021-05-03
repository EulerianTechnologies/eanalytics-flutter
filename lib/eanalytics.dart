library eanalytics;

import 'package:eanalytics/models/EAGlobalParams.dart';
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
      logger.d('[EAnalytics] - Initilization succeeded for domain $domain');
    } catch (e) {
      logger.e('[EAnalytics] - Initialization failed ${e.toString()}');
    }
  }

  static void track() {
    assert(Eulerian._instance.initialized, 'Eulerian Tracker was not initialized. You must call Eulerian.Init()');
    if (!Eulerian._instance.initialized) return;
  }

  Future<void> sync() async {
    List<dynamic> payloads = (await getSavedPayloads());
    if (payloads.isNotEmpty) {}
  }
}
