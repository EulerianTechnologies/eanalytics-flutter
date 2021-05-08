library eanalytics;

import 'package:eanalytics/eanalytics.dart';
import 'package:eanalytics/src/models/classes/Product.dart';
import 'package:eanalytics/src/models/keys/EAPropertyKey.dart';

/// EACart payload
class EACart extends EAProperty {
  List<Product> _products = [];

  /// Constructor sets the *path* property and *scart* flag
  EACart({required String path}) : super(path: path) {
    payload[EAPropertyKey.CART_SCART] = 1;
  }

  /// Sets the *scartcumul* flag
  void setCartCumul(bool cumul) {
    payload[EAPropertyKey.CART_CUMUL] = cumul ? 1 : 0;
  }

  /// Adds a product to the EACart instance
  void addProduct({required Product product, double? amount, int? quantity}) {
    if (product.payload[EAPropertyKey.PRODUCT_AMOUNT] == null && amount != null) product.setAmount(amount);
    if (product.payload[EAPropertyKey.PRODUCT_QUANTITY] == null && quantity != null) product.setQuantity(quantity);

    _products.add(product);
    payload[EAPropertyKey.PRODUCTS] = _products;
  }
}
