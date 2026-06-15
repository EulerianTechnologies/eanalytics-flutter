library eanalytics;

import 'dart:math';
import 'EAProperty.dart';
import 'keys/EAPropertyKey.dart';

// === Keys ===
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

  // ---------------- STORAGE SERIALIZATION ----------------
  Map<String, dynamic> toStorageJson() {
    return {
      '_ea_kind': 'tpclick',
      '_ea_merch': {
        'siteName': siteName,
        'campaignName': campaignName,
        'placement': placement,
        'publisher': publisher,
        'media': media,
        'category': category,
        'url': url,
        'product': product,
        'uid': payload[EAPropertyKey.PAGE_UID],
      },
    };
  }

  factory EATpClick.fromStorageJson(Map<String, dynamic> raw) {
    final merch =
        (raw['_ea_merch'] as Map?)?.cast<String, dynamic>() ?? const {};

    final click = EATpClick(path: '')
      ..siteName = merch['siteName'] ?? ''
      ..campaignName = merch['campaignName'] ?? ''
      ..placement = merch['placement'] ?? ''
      ..publisher = merch['publisher'] ?? ''
      ..media = merch['media'] ?? ''
      ..category = merch['category'] ?? ''
      ..url = merch['url'] ?? '';

    final product = merch['product'];
    if (product is Map) click.product = Map<String, dynamic>.from(product);

    final uid = merch['uid'];
    if (uid is String && uid.isNotEmpty) click.setUID(uid);

    return click;
  }

  // ---------------- QUERY STRING ----------------
  String toQueryString() {
    final randomNum = Random().nextInt(1000000000);

    final params = <String>[
      "$KEY_PRODUCT_REF=${Uri.encodeComponent('${product["ref"] ?? ''}')}",
      "$KEY_PRODUCT_POS=${product["position"] ?? 0}",
    ];

    if (product["totalProducts"] != null) {
      params.add("$KEY_TOTAL_PRODUCT=${product["totalProducts"]}");
    }

    if (url.isNotEmpty) {
      params.add("eurl=${Uri.encodeComponent(url)}");
    }

    final global = globalQueryString();
    if (global.isNotEmpty) params.add(global);

    return "${Uri.encodeComponent(siteName)}/${Uri.encodeComponent(campaignName)}/${Uri.encodeComponent(placement)}/${Uri.encodeComponent(siteName)}/generic/$randomNum?${params.join('&')}";
  }
}