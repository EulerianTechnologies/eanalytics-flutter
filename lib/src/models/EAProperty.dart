library eanalytics;

import 'package:eanalytics/src/models/classes/Action.dart';
import 'package:eanalytics/src/models/classes/SiteCentric.dart';
import 'package:eanalytics/src/utils/serializable.dart';
import 'EAGlobalParams.dart';
import 'keys/EAPropertyKey.dart';

class EAProperty with Serializable<EAPropertyKey, dynamic> {
  EAProperty({required String path}) {
    setPath(path);
    payload.addAll(EAGlobalParams.build());
  }

  void setPath(String path) {
    assert(path.isNotEmpty, 'Path must not be null or empty');
    payload[EAPropertyKey.PAGE_PATH] = '${path.startsWith('/') ? '' : '/'}$path';
  }

  void setLocation({required double latitude, required double longitude}) {
    payload[EAPropertyKey.PAGE_LATITUDE] = latitude;
    payload[EAPropertyKey.PAGE_LONGITUDE] = longitude;
  }

  void setNewCustomer(bool isNew) {
    payload[EAPropertyKey.PAGE_NEW_CUSTOMER] = isNew ? 1 : 0;
  }

  void setEmail(String email) {
    payload[EAPropertyKey.PAGE_EMAIL] = email;
  }

  void setUID(String uid) {
    payload[EAPropertyKey.PAGE_UID] = uid;
  }

  void setProfile(String profile) {
    payload[EAPropertyKey.PAGE_PROFILE] = profile;
  }

  void setPageGroup(String group) {
    payload[EAPropertyKey.PAGE_GROUP] = group;
  }

  void setAction(Action action) {
    payload[EAPropertyKey.PAGE_ACTION] = action;
  }

  void setProperty(SiteCentric property) {
    payload[EAPropertyKey.PAGE_PROPERTY] = property;
  }

  void setCFlag(SiteCentric cFlag) {
    payload[EAPropertyKey.PAGE_CFLAG] = cFlag;
  }
}
