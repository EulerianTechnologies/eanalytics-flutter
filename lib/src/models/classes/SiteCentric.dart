library eanalytics;

import 'package:eanalytics/src/utils/serializable.dart';

/// SiteCentric helper class
class SiteCentric with Serializable<String, dynamic> {
  /// Default constructor
  SiteCentric();

  /// Build SiteCentric instance from entries.
  /// Internally calls SiteCentric::addParam for each entry
  SiteCentric.fromEntries(List<MapEntry<String, List<String>>> entries) {
    entries.forEach((entry) => addParam(entry.key, entry.value));
  }

  /// Add parameter to SiteCentric instance
  void addParam(String key, List<String> value) {
    payload[key] = value;
  }
}
