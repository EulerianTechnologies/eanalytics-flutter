library eanalytics;

import 'package:eanalytics/src/utils/serializable.dart';

class SiteCentric with Serializable<String, dynamic> {
  SiteCentric();

  SiteCentric.fromEntries(List<MapEntry<String, List<String>>> entries) {
    entries.forEach((entry) => addParam(entry.key, entry.value));
  }

  void addParam(String key, List<String> value) {
    payload[key] = value;
  }
}
