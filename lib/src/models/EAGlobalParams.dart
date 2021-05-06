import 'package:async/async.dart';
import 'package:eanalytics/src/eulerian.dart';
import 'package:eanalytics/src/utils/serializable.dart';
import 'package:eanalytics/src/utils/systemInfo.dart';
import 'package:eanalytics/src/utils/time.dart';

import 'keys/EAPropertyKey.dart';

const SystemInfoMapping = <SystemInfoKey, EAPropertyKey>{
  SystemInfoKey.AD_ID: EAPropertyKey.ADID,
  SystemInfoKey.APP_NAME: EAPropertyKey.APPNAME,
  SystemInfoKey.APP_VERSION: EAPropertyKey.APP_VERSION,
  SystemInfoKey.BUNDLE_ID: EAPropertyKey.URL,
  SystemInfoKey.MODEL: EAPropertyKey.EHW,
  SystemInfoKey.OS: EAPropertyKey.EOS,
  SystemInfoKey.UUID: EAPropertyKey.EUIDL
};

class EAGlobalParams with Serializable<EAPropertyKey, dynamic> {
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
          return new MapEntry(SystemInfoMapping[key] as EAPropertyKey, value);
        }));

        Eulerian.logger.d('[EAnalytics] - EAGlobalParams built ${asyncParams.toString()}');
        return asyncParams;
      });

  static Map<EAPropertyKey, dynamic> build() {
    var globalParams = <EAPropertyKey, dynamic>{};

    globalParams.addAll(_instance.payload);
    globalParams[EAPropertyKey.EPOCH] = getSecondsSinceEpoch();

    return globalParams;
  }

  static Future<void> init() async {
    try {
      Eulerian.logger.d('[EAnalytics] - EAGlobalParams initialization');
      _instance.payload = await _instance._build();
      _instance.payload[EAPropertyKey.SDK_VERSION] = Eulerian.SDK_VERSION;
    } catch (e) {
      Eulerian.logger.e('[EAnalytics] - Error while initializing global parameters', e);
    }
  }
}
