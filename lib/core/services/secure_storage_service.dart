import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../constants/app_constants.dart';
class SecureStorageService {
  SecureStorageService._();

  static const _storage = FlutterSecureStorage();

  static Future<String?> read(String key) => _storage.read(key: key);

  static Future<void> write(String key, String value) =>
      _storage.write(key: key, value: value);

  static Future<void> delete(String key) => _storage.delete(key: key);

  static Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await Future.wait([
      write(AppConstants.accessTokenKey, accessToken),
      write(AppConstants.refreshTokenKey, refreshToken),
    ]);
  }

  static Future<String?> getAccessToken() =>
      read(AppConstants.accessTokenKey);

  static Future<String?> getRefreshToken() =>
      read(AppConstants.refreshTokenKey);

  static Future<void> clearTokens() async {
    await Future.wait([
      delete(AppConstants.accessTokenKey),
      delete(AppConstants.refreshTokenKey),
    ]);
  }
}
