library eanalytics;

/// All valid Eulerian payload properties
class EAPropertyKey {
  final String name;
  const EAPropertyKey._self( this.name );

  static const EAPropertyKey EOS = EAPropertyKey._self		( "eos" );
  static const EAPropertyKey EHW = EAPropertyKey._self		( "ehw" );
  static const EAPropertyKey EUIDL = EAPropertyKey._self	( "euidl" );
  static const EAPropertyKey URL = EAPropertyKey._self		( "url" );
  static const EAPropertyKey APPNAME = EAPropertyKey._self	( "ea-appname" );
  static const EAPropertyKey EPOCH = EAPropertyKey._self	( "ereplay-time" );
  static const EAPropertyKey NOTAG = EAPropertyKey._self	( "ereplay-notag" );
  static const EAPropertyKey APP_VERSION = EAPropertyKey._self	( "ea-appversion" );
  static const EAPropertyKey SDK_VERSION = EAPropertyKey._self	( "ea-flutter-sdk-version" );
  static const EAPropertyKey PAGE_LATITUDE = EAPropertyKey._self( "ea-lat" );
  static const EAPropertyKey PAGE_LONGITUDE = EAPropertyKey._self( "ea-lon" );
  static const EAPropertyKey PAGE_PATH = EAPropertyKey._self	( "path" );
  static const EAPropertyKey PAGE_EMAIL = EAPropertyKey._self	( "email" );
  static const EAPropertyKey PAGE_UID = EAPropertyKey._self	( "uid" );
  static const EAPropertyKey PAGE_PROFILE = EAPropertyKey._self	( "profile" );
  static const EAPropertyKey PAGE_GROUP = EAPropertyKey._self	( "pagegroup" );
  static const EAPropertyKey PAGE_LABEL = EAPropertyKey._self	( "pagelabel" );
  static const EAPropertyKey PAGE_ACTION = EAPropertyKey._self	( "action" );
  static const EAPropertyKey PAGE_PROPERTY = EAPropertyKey._self( "property" );
  static const EAPropertyKey PAGE_NEW_CUSTOMER = EAPropertyKey._self( "newcustomer" );
  static const EAPropertyKey PAGE_CFLAG = EAPropertyKey._self	( "cflag" );
  static const EAPropertyKey PRODUCTS = EAPropertyKey._self	( "products" );
  static const EAPropertyKey PRODUCT_REF = EAPropertyKey._self	( "ref" );
  static const EAPropertyKey PRODUCT_NAME = EAPropertyKey._self	( "name" );
  static const EAPropertyKey PRODUCT_PARAMS = EAPropertyKey._self( "params" );
  static const EAPropertyKey PRODUCT_GROUP = EAPropertyKey._self( "group" );
  static const EAPropertyKey PRODUCT_QUANTITY = EAPropertyKey._self( "quantity" );
  static const EAPropertyKey PRODUCT_AMOUNT = EAPropertyKey._self( "amount" );
  static const EAPropertyKey CART_SCART = EAPropertyKey._self	( "scart" );
  static const EAPropertyKey CART_CUMUL = EAPropertyKey._self	( "scartcumul" );
  static const EAPropertyKey ACTIONS = EAPropertyKey._self	( "actions" );
  static const EAPropertyKey ACTION_REF = EAPropertyKey._self	( "ref" );
  static const EAPropertyKey ACTION_MODE = EAPropertyKey._self	( "mode" );
  static const EAPropertyKey ACTION_NAME = EAPropertyKey._self	( "name" );
  static const EAPropertyKey ACTION_LABEL = EAPropertyKey._self	( "label" );
  static const EAPropertyKey ACTION_PARAMS = EAPropertyKey._self ( "params" );
  static const EAPropertyKey SEARCH_NAME = EAPropertyKey._self	( "name" );
  static const EAPropertyKey SEARCH_RESULTS = EAPropertyKey._self( "results" );
  static const EAPropertyKey SEARCH_PARAMS = EAPropertyKey._self( "params" );
  static const EAPropertyKey SEARCH_ENGINE = EAPropertyKey._self( "isearchengine" );
  static const EAPropertyKey ESTIMATE = EAPropertyKey._self	( "estimate" );
  static const EAPropertyKey ESTIMATE_REF = EAPropertyKey._self	( "ref" );
  static const EAPropertyKey ESTIMATE_AMOUNT = EAPropertyKey._self( "amount" );
  static const EAPropertyKey ESTIMATE_CURRENCY = EAPropertyKey._self( "currency" );
  static const EAPropertyKey ESTIMATE_TYPE = EAPropertyKey._self( "type" );
  static const EAPropertyKey ESTIMATE_PRODUCTS = EAPropertyKey._self( "products" );
  static const EAPropertyKey ESTIMATE_PAYMENT = EAPropertyKey._self( "payment" );
  static const EAPropertyKey ORDER_REF = EAPropertyKey._self	( "ref" );
  static const EAPropertyKey ORDER_AMOUNT = EAPropertyKey._self	( "amount" );
  static const EAPropertyKey ORDER_CURRENCY = EAPropertyKey._self( "currency" );
  static const EAPropertyKey ORDER_TYPE = EAPropertyKey._self	( "type" );
  static const EAPropertyKey ORDER_PRODUCTS = EAPropertyKey._self( "products" );
  static const EAPropertyKey ORDER_PAYMENT = EAPropertyKey._self( "payment" );
  static const EAPropertyKey ORDER_ESTIMATE_REF = EAPropertyKey._self( "estimateref" );
  static const EAPropertyKey IOS_IDFV = EAPropertyKey._self	( "ea-ios-idfv" );
  static const EAPropertyKey IOS_ADID = EAPropertyKey._self	( "ea-ios-idfa" );
  static const EAPropertyKey ANDROID_ADID = EAPropertyKey._self	( "ea-android-adid" );
  static const EAPropertyKey INSTALL_REFERRER = EAPropertyKey._self	( "ea-android-referrer" );

  static EAPropertyKey custom(String v) {
    return EAPropertyKey._self( v );
  }
}

