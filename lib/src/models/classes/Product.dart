library eanalytics;

import 'package:eanalytics/src/models/classes/Params.dart';
import 'package:eanalytics/src/models/keys/EAPropertyKey.dart';
import 'package:eanalytics/src/utils/serializable.dart';

class Product with Serializable<EAPropertyKey, dynamic> {
  Product({required String ref, String? name, String? group, Params? parameters}) {
    setRef(ref);
    if (name != null) setName(name);
    if (group != null) setGroup(group);
    if (parameters != null) setParams(parameters);
  }

  void setRef(String ref) {
    payload[EAPropertyKey.PRODUCT_REF] = ref;
  }

  void setName(String name) {
    payload[EAPropertyKey.PRODUCT_NAME] = name;
  }

  void setGroup(String group) {
    payload[EAPropertyKey.PRODUCT_GROUP] = group;
  }

  void setParams(Params parameters) {
    payload[EAPropertyKey.PRODUCT_PARAMS] = parameters;
  }

  void setAmount(double amount) {
    payload[EAPropertyKey.PRODUCT_AMOUNT] = amount;
  }

  void setQuantity(int quantity) {
    payload[EAPropertyKey.PRODUCT_QUANTITY] = quantity;
  }
}
