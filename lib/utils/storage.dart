import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

const SAVED_EAPROPERTIES_KEY = '__eanalytics__storage__';

Future<List<dynamic>> getStoredProperties({SharedPreferences? store}) async {
  final storage = store ?? await SharedPreferences.getInstance();

  String? payloads = storage.getString(SAVED_EAPROPERTIES_KEY);
  return payloads != null ? (jsonDecode(payloads) as Iterable).toList() : [];
}

Future<void> clearStorage() async {
  final storage = await SharedPreferences.getInstance();
  storage.remove(SAVED_EAPROPERTIES_KEY);
}

Future<void> save(dynamic payload) async {
  final storage = await SharedPreferences.getInstance();
  var data = await getStoredProperties(store: storage);

  data.add(payload);
  storage.setString(SAVED_EAPROPERTIES_KEY, jsonEncode(data));
}
