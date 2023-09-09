library eanalytics;

import 'package:eanalytics/eanalytics.dart';

/// EAProducts payload
class EAProducts extends EAProperty {
  List<Product> _products = [];

  /// Constructor sets the *path* property
  EAProducts({required String path}) : super(path: path);

  /// Adds a product to the EAProducts instance
  void addProduct(Product product) {
    _products.add(product);
    payload[EAPropertyKey.PRODUCTS] = _products;
  }
}
