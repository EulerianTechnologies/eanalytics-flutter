library eanalytics;

import 'package:eanalytics/src/models/keys/EAPropertyKey.dart';
import 'package:eanalytics/src/utils/serializable.dart';

/// Action helper class
class Action with Serializable<EAPropertyKey, dynamic> {
  /// Constructor sets the *ref*, *in* and *out*? properties
  Action(
      {required String actionRef,
      required String actionIn,
      List<String>? actionOut}) {
    assert(actionRef.isNotEmpty && actionIn.isNotEmpty,
        "Action must have at least 'in' or 'ref' parameter set to be valid.");

    setRef(actionRef);
    setIn(actionIn);
    if (actionOut != null) setOut(actionOut);
  }

  /// Sets the *ref* property
  void setRef(String actionRef) {
    payload[EAPropertyKey.ACTION_REF] = actionRef;
  }

  /// Sets the *in* property
  void setIn(String actionIn) {
    payload[EAPropertyKey.ACTION_IN] = actionIn;
  }

  /// Sets the *out* property
  void setOut(List<String> actionOut) {
    payload[EAPropertyKey.ACTION_OUT] = actionOut;
  }
}
