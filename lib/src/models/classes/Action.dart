library eanalytics;

import 'package:eanalytics/src/models/classes/Params.dart';
import 'package:eanalytics/src/models/keys/EAPropertyKey.dart';
import 'package:eanalytics/src/utils/serializable.dart';

/// Action helper class
class Action with Serializable<EAPropertyKey, dynamic> {
  /// Constructor sets the *ref*, *in* and *out*? properties
  Action(
      {required String name,
      String ?mode,
      String ?label,
      String ?ref }) {
    assert(name.isNotEmpty,
        "Action 'name' must be valid.");

    setName(name);

    if (mode != null) setMode(mode);
    if (label != null) setLabel(label);
    if (ref != null) setRef(ref);
  }

  /// Sets the *name* property
  void setName(String name) {
    payload[EAPropertyKey.ACTION_NAME] = name;
  }

  /// Sets the *mode* property
  void setMode(String actionMode) {
    payload[EAPropertyKey.ACTION_MODE] = actionMode;
  }

  /// Sets the *out* property
  void setLabel(String label) {
    payload[EAPropertyKey.ACTION_LABEL] = label;
  }

  /// Sets the *ref* property
  void setRef(String actionRef) {
    payload[EAPropertyKey.ACTION_REF] = actionRef;
  }

  /// Sets the *params* property
  void setParams(Params parameters) {
    payload[EAPropertyKey.ACTION_PARAMS] = parameters;
  }
}
