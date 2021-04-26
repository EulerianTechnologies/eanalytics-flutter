library eanalytics;

class Eulerian {
  static final Eulerian _instance = Eulerian._internal();
  static const SDK_VERSION = "0.0.1";

  bool initialized = false;

  factory Eulerian() {
    return _instance;
  }

  Eulerian._internal();

  static void init() {
    Eulerian._instance.initialized = true;
  }

  static void track() {
    assert(Eulerian._instance.initialized,
        'Eulerian Tracker was not initialized. You must call Eulerian.Init()');

    if (!Eulerian._instance.initialized) return;
  }
}
