import 'dart:convert';
import 'dart:io';
import 'package:eanalytics/src/utils/logger.dart';
import 'package:eanalytics/src/utils/time.dart';
import 'package:http/http.dart' as http;

typedef Future<void> OnResultCallback(List<Map<String, dynamic>> body);
typedef Future<void> PostHandler(List<Map<String, dynamic>> body,
    {OnResultCallback onSuccess, OnResultCallback onFail});

PostHandler createPostHandler(String domain, EALogger logger) {
  return (body, {OnResultCallback? onSuccess, OnResultCallback? onFail}) async {
    final url = Uri.https(domain, 'collectorjson/-/${getSecondsSinceEpoch()}');
    try {
      logger.debug('post request on $url');

      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode != 200) throw HttpException('${response.statusCode}');
      if (onSuccess != null) await onSuccess(body);
    } catch (e) {
      logger.error('Error on post request to ${url.toString()} - ${e.toString()}');
      if (onFail != null) await onFail(body);
    }
  };
}
