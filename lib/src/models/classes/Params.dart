library eanalytics;

import 'package:eanalytics/src/utils/serializable.dart';

class Params with Serializable<String, dynamic> {
  Params();

  Params.fromEntries(List<MapEntry<String, dynamic>> entries) {
    entries.forEach((entry) => addParam(entry.key, entry.value));
  }

  void addParam(String key, dynamic value) {
    payload[key] = value;
  }
}
