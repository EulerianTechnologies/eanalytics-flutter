library eanalytics;

import 'package:eanalytics/eanalytics.dart';
import 'package:eanalytics/src/models/classes/Search.dart';
import 'package:eanalytics/src/models/keys/EAPropertyKey.dart';

class EASearch extends EAProperty {
  EASearch({required String path, required Search search}) : super(path: path) {
    payload[EAPropertyKey.SEARCH_ENGINE] = search;
  }
}
