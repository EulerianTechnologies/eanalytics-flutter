library eanalytics;

import 'package:eanalytics/eanalytics.dart';
import 'package:eanalytics/src/models/keys/EAPropertyKey.dart';

/// EAEstimate payload
class EAEstimate extends EAProperty {
  List<Product> _products = [];

  /// Constructor sets the *path* and *ref* properties
  EAEstimate({required String path, required String ref}) : super(path: path) {
    payload[EAPropertyKey.ESTIMATE] = 1;
    payload[EAPropertyKey.ESTIMATE_REF] = ref;
  }

  /// Sets the *amount* property
  void setAmount(double amount) {
    payload[EAPropertyKey.ESTIMATE_AMOUNT] = amount;
  }

  /// Sets the *type* property
  void setType(String type) {
    payload[EAPropertyKey.ESTIMATE_TYPE] = type;
  }

  /// Sets the *currency* property
  void setCurrency(String currency) {
    payload[EAPropertyKey.ESTIMATE_CURRENCY] = currency;
  }

  /// Adds a product to the EAEstimate instance
  void addProduct({required Product product, double? amount, int? quantity}) {
    if (product.payload[EAPropertyKey.PRODUCT_AMOUNT] == null && amount != null) product.setAmount(amount);
    if (product.payload[EAPropertyKey.PRODUCT_QUANTITY] == null && quantity != null) product.setQuantity(quantity);

    _products.add(product);
    payload[EAPropertyKey.ESTIMATE_PRODUCTS] = _products;
  }
}
