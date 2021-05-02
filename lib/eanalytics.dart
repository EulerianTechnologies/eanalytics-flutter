library eanalytics;

class Eulerian {
  static final Eulerian _instance = Eulerian._internal();
  static const SDK_VERSION = "0.0.1";

  bool initialized = false;
  String? domain;

  factory Eulerian() {
    return _instance;
  }

  Eulerian._internal();

  static void init(String domain) {
    assert(!domain.contains('.eulerian.com'), 'Domain cannot contain ".eulerian.com"');
    assert(!Uri.parse('https://$domain').isAbsolute, 'Domain is not well formed');

    Eulerian._instance.initialized = true;
  }

  static void track() {
    assert(Eulerian._instance.initialized, 'Eulerian Tracker was not initialized. You must call Eulerian.Init()');

    if (!Eulerian._instance.initialized) return;
  }
}
