library eanalytics;

import 'package:eanalytics/eanalytics.dart';
import 'package:eanalytics/src/models/keys/EAPropertyKey.dart';
import 'package:eanalytics/src/utils/serializable.dart';

class Search with Serializable<EAPropertyKey, dynamic> {
  Search({required name, int? results, Params? parameters}) {
    setName(name);
    if (results != null) setResults(results);
    if (parameters != null) setParams(parameters);
  }

  void setName(String name) {
    payload[EAPropertyKey.SEARCH_NAME] = name;
  }

  void setResults(int results) {
    payload[EAPropertyKey.SEARCH_RESULTS] = results;
  }

  void setParams(Params parameters) {
    payload[EAPropertyKey.SEARCH_PARAMS] = parameters;
  }
}
