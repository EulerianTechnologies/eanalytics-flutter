import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';
import 'package:package_info/package_info.dart';
import 'package:advertising_id/advertising_id.dart';

enum SystemInfoKey { OS, MODEL, UUID, BUNDLE_ID, APP_NAME, APP_VERSION, AD_ID }

Future<Map<SystemInfoKey, dynamic>> getSystemInfo() async {
  if (!Platform.isAndroid && !Platform.isIOS) throw PlatformException(code: 'Unsupported platform');

  var systemInfo = <SystemInfoKey, dynamic>{};

  final device = new DeviceInfoPlugin();
  final packageInfo = await PackageInfo.fromPlatform();

  systemInfo.addAll(parsePackageInfo(packageInfo));

  if (Platform.isAndroid) systemInfo.addAll(parseAndroidInfo(await device.androidInfo));
  if (Platform.isIOS) systemInfo.addAll(parseIosInfo(await device.iosInfo));

  systemInfo[SystemInfoKey.AD_ID] = await getAdvertiserId();

  return systemInfo;
}

Map<SystemInfoKey, String?> parseAndroidInfo(AndroidDeviceInfo info) {
  return <SystemInfoKey, String?>{
    SystemInfoKey.OS: 'Android OS ${info.version.release} (SDK ${info.version.sdkInt})',
    SystemInfoKey.MODEL: '${info.manufacturer} ${info.model}',
    SystemInfoKey.UUID: info.androidId
  };
}

Map<SystemInfoKey, String?> parseIosInfo(IosDeviceInfo info) {
  return <SystemInfoKey, String?>{
    SystemInfoKey.OS: '${info.systemName} ${info.systemVersion}',
    SystemInfoKey.MODEL: '${info.name} ${info.model}',
    SystemInfoKey.UUID: info.identifierForVendor
  };
}

Map<SystemInfoKey, String?> parsePackageInfo(PackageInfo info) {
  return <SystemInfoKey, String?>{
    SystemInfoKey.BUNDLE_ID: info.packageName,
    SystemInfoKey.APP_NAME: info.appName,
    SystemInfoKey.APP_VERSION: info.version
  };
}

Future<String?> getAdvertiserId() async {
  try {
    return await AdvertisingId.id(true);
  } on PlatformException {
    return null;
  }
}
