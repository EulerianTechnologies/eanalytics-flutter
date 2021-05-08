library eanalytics;

/// All valid Eulerian payload properties
enum EAPropertyKey {
  EOS,
  EHW,
  EUIDL,
  URL,
  APPNAME,
  EPOCH,
  APP_VERSION,
  ADID,
  SDK_VERSION,
  PAGE_LATITUDE,
  PAGE_LONGITUDE,
  PAGE_PATH,
  PAGE_EMAIL,
  PAGE_UID,
  PAGE_PROFILE,
  PAGE_GROUP,
  PAGE_ACTION,
  PAGE_PROPERTY,
  PAGE_NEW_CUSTOMER,
  PAGE_CFLAG,
  PRODUCTS,
  PRODUCT_REF,
  PRODUCT_NAME,
  PRODUCT_PARAMS,
  PRODUCT_GROUP,
  PRODUCT_QUANTITY,
  PRODUCT_AMOUNT,
  CART_SCART,
  CART_CUMUL,
  ACTION_REF,
  ACTION_IN,
  ACTION_OUT,
  SEARCH_NAME,
  SEARCH_RESULTS,
  SEARCH_PARAMS,
  SEARCH_ENGINE,
  ESTIMATE,
  ESTIMATE_REF,
  ESTIMATE_AMOUNT,
  ESTIMATE_CURRENCY,
  ESTIMATE_TYPE,
  ESTIMATE_PRODUCTS,
  ORDER_ESTIMATE_REF,
  ORDER_PAYMENT
}

/// Enum extension to get property keys.
/// used during serialization of payload
extension EAPropertyKeyExtension on EAPropertyKey {
  /// property name getter
  String get name {
    switch (this) {
      case EAPropertyKey.EOS:
        return "eos";
      case EAPropertyKey.EHW:
        return "ehw";
      case EAPropertyKey.EUIDL:
        return "euidl";
      case EAPropertyKey.URL:
        return "url";
      case EAPropertyKey.APPNAME:
        return "ea-appname";
      case EAPropertyKey.EPOCH:
        return "ereplay-time";
      case EAPropertyKey.APP_VERSION:
        return "ea-appversion";
      case EAPropertyKey.ADID:
        return "ea-flutter-adid";
      case EAPropertyKey.SDK_VERSION:
        return "ea-flutter-sdk-version";
      case EAPropertyKey.PAGE_LATITUDE:
        return "ea-lat";
      case EAPropertyKey.PAGE_LONGITUDE:
        return "ea-lon";
      case EAPropertyKey.PAGE_PATH:
        return "path";
      case EAPropertyKey.PAGE_EMAIL:
        return "email";
      case EAPropertyKey.PAGE_UID:
        return "uid";
      case EAPropertyKey.PAGE_PROFILE:
        return "profile";
      case EAPropertyKey.PAGE_GROUP:
        return "pagegroup";
      case EAPropertyKey.PAGE_ACTION:
        return "action";
      case EAPropertyKey.PAGE_PROPERTY:
        return "property";
      case EAPropertyKey.PAGE_NEW_CUSTOMER:
        return "newcustomer";
      case EAPropertyKey.PAGE_CFLAG:
        return "cflag";
      case EAPropertyKey.PRODUCTS:
      case EAPropertyKey.ESTIMATE_PRODUCTS:
        return "products";
      case EAPropertyKey.PRODUCT_REF:
      case EAPropertyKey.ACTION_REF:
      case EAPropertyKey.ESTIMATE_REF:
        return "ref";
      case EAPropertyKey.PRODUCT_NAME:
      case EAPropertyKey.SEARCH_NAME:
        return "name";
      case EAPropertyKey.PRODUCT_PARAMS:
      case EAPropertyKey.SEARCH_PARAMS:
        return "params";
      case EAPropertyKey.PRODUCT_GROUP:
        return "group";
      case EAPropertyKey.CART_SCART:
        return "scart";
      case EAPropertyKey.CART_CUMUL:
        return "scartcumul";
      case EAPropertyKey.PRODUCT_AMOUNT:
      case EAPropertyKey.ESTIMATE_AMOUNT:
        return "amount";
      case EAPropertyKey.PRODUCT_QUANTITY:
        return "quantity";
      case EAPropertyKey.ACTION_IN:
        return "in";
      case EAPropertyKey.ACTION_OUT:
        return "out";
      case EAPropertyKey.SEARCH_RESULTS:
        return "results";
      case EAPropertyKey.SEARCH_ENGINE:
        return "isearchengine";
      case EAPropertyKey.ESTIMATE:
        return "estimate";
      case EAPropertyKey.ESTIMATE_CURRENCY:
        return "currency";
      case EAPropertyKey.ESTIMATE_TYPE:
        return "type";
      case EAPropertyKey.ORDER_ESTIMATE_REF:
        return "estimateref";
      case EAPropertyKey.ORDER_PAYMENT:
        return "payment";
    }
  }
}
