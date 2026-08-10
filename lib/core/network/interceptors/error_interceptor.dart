import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../error/exceptions.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    debugPrint('❌ [ErrorInterceptor] ${err.type} → ${err.requestOptions.uri}');

    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        throw const NetworkException(
          message: 'Connection timed out. Please try again.',
        );

      case DioExceptionType.connectionError:
        throw const NetworkException(
          
        );

      case DioExceptionType.badResponse:
        final statusCode = err.response?.statusCode;
        final responseData = err.response?.data;
        final serverMessage = _extractServerMessage(responseData);

        if (statusCode == 401) {
          // Let the AuthInterceptor handle 401s — pass through
          handler.next(err);
          return;
        }

        if (statusCode == 422) {
          throw ValidationException(
            message: serverMessage ?? 'Validation failed.',
            originalError: err,
          );
        }

        throw ServerException(
          message: serverMessage ?? 'Server error occurred.',
          statusCode: statusCode,
          originalError: err,
        );

      case DioExceptionType.cancel:
        debugPrint('ℹ️ Request cancelled: ${err.requestOptions.uri}');
        break;

      default:
        throw ServerException(
          message: 'An unexpected error occurred.',
          originalError: err,
        );
    }

    handler.next(err);
  }

  /// Attempts to extract a human-readable message from the server response.
  String? _extractServerMessage(dynamic data) {
    if (data == null) return null;
    if (data is Map<String, dynamic>) {
      return data['message'] as String? ??
          data['error'] as String? ??
          data['msg'] as String?;
    }
    return null;
  }
}
