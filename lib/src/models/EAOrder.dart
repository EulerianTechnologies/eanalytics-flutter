library eanalytics;

import 'package:eanalytics/eanalytics.dart';
import 'package:eanalytics/src/models/EAEstimate.dart';
import 'package:eanalytics/src/models/keys/EAPropertyKey.dart';

/// EAOrder payload
class EAOrder extends EAEstimate {
  /// Constructor set the *path* and *estimateref* properties
  EAOrder({required String path, required String estimateRef}) : super(path: path, ref: estimateRef) {
    payload.removeWhere((key, _) => key == EAPropertyKey.ESTIMATE);
    setEstimateRef(estimateRef);
  }

  /// Sets the *payment* property
  void setPayment(String payment) {
    payload[EAPropertyKey.ORDER_PAYMENT] = payment;
  }

  /// Sets the *estimateref* property
  void setEstimateRef(String estimateRef) {
    payload[EAPropertyKey.ORDER_ESTIMATE_REF] = estimateRef;
  }
}
