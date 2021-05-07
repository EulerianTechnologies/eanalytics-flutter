library eanalytics;

import 'package:eanalytics/src/models/keys/EAPropertyKey.dart';
import 'package:eanalytics/src/utils/serializable.dart';

class Action with Serializable<EAPropertyKey, dynamic> {
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

  void setRef(String actionRef) {
    payload[EAPropertyKey.ACTION_REF] = actionRef;
  }

  void setIn(String actionIn) {
    payload[EAPropertyKey.ACTION_IN] = actionIn;
  }

  void setOut(List<String> actionOut) {
    payload[EAPropertyKey.ACTION_OUT] = actionOut;
  }
}
