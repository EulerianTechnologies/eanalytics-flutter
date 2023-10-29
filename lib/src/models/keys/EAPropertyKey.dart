library eanalytics;

class EAPropertyKey {
  final String value;

  const EAPropertyKey._(this.value);

  static const EAPropertyKey EOS = EAPropertyKey._("eos");
  static const EAPropertyKey EHW = EAPropertyKey._("ehw");
  static const EAPropertyKey EUIDL = EAPropertyKey._("euidl");
  static const EAPropertyKey URL = EAPropertyKey._("url");
  static const EAPropertyKey APPNAME = EAPropertyKey._("ea-appname");
  static const EAPropertyKey EPOCH = EAPropertyKey._("ereplay-time");
  static const EAPropertyKey APP_VERSION = EAPropertyKey._("ea-appversion");
  static const EAPropertyKey SDK_VERSION =
      EAPropertyKey._("ea-flutter-sdk-version");
  static const EAPropertyKey PAGE_LATITUDE = EAPropertyKey._("ea-lat");
  static const EAPropertyKey PAGE_LONGITUDE = EAPropertyKey._("ea-lon");
  static const EAPropertyKey PAGE_PATH = EAPropertyKey._("path");
  static const EAPropertyKey PAGE_EMAIL = EAPropertyKey._("email");
  static const EAPropertyKey PAGE_UID = EAPropertyKey._("uid");
  static const EAPropertyKey PAGE_PROFILE = EAPropertyKey._("profile");
  static const EAPropertyKey PAGE_GROUP = EAPropertyKey._("pagegroup");
  static const EAPropertyKey PAGE_ACTION = EAPropertyKey._("action");
  static const EAPropertyKey PAGE_PROPERTY = EAPropertyKey._("property");
  static const EAPropertyKey PAGE_NEW_CUSTOMER = EAPropertyKey._("newcustomer");
  static const EAPropertyKey PAGE_CFLAG = EAPropertyKey._("cflag");
  static const EAPropertyKey PRODUCTS = EAPropertyKey._("products");
  static const EAPropertyKey ESTIMATE_PRODUCTS = EAPropertyKey._("products");
  static const EAPropertyKey PRODUCT_REF = EAPropertyKey._("ref");
  static const EAPropertyKey ACTION_REF = EAPropertyKey._("ref");
  static const EAPropertyKey ESTIMATE_REF = EAPropertyKey._("ref");
  static const EAPropertyKey PRODUCT_NAME = EAPropertyKey._("search");
  static const EAPropertyKey SEARCH_NAME = EAPropertyKey._("search");
  static const EAPropertyKey PRODUCT_PARAMS = EAPropertyKey._("params");
  static const EAPropertyKey SEARCH_PARAMS = EAPropertyKey._("params");
  static const EAPropertyKey PRODUCT_GROUP = EAPropertyKey._("group");
  static const EAPropertyKey CART_SCART = EAPropertyKey._("scart");
  static const EAPropertyKey CART_CUMUL = EAPropertyKey._("scartcumul");
  static const EAPropertyKey PRODUCT_AMOUNT = EAPropertyKey._("amount");
  static const EAPropertyKey ESTIMATE_AMOUNT = EAPropertyKey._("amount");
  static const EAPropertyKey PRODUCT_QUANTITY = EAPropertyKey._("quantity");
  static const EAPropertyKey ACTION_IN = EAPropertyKey._("in");
  static const EAPropertyKey ACTION_OUT = EAPropertyKey._("out");
  static const EAPropertyKey SEARCH_RESULTS = EAPropertyKey._("results");
  static const EAPropertyKey SEARCH_ENGINE = EAPropertyKey._("isearchengine");
  static const EAPropertyKey ESTIMATE = EAPropertyKey._("estimate");
  static const EAPropertyKey ESTIMATE_CURRENCY = EAPropertyKey._("currency");
  static const EAPropertyKey ESTIMATE_TYPE = EAPropertyKey._("type");
  static const EAPropertyKey ORDER_ESTIMATE_REF =
      EAPropertyKey._("estimateref");
  static const EAPropertyKey ORDER_PAYMENT = EAPropertyKey._("payment");
  static const EAPropertyKey IOS_IDFV = EAPropertyKey._("ea-ios-idfv");
  static const EAPropertyKey IOS_ADID = EAPropertyKey._("ea-ios-idfa");
  static const EAPropertyKey ANDROID_ADID = EAPropertyKey._("ea-android-adid");

  // Define a custom property
  static EAPropertyKey custom(String customValue) {
    return EAPropertyKey._(customValue);
  }
}

extension EAPropertyKeyExtension on EAPropertyKey {
  // Property name getter
  String get name {
    return value;
  }
}
