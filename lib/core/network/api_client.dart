import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../error/exceptions.dart';

class ApiClient {

  ApiClient({
    Dio? dio,
    FirebaseAuth? firebaseAuth,
  })  : _dio = dio ?? Dio(
          BaseOptions(
            baseUrl: 'https://taskmanager.uat-lplusltd.com',
            connectTimeout: const Duration(seconds: 15),
            receiveTimeout: const Duration(seconds: 15),
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
            },
          ),
        ),
        _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance {
    // Add logging and query param injector interceptors
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final uid = _firebaseAuth.currentUser?.uid;
          if (uid != null) {
            final queryParams = Map<String, dynamic>.from(options.queryParameters);
            if (!queryParams.containsKey('user_id')) {
              queryParams['user_id'] = uid;
            }
            options.queryParameters = queryParams;
          }
          debugPrint('🚀 [API] ${options.method} → ${options.uri}');
          if (options.data != null) {
            debugPrint('📦 Body: ${options.data}');
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          debugPrint('✅ [API] Response ${response.statusCode} ← ${response.requestOptions.uri}');
          return handler.next(response);
        },
        onError: (err, handler) {
          debugPrint('❌ [API] Error ${err.type} (${err.response?.statusCode}) ← ${err.requestOptions.uri}');
          return handler.next(err);
        },
      ),
    );
  }
  final Dio _dio;
  final FirebaseAuth _firebaseAuth;

  /// Helper to map DioException to custom AppException
  AppException _handleError(dynamic error) {
    if (error is AppException) return error;
    if (error is DioException) {
      final statusCode = error.response?.statusCode;
      final responseData = error.response?.data;
      final message = _extractServerMessage(responseData) ?? error.message ?? 'An error occurred';

      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return NetworkException(
            message: 'Connection timed out. Please try again.',
            originalError: error,
          );
        case DioExceptionType.connectionError:
          return NetworkException(
            originalError: error,
          );
        case DioExceptionType.badResponse:
          if (statusCode == 422) {
            return ValidationException(
              message: message,
              originalError: error,
            );
          }
          return ServerException(
            message: message,
            statusCode: statusCode,
            originalError: error,
          );
        default:
          return ServerException(
            message: message,
            statusCode: statusCode,
            originalError: error,
          );
      }
    }
    return ServerException(
      message: error.toString(),
      originalError: error,
    );
  }

  String? _extractServerMessage(dynamic data) {
    if (data == null) return null;
    if (data is Map<String, dynamic>) {
      if (data['detail'] is List) {
        final details = data['detail'] as List;
        if (details.isNotEmpty && details[0] is Map) {
          final first = details[0] as Map;
          final msg = first['msg'] as String?;
          final loc = first['loc'] as List?;
          if (msg != null && loc != null) {
            return '${loc.join(" ")}: $msg';
          }
          return msg;
        }
      }
      return data['message'] as String? ??
          data['error'] as String? ??
          data['msg'] as String?;
    }
    return null;
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response<T>> delete<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.delete<T>(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      throw _handleError(e);
    }
  }
}
