library eanalytics;

import 'dart:math';
import 'EAProperty.dart';
import 'keys/EAPropertyKey.dart';

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

  // ---------------- STORAGE SERIALIZATION ----------------
  Map<String, dynamic> toStorageJson() {
    return {
      '_ea_kind': 'tpview',
      '_ea_merch': {
        'siteName': siteName,
        'campaignName': campaignName,
        'placement': placement,
        'publisher': publisher,
        'media': media,
        'category': category,
        'url': url,
        'products': tpviewProducts,
        'uid': payload[EAPropertyKey.PAGE_UID],
      },
    };
  }

  factory EATpView.fromStorageJson(Map<String, dynamic> raw) {
    final merch =
        (raw['_ea_merch'] as Map?)?.cast<String, dynamic>() ?? const {};

    final view = EATpView(path: '')
      ..siteName = merch['siteName'] ?? ''
      ..campaignName = merch['campaignName'] ?? ''
      ..placement = merch['placement'] ?? ''
      ..publisher = merch['publisher'] ?? ''
      ..media = merch['media'] ?? ''
      ..category = merch['category'] ?? ''
      ..url = merch['url'] ?? '';

    final products = merch['products'];
    if (products is List) {
      for (final p in products) {
        if (p is List) view.tpviewProducts.add(List<dynamic>.from(p));
      }
    }

    final uid = merch['uid'];
    if (uid is String && uid.isNotEmpty) view.setUID(uid);

    return view;
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