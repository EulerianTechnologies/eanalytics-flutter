library eanalytics;

import 'package:eanalytics/src/models/classes/Params.dart';
import 'package:eanalytics/src/models/keys/EAPropertyKey.dart';
import 'package:eanalytics/src/utils/serializable.dart';

class Product with Serializable<EAPropertyKey, dynamic> {
  Product({required String ref, String? name, String? group, Params? parameters}) {
    payload[EAPropertyKey.PRODUCT_REF] = ref;
    payload[EAPropertyKey.PRODUCT_NAME] = name;
    payload[EAPropertyKey.PRODUCT_GROUP] = group;
    payload[EAPropertyKey.PRODUCT_PARAMS] = parameters;
  }
}
