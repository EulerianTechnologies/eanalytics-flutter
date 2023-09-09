library eanalytics;

import 'package:eanalytics/eanalytics.dart';

/// EASearch payload
class EASearch extends EAProperty {
  /// Constructor sets the *path* and *isearchengine* properties
  EASearch({required String path, required Search search}) : super(path: path) {
    payload[EAPropertyKey.SEARCH_ENGINE] = search;
  }
}
