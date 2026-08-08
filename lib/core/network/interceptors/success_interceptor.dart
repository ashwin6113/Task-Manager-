import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Intercepts successful responses for optional logging or transformation.
///
/// Use this to:
/// • Log success metrics
/// • Unwrap a standard API envelope (e.g., `{ "data": ..., "status": "ok" }`)
/// • Normalize response shapes before they reach the data source layer
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
