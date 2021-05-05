library eanalytics;

import 'package:eanalytics/models/EAGlobalParams.dart';
import 'package:eanalytics/models/keys/EAPropertyKey.dart';

class EAProperties {
  Map<EAPropertyKey, dynamic> _payload = {};

  EAProperties() {
    _payload.addAll(EAGlobalParams.build());
  }

  Map<String, dynamic> toJson() => _payload.map((key, value) => (MapEntry(key.name, value)));
}
