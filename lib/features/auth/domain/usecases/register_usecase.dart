import '../../../../core/utils/usecase.dart';
import '../../domain/entities/user_profile_entity.dart';
import '../../domain/repositories/auth_repository.dart';

class RegisterParams {
  const RegisterParams({
    required this.name,
    required this.email,
    required this.password,
  });
  final String name;
  final String email;
  final String password;
}

class RegisterUseCase implements UseCase<UserProfileEntity, RegisterParams> {

  RegisterUseCase(this._repository);
  final AuthRepository _repository;

  @override
  Future<UserProfileEntity> call(RegisterParams params) async {
    return _repository.register(
      name: params.name,
      email: params.email,
      password: params.password,
    );
  }
}
