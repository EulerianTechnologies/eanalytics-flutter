library eanalytics;

import 'package:eanalytics/src/models/classes/Params.dart';
import 'package:eanalytics/src/models/keys/EAPropertyKey.dart';
import 'package:eanalytics/src/utils/serializable.dart';

/// Product helper class
class Product with Serializable<EAPropertyKey, dynamic> {
  /// Constructor sets the *ref*, *name*?, *group*? and *params*? properties
  Product(
      {required String ref, String? name, String? group, Params? parameters}) {
    setRef(ref);
    if (name != null) setName(name);
    if (group != null) setGroup(group);
    if (parameters != null) setParams(parameters);
  }

  /// Sets the *ref* property
  void setRef(String ref) {
    payload[EAPropertyKey.PRODUCT_REF] = ref;
  }

  /// Sets the *name* property
  void setName(String name) {
    payload[EAPropertyKey.PRODUCT_NAME] = name;
  }

  /// Sets the *group* property
  void setGroup(String group) {
    payload[EAPropertyKey.PRODUCT_GROUP] = group;
  }

  /// Sets the *params* property
  void setParams(Params parameters) {
    payload[EAPropertyKey.PRODUCT_PARAMS] = parameters;
  }

  /// Sets the *amount* property
  void setAmount(double amount) {
    payload[EAPropertyKey.PRODUCT_AMOUNT] = amount;
  }

  /// Sets the *quantity* property
  void setQuantity(int quantity) {
    payload[EAPropertyKey.PRODUCT_QUANTITY] = quantity;
  }
}
