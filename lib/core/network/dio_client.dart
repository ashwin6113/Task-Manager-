import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../config/env_config.dart';
import '../constants/app_constants.dart';
import '../services/secure_storage_service.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/error_interceptor.dart';
import 'interceptors/logging_interceptor.dart';
import 'interceptors/success_interceptor.dart';

class DioClient {
  DioClient({EnvConfig? envConfig}) {
    final config = envConfig ?? EnvConfig.instance;

    _dio = Dio(
      BaseOptions(
        baseUrl: '${config.apiUrl}/${config.version}/',
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'User-Agent': 'SmartTaskManagerMobile/1.0',
        },
        connectTimeout: AppConstants.connectionTimeout,
        receiveTimeout: AppConstants.receiveTimeout,
      ),
    );

    _dio.interceptors.addAll([
      LoggingInterceptor(),
      ErrorInterceptor(),
      SuccessInterceptor(),
      AuthInterceptor(_dio, onRefreshToken: refreshToken),
    ]);
  }

  static Future<bool>? _refreshFuture;

  late final Dio _dio;

  Dio get dio => _dio;

  // ──────────────────────────────────────────────
  //  TOKEN REFRESH
  // ──────────────────────────────────────────────

  Future<bool> refreshToken() async {
    if (_refreshFuture != null) {
      return _refreshFuture!;
    }

    _refreshFuture = _performRefresh();
    try {
      return await _refreshFuture!;
    } finally {
      _refreshFuture = null;
    }
  }

  Future<bool> _performRefresh() async {
    final storedRefreshToken = await SecureStorageService.read(
      AppConstants.refreshTokenKey,
    );
    if (storedRefreshToken == null || storedRefreshToken.isEmpty) return false;

    try {
      debugPrint('🔑 Attempting to refresh token...');
      final refreshDio = Dio(
        BaseOptions(
          baseUrl: _dio.options.baseUrl,
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
      );

      final response = await refreshDio.post(
        'auth/refresh',
        data: {'refreshToken': storedRefreshToken},
      );

      if (response.statusCode == 200) {
        final data = response.data['data'];
        final newAccessToken = data['accessToken'] as String?;
        final newRefreshToken = data['refreshToken'] as String?;

        if (newAccessToken != null && newRefreshToken != null) {
          await SecureStorageService.saveTokens(
            accessToken: newAccessToken,
            refreshToken: newRefreshToken,
          );
          debugPrint(
            '🔑 Access token refreshed and updated in storage.',
          );
          return true;
        }
      }
      debugPrint('❌ Failed to refresh token: ${response.data}');
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 401) {
        debugPrint('❌ Refresh token expired (401). Clearing tokens...');
        await SecureStorageService.clearTokens();
      }
      debugPrint('❌ Error during token refresh: $e');
    }
    return false;
  }

  // ──────────────────────────────────────────────
  //  HTTP CONVENIENCE METHODS
  // ──────────────────────────────────────────────

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.get(path, queryParameters: queryParameters, options: options);
  }

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.put(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response> delete(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.delete(
      path,
      data: {},
      queryParameters: queryParameters,
      options: options,
    );
  }
}
