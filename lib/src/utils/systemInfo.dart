import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:advertising_id/advertising_id.dart'
    if (dart.library.js) 'package:eanalytics/src/utils/stubs/advertising_id.dart';

enum SystemInfoKey {
  OS,
  MODEL,
  UUID,
  BUNDLE_ID,
  APP_NAME,
  APP_VERSION,
  IOS_ADID,
  ANDROID_ADID,
  IOS_IDFV
}

Future<Map<SystemInfoKey, dynamic>> getSystemInfo() async {
  if (!kIsWeb && !Platform.isAndroid && !Platform.isIOS)
    throw PlatformException(code: 'Unsupported platform');
  var systemInfo = <SystemInfoKey, dynamic>{};

  systemInfo.addAll(parsePackageInfo(await PackageInfo.fromPlatform()));

  final device = DeviceInfoPlugin();

  if (!kIsWeb) {
    if (Platform.isAndroid) {
      const _androidIdPlugin = AndroidId();
      systemInfo.addAll(parseAndroidInfo(await device.androidInfo));
      systemInfo[SystemInfoKey.ANDROID_ADID] = await getAdvertiserId(false);
      systemInfo[SystemInfoKey.UUID] = await _androidIdPlugin.getId();
    }

    if (Platform.isIOS) {
      systemInfo.addAll(parseIosInfo(await device.iosInfo));
      systemInfo[SystemInfoKey.IOS_ADID] = await getAdvertiserId(false);
    }
  }

  if (kIsWeb) systemInfo.addAll(parseWebInfo(await device.webBrowserInfo));

  return systemInfo;
}

Map<SystemInfoKey, String?> parseAndroidInfo(AndroidDeviceInfo info) {
  return <SystemInfoKey, String?>{
    SystemInfoKey.OS:
        'Android OS ${info.version.release} (SDK ${info.version.sdkInt})',
    SystemInfoKey.MODEL: '${info.manufacturer} ${info.model}'
  };
}

Map<SystemInfoKey, String?> parseIosInfo(IosDeviceInfo info) {
  return <SystemInfoKey, String?>{
    SystemInfoKey.OS: '${info.systemName} ${info.systemVersion}',
    SystemInfoKey.MODEL: '${info.name} ${info.model}',
    SystemInfoKey.UUID: info.identifierForVendor,
    SystemInfoKey.IOS_IDFV: info.identifierForVendor
  };
}

Map<SystemInfoKey, String?> parseWebInfo(WebBrowserInfo info) {
  return <SystemInfoKey, String?>{
    SystemInfoKey.OS: '${info.platform}',
    SystemInfoKey.MODEL: '${describeEnum(info.browserName)}'
  };
}

Map<SystemInfoKey, String?> parsePackageInfo(PackageInfo info) {
  return <SystemInfoKey, String?>{
    SystemInfoKey.BUNDLE_ID: info.packageName,
    SystemInfoKey.APP_NAME: info.appName,
    SystemInfoKey.APP_VERSION: info.version
  };
}

Future<String?> getAdvertiserId(bool requestTrackingAuthorization) async {
  try {
    if (kIsWeb)
      throw PlatformException(
          code: "advertiserId not supported on web platform");
    return await AdvertisingId.id(requestTrackingAuthorization);
  } on PlatformException {
    return null;
  }
}
