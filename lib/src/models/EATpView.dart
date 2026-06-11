library eanalytics;

import 'dart:math';
import 'EAProperty.dart';
import 'keys/EAPropertyKey.dart';

// === Keys ===
const KEY_DYNTPVIEW = "dyntpview";
const KEY_TPVIEWPRD = "tpviewprd";

class EATpView extends EAProperty {
  String siteName = "";
  String campaignName = "";
  String placement = "";
  String publisher = "";
  String media = "";
  String category = "";
  String url = "";

   final List<List<dynamic>> tpviewProducts = [];

  EATpView({required String path}) : super(path: path);

  void addProduct(String ref, {int? position}) {
    if (position != null) {
      tpviewProducts.add([ref, position]);
    } else {
      tpviewProducts.add([ref]);
    }
  }

  void setProducts(List<List<dynamic>> products) {
    tpviewProducts.clear();
    tpviewProducts.addAll(products);
  }

  // ---------------- FACTORY ----------------
  factory EATpView.fromRawData(Map<String, dynamic> raw) {
    final view = EATpView(path: raw['path'] ?? "");

    final props = raw['properties']?[KEY_DYNTPVIEW];
    if (props is Map<String, dynamic>) {
      view.siteName = props['siteName'] ?? "";
      view.campaignName = props['campaign'] ?? "";
      view.placement = props['placement'] ?? "";
      view.publisher = props['publisher'] ?? "";
      view.media = props['media'] ?? "";
      view.category = props['category'] ?? "";
      view.url = props['url'] ?? "";
    }

    final prods = raw['properties']?[KEY_TPVIEWPRD];
    if (prods is List) {
      for (var p in prods) {
        if (p is List) {
          view.tpviewProducts.add(p);
        }
      }
    }

    return view;
  }

  // ---------------- SERIALIZATION ----------------
  Map<String, dynamic> toMap() {
    return {
      KEY_DYNTPVIEW: [
        siteName,
        campaignName,
        placement,
        publisher,
        media,
        category,
        url,
      ],
      KEY_TPVIEWPRD: tpviewProducts,
    };
  }

  void build() {
    payload[EAPropertyKey.custom(KEY_DYNTPVIEW)] =
        toMap()[KEY_DYNTPVIEW];
    payload[EAPropertyKey.custom(KEY_TPVIEWPRD)] =
        tpviewProducts;
  }

  // ---------------- QUERY STRING ----------------
  String toQueryString() {
    final randomNum = Random().nextInt(1000000000);

    final params = <String>[];

    for (int i = 0; i < tpviewProducts.length; i++) {
      final prod = tpviewProducts[i];

      final ref = prod[0];
      final pos = prod.length > 1 ? prod[1] : null;

      params.add("evprdr$i=${Uri.encodeComponent('$ref')}");

      if (pos != null) {
        params.add("evprdpos$i=$pos");
      }
    }

    /* unlike tpclick (eurl = landing url), tpview sends the
       current page url on the "url" parameter */
    if (url.isNotEmpty) {
      params.add("url=${Uri.encodeComponent(url)}");
    }

    final global = globalQueryString();
    if (global.isNotEmpty) params.add(global);

    return "${Uri.encodeComponent(siteName)}/${Uri.encodeComponent(campaignName)}/${Uri.encodeComponent(placement)}/${Uri.encodeComponent(siteName)}/generic/$randomNum?${params.join('&')}";
  }
}