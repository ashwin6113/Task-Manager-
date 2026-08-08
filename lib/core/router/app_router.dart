import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'app_router_path.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: RoutePaths.splash,
    debugLogDiagnostics: true,

    // TODO: Phase 2 — Add auth redirect:
    // redirect: (context, state) {
    //   final isLoggedIn = ref.read(authStateProvider);
    //   final isAuthRoute = state.matchedLocation == RoutePaths.login;
    //   if (!isLoggedIn && !isAuthRoute) return RoutePaths.login;
    //   if (isLoggedIn && isAuthRoute) return RoutePaths.dashboard;
    //   return null;
    // },

    routes: [
      GoRoute(
        path: RoutePaths.splash,
        name: RouteNames.splash,
        builder: (context, state) => const _PlaceholderPage(title: 'Splash'),
      ),
      GoRoute(
        path: RoutePaths.login,
        name: RouteNames.login,
        builder: (context, state) => const _PlaceholderPage(title: 'Login'),
      ),
      GoRoute(
        path: RoutePaths.register,
        name: RouteNames.register,
        builder: (context, state) => const _PlaceholderPage(title: 'Register'),
      ),
      GoRoute(
        path: RoutePaths.dashboard,
        name: RouteNames.dashboard,
        builder: (context, state) =>
            const _PlaceholderPage(title: 'Dashboard'),
      ),
      GoRoute(
        path: RoutePaths.taskDetails,
        name: RouteNames.taskDetails,
        builder: (context, state) {
          final taskId = state.pathParameters['taskId'] ?? '';
          return _PlaceholderPage(title: 'Task Details ($taskId)');
        },
      ),
      GoRoute(
        path: RoutePaths.profile,
        name: RouteNames.profile,
        builder: (context, state) => const _PlaceholderPage(title: 'Profile'),
      ),
      GoRoute(
        path: RoutePaths.settings,
        name: RouteNames.settings,
        builder: (context, state) =>
            const _PlaceholderPage(title: 'Settings'),
      ),
    ],

    // ── Unknown / 404 route ──
    errorBuilder: (context, state) =>
        const _PlaceholderPage(title: '404 — Page Not Found'),
  );
}

/// Temporary placeholder page. Will be replaced by real feature pages.
class _PlaceholderPage extends StatelessWidget {
  const _PlaceholderPage({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(
          title,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
