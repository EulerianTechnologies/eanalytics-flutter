import 'package:async/async.dart';
import 'package:eanalytics/src/eulerian.dart';
import 'package:eanalytics/src/utils/logger.dart';
import 'package:eanalytics/src/utils/serializable.dart';
import 'package:eanalytics/src/utils/systemInfo.dart';
import 'package:eanalytics/src/utils/time.dart';
import 'package:flutter/foundation.dart';

import 'keys/EAPropertyKey.dart';

const SystemInfoMapping = <SystemInfoKey, EAPropertyKey>{
  SystemInfoKey.IOS_ADID: EAPropertyKey.IOS_ADID,
  SystemInfoKey.ANDROID_ADID: EAPropertyKey.ANDROID_ADID,
  SystemInfoKey.APP_NAME: EAPropertyKey.APPNAME,
  SystemInfoKey.APP_VERSION: EAPropertyKey.APP_VERSION,
  SystemInfoKey.BUNDLE_ID: EAPropertyKey.URL,
  SystemInfoKey.MODEL: EAPropertyKey.EHW,
  SystemInfoKey.OS: EAPropertyKey.EOS,
  SystemInfoKey.UUID: EAPropertyKey.EUIDL,
  SystemInfoKey.IOS_IDFV: EAPropertyKey.IOS_IDFV,
  SystemInfoKey.INSTALL_REFERRER: EAPropertyKey.INSTALL_REFERRER
};

class EAGlobalParams with Serializable<EAPropertyKey, dynamic> {
  static final _logger = EALogger();
  static final EAGlobalParams _instance = EAGlobalParams._internal();
  EAGlobalParams._internal();

  factory EAGlobalParams() {
    return _instance;
  }

  final _buildMemo = AsyncMemoizer<Map<EAPropertyKey, dynamic>>();

  Future<Map<EAPropertyKey, dynamic>> _build() => _buildMemo.runOnce(() async {
        var asyncParams = <EAPropertyKey, dynamic>{};
        final systemInfo = (await getSystemInfo())..removeWhere(filterEmpty);

        asyncParams.addAll(systemInfo.map<EAPropertyKey, dynamic>((key, value) {
          return MapEntry(SystemInfoMapping[key] as EAPropertyKey, value);
        }));

        _logger.debug('EAGlobalParams built ${asyncParams.toString()}');
        return asyncParams;
      });

  static Map<EAPropertyKey, dynamic> build() {
    var globalParams = <EAPropertyKey, dynamic>{};

    globalParams.addAll(_instance.payload);
    globalParams[EAPropertyKey.EPOCH] = getSecondsSinceEpoch();

    if (kIsWeb) globalParams[EAPropertyKey.URL] = Uri.base.path;

    return globalParams;
  }

  static Future<void> init(Eulerian eulerian) async {
    try {
      _logger.debug('EAGlobalParams initialization');
      _instance.payload = await _instance._build();
      _instance.payload[EAPropertyKey.SDK_VERSION] = Eulerian.SDK_VERSION;
      eulerian.euidl = _instance.payload[EAPropertyKey.EUIDL];
    } catch (e) {
      _logger.error('Error while initializing global parameters $e');
    }
  }
}
