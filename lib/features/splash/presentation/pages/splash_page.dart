import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_router.dart';
import '../../../auth/domain/entities/user_profile_entity.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      // Wait momentarily for the initial stream state to settle
      await Future.delayed(const Duration(milliseconds: 800));
      
      final authState = ref.read(authStateChangesProvider);
      final userUid = authState.valueOrNull;

      if (mounted) {
        if (userUid == null) {
          context.goNamed(RouteNames.login);
        } else {
          // Fetch profile
          final profile = await ref.read(getProfileUseCaseProvider)(userUid);
          if (mounted) {
            if (profile != null) {
              ref.read(userProfileProvider.notifier).state = profile;
            } else {
              // Automatically initialize user record if authenticated but Firestore config is missing
              final autoProfile = UserProfileEntity(
                uid: userUid,
                name: 'User',
                email: 'authenticated@user.com',
                createdAt: DateTime.now(),
              );
              ref.read(userProfileProvider.notifier).state = autoProfile;
            }
            context.goNamed(RouteNames.dashboard);
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Initialization Error: ${e.toString()}')),
        );
        // Fallback to login screen on error
        context.goNamed(RouteNames.login);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
