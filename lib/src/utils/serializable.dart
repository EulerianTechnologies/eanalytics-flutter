import 'package:eanalytics/src/models/keys/EAPropertyKey.dart';
import 'package:flutter/foundation.dart';

/// Generic serializable mixin
mixin Serializable<K, V> {
  /// internal payload Map<K, V>
  @protected
  Map<K, V> payload = {};

  /// Serializes payload
  Map<String, dynamic> toJson() => toJSON(payload);
}

bool filterEmpty(dynamic _, dynamic value) =>
    value == null ||
    (value is String) && value.isEmpty ||
    (value is List) && value.isEmpty ||
    (value is Map && value.isEmpty);

Map<String, dynamic> toJSON<F, T extends Map>(T payload) {
  payload.removeWhere(filterEmpty);
  return payload.map((key, value) => (MapEntry(
      key is EAPropertyKey ? key.name : key as String, traverse(value))));
}

dynamic traverse(dynamic value) {
  if (value is Serializable) return value.toJson();
  if (value is List) return value.map((v) => traverse(v)).toList();
  if (value is Map) return toJSON(value);
  return value;
}
