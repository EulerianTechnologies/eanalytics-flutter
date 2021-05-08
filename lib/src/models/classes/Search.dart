library eanalytics;

import 'package:eanalytics/eanalytics.dart';
import 'package:eanalytics/src/models/keys/EAPropertyKey.dart';
import 'package:eanalytics/src/utils/serializable.dart';

/// Search helper class
class Search with Serializable<EAPropertyKey, dynamic> {
  /// Constructor sets the *name*, *results*?, and *params*? properties
  Search({required name, int? results, Params? parameters}) {
    setName(name);
    if (results != null) setResults(results);
    if (parameters != null) setParams(parameters);
  }

  /// Sets the *name* property
  void setName(String name) {
    payload[EAPropertyKey.SEARCH_NAME] = name;
  }

  /// Sets the *results* property
  void setResults(int results) {
    payload[EAPropertyKey.SEARCH_RESULTS] = results;
  }

  /// Sets the *params* property
  void setParams(Params parameters) {
    payload[EAPropertyKey.SEARCH_PARAMS] = parameters;
  }
}
