import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/usecase.dart';
import '../../domain/entities/user_profile_entity.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import 'auth_provider.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthState {

  const AuthState({
    required this.status,
    this.errorMessage,
    this.userProfile,
  });

  factory AuthState.initial() => const AuthState(status: AuthStatus.initial);
  final AuthStatus status;
  final String? errorMessage;
  final UserProfileEntity? userProfile;

  AuthState copyWith({
    AuthStatus? status,
    String? errorMessage,
    UserProfileEntity? userProfile,
  }) {
    return AuthState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      userProfile: userProfile ?? this.userProfile,
    );
  }
}

class AuthController extends StateNotifier<AuthState> {

  AuthController(this._ref)
      : _loginUseCase = _ref.read(loginUseCaseProvider),
        _registerUseCase = _ref.read(registerUseCaseProvider),
        _logoutUseCase = _ref.read(logoutUseCaseProvider),
        super(AuthState.initial());
  final Ref _ref;
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final LogoutUseCase _logoutUseCase;

  Future<void> login(String email, String password) async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      final profile = await _loginUseCase(LoginParams(email: email, password: password));
      _ref.read(userProfileProvider.notifier).state = profile;
      state = state.copyWith(status: AuthStatus.authenticated, userProfile: profile);
    } on AppException catch (e) {
      state = state.copyWith(status: AuthStatus.error, errorMessage: '[${e.code ?? "Error"}] ${e.message}');
    } catch (e) {
      state = state.copyWith(status: AuthStatus.error, errorMessage: 'An unexpected authentication error occurred.');
    }
  }

  Future<void> register(String name, String email, String password) async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      final profile = await _registerUseCase(RegisterParams(
        name: name,
        email: email,
        password: password,
      ),);
      _ref.read(userProfileProvider.notifier).state = profile;
      state = state.copyWith(status: AuthStatus.authenticated, userProfile: profile);
    } on AppException catch (e) {
      state = state.copyWith(status: AuthStatus.error, errorMessage: '[${e.code ?? "Error"}] ${e.message}');
    } catch (e) {
      state = state.copyWith(status: AuthStatus.error, errorMessage: 'Registration failed. Please check your credentials.');
    }
  }

  Future<void> logout() async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      await _logoutUseCase(const NoParams());
      _ref.read(userProfileProvider.notifier).state = null;
      state = state.copyWith(status: AuthStatus.unauthenticated);
    } on AppException catch (e) {
      state = state.copyWith(status: AuthStatus.error, errorMessage: e.message);
    } catch (e) {
      state = state.copyWith(status: AuthStatus.error, errorMessage: 'Failed to sign out safely.');
    }
  }
}

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>((ref) {
  return AuthController(ref);
});
