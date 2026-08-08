import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/config/env_config.dart';
import 'core/router/app_router.dart';
import 'core/services/hive_service.dart';
import 'core/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await EnvConfig.initialize();
  await HiveService.init();

  runApp(
    const ProviderScope(
      child: SmartTaskManagerApp(),
    ),
  );
}

class SmartTaskManagerApp extends ConsumerWidget {
  const SmartTaskManagerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return MaterialApp.router(
      title: 'Smart Task Manager',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      routerConfig: AppRouter.router,
    );
  }
}
