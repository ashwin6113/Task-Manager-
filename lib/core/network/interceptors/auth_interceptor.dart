import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../services/secure_storage_service.dart';

class AuthInterceptor extends QueuedInterceptor {

  AuthInterceptor(this._dio, {required this.onRefreshToken});
  final Dio _dio;
  final Future<bool> Function() onRefreshToken;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await SecureStorageService.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      debugPrint('🔒 401 received — attempting token refresh...');

      final refreshed = await onRefreshToken();

      if (refreshed) {
        final newToken = await SecureStorageService.getAccessToken();
        if (newToken != null) {
          err.requestOptions.headers['Authorization'] = 'Bearer $newToken';
        }

        try {
          final response = await _dio.fetch(err.requestOptions);
          return handler.resolve(response);
        } on DioException catch (retryError) {
          return handler.next(retryError);
        }
      }
    }

    handler.next(err);
  }
}
