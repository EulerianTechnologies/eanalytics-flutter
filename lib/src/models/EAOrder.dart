library eanalytics;

import 'package:eanalytics/eanalytics.dart';
import 'package:eanalytics/src/models/EAEstimate.dart';
import 'package:eanalytics/src/models/keys/EAPropertyKey.dart';

class EAOrder extends EAEstimate {
  List<Product> products = [];
  EAOrder({required String path, required String ref}) : super(path: path, ref: ref) {
    payload.removeWhere((key, _) => key == EAPropertyKey.ESTIMATE);
  }

  void setPayment(String payment) {
    payload[EAPropertyKey.ORDER_PAYMENT] = payment;
  }

  void setEstimateRef(String estimateRef) {
    payload[EAPropertyKey.ORDER_ESTIMATE_REF] = estimateRef;
  }
}
