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
  PRODUCT_GROUP
}

extension EAPropertyKeyExtension on EAPropertyKey {
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
        return 'products';
      case EAPropertyKey.PRODUCT_REF:
        return 'ref';
      case EAPropertyKey.PRODUCT_NAME:
        return 'name';
      case EAPropertyKey.PRODUCT_PARAMS:
        return 'params';
      case EAPropertyKey.PRODUCT_GROUP:
        return 'group';
    }
  }
}
