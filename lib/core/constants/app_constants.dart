class AppConstants {
  AppConstants._(); // Prevent instantiation

  // ── App Info ──
  static const String appName = 'Smart Task Manager';

  // ── Hive Box Names ──
  static const String taskBoxName = 'tasks_box';
  static const String userBoxName = 'user_box';
  static const String settingsBoxName = 'settings_box';

  // ── Secure Storage Keys ──
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';

  // ── Timeouts ──
  static const Duration connectionTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);

  // ── Pagination ──
  static const int defaultPageSize = 20;
}
