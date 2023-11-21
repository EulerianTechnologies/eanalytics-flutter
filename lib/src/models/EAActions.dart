library eanalytics;

import 'package:eanalytics/eanalytics.dart';

/// EAActions payload
class EAActions extends EAProperty {
  List<Action> _actions = [];

  /// Constructor sets the *path* property
  EAActions({required String path}) : super(path: path);

  /// Adds a action to the EAActions instance
  void addAction(Action action) {
    _actions.add(action);
    payload[EAPropertyKey.ACTIONS] = _actions;
  }
}
