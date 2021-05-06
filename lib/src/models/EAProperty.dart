library eanalytics;

import 'package:eanalytics/src/utils/serializable.dart';
import 'EAGlobalParams.dart';
import 'keys/EAPropertyKey.dart';

class EAProperty with Serializable<EAPropertyKey, dynamic> {
  EAProperty() {
    payload.addAll(EAGlobalParams.build());
  }
}
