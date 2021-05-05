import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

const SAVED_EAPROPERTIES_KEY = '__eanalytics__storage__';

Future<List<Map<String, dynamic>>> getStoredProperties({SharedPreferences? store}) async {
  final storage = store ?? await SharedPreferences.getInstance();

  String? payloads = storage.getString(SAVED_EAPROPERTIES_KEY);
  var parsed = (payloads != null) ? jsonDecode(payloads) : [];

  return (parsed is List) ? parsed.cast<Map<String, dynamic>>() : [];
}

Future<void> clearStorage({SharedPreferences? store}) async {
  final storage = store ?? await SharedPreferences.getInstance();
  storage.remove(SAVED_EAPROPERTIES_KEY);
}

Future<void> save(List<Map<String, dynamic>> payloads) async {
  final storage = await SharedPreferences.getInstance();
  storage.setString(SAVED_EAPROPERTIES_KEY, jsonEncode(payloads));
}
