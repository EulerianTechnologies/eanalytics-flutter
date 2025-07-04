import 'dart:convert';
// import 'dart:ffi';
import 'package:eanalytics/src/utils/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

const SAVED_EAPROPERTIES_KEY = '__eanalytics__storage__';
const ANDROID_INSTALL_REFERRER = '__eanalytics__storage__android__install__referrer';

Future<List<Map<String, dynamic>>> getStoredProperties(
    {SharedPreferences? store, required EALogger logger}) async {
  logger.debug('Retrieving stored properties');
  final storage = store ?? await SharedPreferences.getInstance();

  String? payloads = storage.getString(SAVED_EAPROPERTIES_KEY);
  var parsed = (payloads != null) ? jsonDecode(payloads) : [];

  return (parsed is List) ? parsed.cast<Map<String, dynamic>>() : [];
}

Future<void> clearStorage(
    {SharedPreferences? store, required EALogger logger}) async {
  logger.debug('clearing property storage');
  final storage = store ?? await SharedPreferences.getInstance();
  storage.remove(SAVED_EAPROPERTIES_KEY);
}

Future<void> save(List<Map<String, dynamic>> payloads,
    {required EALogger logger}) async {
  logger.debug('Saving payloads $payloads');
  final storage = await SharedPreferences.getInstance();
  storage.setString(SAVED_EAPROPERTIES_KEY, jsonEncode(payloads));
}

Future<void> saveAndroidInstallReferrer(String installReference) async {
  final storage = await SharedPreferences.getInstance();
  storage.setString(ANDROID_INSTALL_REFERRER, installReference);
}

Future<String?> getAndroidInstallReferrer() async {
  final storage = await SharedPreferences.getInstance();

  if (storage.containsKey(ANDROID_INSTALL_REFERRER))
    return storage.getString(ANDROID_INSTALL_REFERRER).toString();
  else
    return null;
}