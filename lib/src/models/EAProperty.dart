library eanalytics;

import 'package:eanalytics/src/models/classes/Action.dart';
import 'package:eanalytics/src/models/classes/SiteCentric.dart';
import 'package:eanalytics/src/utils/serializable.dart';
import 'EAGlobalParams.dart';
import 'keys/EAPropertyKey.dart';

/// Every Eulerian properties inherits from this base class
class EAProperty with Serializable<EAPropertyKey, dynamic> {
  /// Constructor sets the *path* property
  EAProperty({required String path}) {
    setPath(path);
    payload.addAll(EAGlobalParams.build());
  }

  /// Sets the *path* property
  void setPath(String path) {
    if (! path.isNotEmpty) path = '';
    payload[EAPropertyKey.PAGE_PATH] =
        '${path.startsWith('/') ? '' : '/'}$path';
  }

  /// Sets the *ea-lon* and *ea-lat* properties
  void setLocation({required double latitude, required double longitude}) {
    payload[EAPropertyKey.PAGE_LATITUDE] = latitude;
    payload[EAPropertyKey.PAGE_LONGITUDE] = longitude;
  }

  /// Sets the *newcustomer* property
  void setNewCustomer(bool isNew) {
    payload[EAPropertyKey.PAGE_NEW_CUSTOMER] = isNew ? 1 : 0;
  }

  /// Sets the *notag* property
  void setStandalone() {
    payload[EAPropertyKey.NOTAG] = 1;
  }

  /// Sets the *email* property
  void setEmail(String email) {
    payload[EAPropertyKey.PAGE_EMAIL] = email;
  }

  /// Sets the *out* property
  void setLabel(String label) {
    payload[EAPropertyKey.PAGE_LABEL] = label;
  }

  /// Sets the *uid* property
  void setUID(String uid) {
    payload[EAPropertyKey.PAGE_UID] = uid;
  }

  /// Sets the *profile* property
  void setProfile(String profile) {
    payload[EAPropertyKey.PAGE_PROFILE] = profile;
  }

  /// Sets the *pagegroup* property
  void setPageGroup(String group) {
    payload[EAPropertyKey.PAGE_GROUP] = group;
  }

  /// Sets the *action* property
  void setAction(Action action) {
    payload[EAPropertyKey.PAGE_ACTION] = action;
  }

  /// Sets the *property* property
  void setProperty(SiteCentric property) {
    payload[EAPropertyKey.PAGE_PROPERTY] = property;
  }

  /// Sets the *cflag* property
  void setCFlag(SiteCentric cFlag) {
    payload[EAPropertyKey.PAGE_CFLAG] = cFlag;
  }

  // Set custom k/v
  // key is not EAPropertyKey - serializable.dart (toJSON) as String
  void setCustomParam(String k, String v) {
    payload[ EAPropertyKey.custom(k) ] = v;
  }
}
