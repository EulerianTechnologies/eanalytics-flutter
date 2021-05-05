library eanalytics;

import 'EAGlobalParams.dart';
import 'keys/EAPropertyKey.dart';

class EAProperty {
  Map<EAPropertyKey, dynamic> _payload = {};

  EAProperty() {
    _payload.addAll(EAGlobalParams.build());
  }

  Map<String, dynamic> toJson() => _payload.map((key, value) => (MapEntry(key.name, value)));
}
