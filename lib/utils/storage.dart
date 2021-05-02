import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

const SAVED_EAPROPERTIES_KEY = '__eanalytics__storage__';

Future<List<dynamic>> getSavedPayloads({SharedPreferences? store}) async {
  final storage = store ?? await SharedPreferences.getInstance();

  String? payloads = storage.getString(SAVED_EAPROPERTIES_KEY);
  return payloads != null ? (jsonDecode(payloads) as Iterable).toList() : [];
}

Future<void> savePayload(dynamic payload) async {
  final storage = await SharedPreferences.getInstance();
  var data = await getSavedPayloads(store: storage);

  data.add(payload);
  storage.setString(SAVED_EAPROPERTIES_KEY, jsonEncode(data));
}
