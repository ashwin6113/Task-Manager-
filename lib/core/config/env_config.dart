import 'dart:convert';
import 'package:flutter/services.dart';

import '../constants/type.dart';

enum Environment { dev, uat, prod }

class EnvConfig {

  const EnvConfig._({
    required this.environment,
    required this.appName,
    required this.apiUrl,
    required this.webUrl,
    required this.version,
  });
  final Environment environment;
  final String appName;
  final String apiUrl;
  final String webUrl;
  final String version;

  static late final EnvConfig instance;

  static Future<void> initialize() async {
    const envString = String.fromEnvironment('ENV', defaultValue: 'dev');
    final Environment env;
    final String configPath;
    final String appName;

    switch (envString) {
      case 'prod':
        env = Environment.prod;
        configPath = '.environment/prod.json';
        appName = 'Smart Task Manager';
        break;
      case 'uat':
        env = Environment.uat;
        configPath = '.environment/uat.json';
        appName = 'Smart Task Manager [UAT]';
        break;
      case 'dev':
      default:
        env = Environment.dev;
        configPath = '.environment/dev.json';
        appName = 'Smart Task Manager [DEV]';
        break;
    }

    try {
      final configString = await rootBundle.loadString(configPath);
      final JSONObject configJson = jsonDecode(configString);

      instance = EnvConfig._(
        environment: env,
        appName: appName,
        apiUrl: configJson['apiUrl'] as String? ?? '',
        webUrl: configJson['webUrl'] as String? ?? '',
        version: configJson['version'] as String? ?? '',
      );
    } catch (e) {
      // Fallback defaults if the asset cannot be loaded during tests or boot errors
      instance = EnvConfig._(
        environment: env,
        appName: appName,
        apiUrl: env == Environment.prod
            ? 'https://api.smarttaskmanager.com'
            : env == Environment.uat
                ? 'https://api-uat.smarttaskmanager.com'
                : 'https://api-dev.smarttaskmanager.com',
        webUrl: env == Environment.prod
            ? 'https://smarttaskmanager.com'
            : env == Environment.uat
                ? 'https://uat.smarttaskmanager.com'
                : 'https://dev.smarttaskmanager.com',
        version: 'v1',
      );
    }
  }

  bool get isDev => environment == Environment.dev;
  bool get isUat => environment == Environment.uat;
  bool get isProd => environment == Environment.prod;
}
