library eanalytics;

import 'package:eanalytics/eanalytics.dart';
import 'package:eanalytics/src/models/classes/Product.dart';
import 'package:eanalytics/src/models/keys/EAPropertyKey.dart';

class EAProducts extends EAProperty {
  List<Product> products = [];

  EAProducts({required String path}) : super(path: path);

  void addProduct(Product product) {
    products.add(product);
    payload[EAPropertyKey.PRODUCTS] = products;
  }
}
