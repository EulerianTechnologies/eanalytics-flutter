library eanalytics;

import 'dart:math';
import 'EAProperty.dart';
import 'keys/EAPropertyKey.dart';

// === Keys ===
const KEY_DYNTPCLICK = "dyntpclick";
const KEY_TPCLICKPRODUCT = "tpclickproduct";

const KEY_PRODUCT_REF = "ecprdr";
const KEY_PRODUCT_POS = "ecpos";
const KEY_TOTAL_PRODUCT = "ecnbr";

class EATpClick extends EAProperty {
  String siteName = "";
  String campaignName = "";
  String placement = "";
  String publisher = "";
  String media = "";
  String category = "";
  String url = "";

   Map<String, dynamic> product = {
    "ref": "",
    "position": 0,
  };


  EATpClick({required String path}) : super(path: path);

  // ---------------- PRODUCT ----------------
  void setProduct(String ref, int position, {int? totalProducts}) {
    this.product = {
      "ref": ref,
      "position": position,
      if (totalProducts != null) "totalProducts": totalProducts,
    };
  }

  void setProductMap(Map<String, dynamic> product) {
    this.product = product;
  }

  // ---------------- FACTORY ----------------
  factory EATpClick.fromRawData(Map<String, dynamic> raw) {
    final click = EATpClick(path: raw['path'] ?? "");

    final props = raw['properties']?[KEY_DYNTPCLICK];
    if (props is Map<String, dynamic>) {
      click.siteName = props['siteName'] ?? "";
      click.campaignName = props['campaign'] ?? "";
      click.placement = props['placement'] ?? "";
      click.publisher = props['publisher'] ?? "";
      click.media = props['media'] ?? "";
      click.category = props['category'] ?? "";
      click.url = props['url'] ?? "";
    }

    final p = raw['properties']?[KEY_TPCLICKPRODUCT];
    if (p is Map<String, dynamic>) {
      click.product = p;
    }

    return click;
  }

  // ---------------- SERIALIZATION ----------------
  Map<String, dynamic> toMap() {
    return {
      KEY_DYNTPCLICK: [
        siteName,
        campaignName,
        placement,
        publisher,
        media,
        category,
        product,
      ]
    };
  }

  void build() {
    payload[EAPropertyKey.custom(KEY_DYNTPCLICK)] =
        toMap()[KEY_DYNTPCLICK];
  }

  // ---------------- QUERY STRING ----------------
  String toQueryString() {
    final randomNum = Random().nextInt(1000000000);

    String qs =
        "${Uri.encodeComponent(siteName)}/${Uri.encodeComponent(campaignName)}/${Uri.encodeComponent(placement)}/${Uri.encodeComponent(siteName)}/generic/$randomNum?";

    qs +=
        "$KEY_PRODUCT_REF=${Uri.encodeComponent(product["ref"])}&$KEY_PRODUCT_POS=${product["position"]}&";

    if (product["totalProducts"] != null) {
      qs += "$KEY_TOTAL_PRODUCT=${product["totalProducts"]}&";
    }

    if (url.isNotEmpty) {
      qs += "url=${Uri.encodeComponent(url)}&";
    }

    return qs;
  }
}