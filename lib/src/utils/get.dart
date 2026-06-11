import 'dart:io';
import 'package:eanalytics/src/utils/logger.dart';
import 'package:http/http.dart' as http;

typedef Future<void> OnResultCallback(List<Map<String, dynamic>> body);
typedef GetHandler = Future<void> Function(
  String url, {
  OnResultCallback? onSuccess,
  OnResultCallback? onFail,
});

GetHandler createGetHandler(String domain, EALogger logger) {
  return (path, {OnResultCallback? onSuccess, OnResultCallback? onFail}) async {
    final url = Uri.parse("https://$domain$path");

    try {
      logger.debug('get request on $url');

      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
        },
      );

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw HttpException('${response.statusCode}');
      }

      
      if (onSuccess != null) await onSuccess([]);
    } catch (e, s) {
      print(s);
      logger.error(
          'Error on get request to ${url.toString()} - ${e.toString()}');

      if (onFail != null) await onFail([]);
    }
  };
}
