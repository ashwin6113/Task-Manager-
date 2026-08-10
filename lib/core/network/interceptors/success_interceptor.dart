import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class SuccessInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint(
      '✅ [SuccessInterceptor] '
      '${response.statusCode} → ${response.requestOptions.uri}',
    );

    // TODO: If the API wraps responses in an envelope like:
    //   { "status": "success", "data": { ... } }
    // you can unwrap it here so data sources always receive the inner payload:
    //
    // if (response.data is Map<String, dynamic> &&
    //     response.data.containsKey('data')) {
    //   response.data = response.data['data'];
    // }

    handler.next(response);
  }
}
