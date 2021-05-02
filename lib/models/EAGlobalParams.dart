import 'package:advertising_id/advertising_id.dart';
import 'package:async/async.dart';
import 'package:eanalytics/eanalytics.dart';
import 'package:eanalytics/models/keys/EAPropertyKey.dart';
import 'package:eanalytics/utils/systemInfo.dart';
import 'package:eanalytics/utils/time.dart';

const SystemInfoMapping = <SystemInfoKey, EAPropertyKey>{
  SystemInfoKey.AD_ID: EAPropertyKey.ADID,
  SystemInfoKey.APP_NAME: EAPropertyKey.APPNAME,
  SystemInfoKey.APP_VERSION: EAPropertyKey.APP_VERSION,
  SystemInfoKey.BUNDLE_ID: EAPropertyKey.URL,
  SystemInfoKey.MODEL: EAPropertyKey.EHW,
  SystemInfoKey.OS: EAPropertyKey.EOS,
  SystemInfoKey.UUID: EAPropertyKey.EUIDL
};

class EAGlobalParams {
  static final EAGlobalParams _instance = EAGlobalParams._internal();
  EAGlobalParams._internal();

  factory EAGlobalParams() {
    return _instance;
  }

  final _buildMemo = AsyncMemoizer<Map<EAPropertyKey, dynamic>>();

  Future<Map<EAPropertyKey, dynamic>> _build() => _buildMemo.runOnce(() async {
        var asyncParams = <EAPropertyKey, dynamic>{};
        final systemInfo = (await getSystemInfo())..removeWhere((_, value) => value == null);

        asyncParams.addAll(systemInfo.map<EAPropertyKey, dynamic>((key, value) {
          return new MapEntry(SystemInfoMapping[key] as EAPropertyKey, value);
        }));

        return asyncParams;
      });

  static Future<Map<EAPropertyKey, dynamic>> build() async {
    var globalParams = <EAPropertyKey, dynamic>{};
    globalParams.addAll(await _instance._build());

    globalParams[EAPropertyKey.SDK_VERSION] = Eulerian.SDK_VERSION;
    globalParams[EAPropertyKey.EPOCH] = getSecondsSinceEpoch();

    return globalParams;
  }
}
