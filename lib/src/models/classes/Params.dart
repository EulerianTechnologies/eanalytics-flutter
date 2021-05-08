library eanalytics;

import 'package:eanalytics/src/utils/serializable.dart';

/// Params helper class
class Params with Serializable<String, dynamic> {
  /// Default constructor
  Params();

  /// Build Params instance from entries.
  /// Internally calls Params::addParam for each entry
  Params.fromEntries(List<MapEntry<String, dynamic>> entries) {
    entries.forEach((entry) => addParam(entry.key, entry.value));
  }

  /// Adds a key/value pair to the payload
  void addParam(String key, dynamic value) {
    payload[key] = value;
  }
}
