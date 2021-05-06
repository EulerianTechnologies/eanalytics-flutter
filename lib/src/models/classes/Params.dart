library eanalytics;

import 'package:eanalytics/src/utils/serializable.dart';

class Params with Serializable<String, dynamic> {
  Params();

  void addParam(String key, dynamic value) {
    payload[key] = value;
  }
}
