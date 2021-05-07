library eanalytics;

import 'package:eanalytics/eanalytics.dart';
import 'package:eanalytics/src/models/keys/EAPropertyKey.dart';

class EAEstimate extends EAProperty {
  List<Product> products = [];
  EAEstimate({required String path, required String ref}) : super(path: path) {
    payload[EAPropertyKey.ESTIMATE] = 1;
    payload[EAPropertyKey.ESTIMATE_REF] = ref;
  }

  void setAmount(double amount) {
    payload[EAPropertyKey.ESTIMATE_AMOUNT] = amount;
  }

  void setType(String type) {
    payload[EAPropertyKey.ESTIMATE_TYPE] = type;
  }

  void setCurrency(String currency) {
    payload[EAPropertyKey.ESTIMATE_CURRENCY] = currency;
  }

  void addProduct({required Product product, double? amount, int? quantity}) {
    if (product.payload[EAPropertyKey.PRODUCT_AMOUNT] == null && amount != null)
      product.setAmount(amount);
    if (product.payload[EAPropertyKey.PRODUCT_QUANTITY] == null &&
        quantity != null) product.setQuantity(quantity);

    products.add(product);
    payload[EAPropertyKey.ESTIMATE_PRODUCTS] = products;
  }
}
