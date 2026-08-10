import '../../../../core/utils/usecase.dart';
import '../../domain/entities/user_profile_entity.dart';
import '../../domain/repositories/auth_repository.dart';

class LoginParams {
  const LoginParams({required this.email, required this.password});
  final String email;
  final String password;
}

class LoginUseCase implements UseCase<UserProfileEntity, LoginParams> {

  LoginUseCase(this._repository);
  final AuthRepository _repository;

  @override
  Future<UserProfileEntity> call(LoginParams params) async {
    return _repository.signIn(
      email: params.email,
      password: params.password,
    );
  }
}
