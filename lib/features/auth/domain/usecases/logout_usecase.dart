import '../../../../core/utils/usecase.dart';
import '../../domain/repositories/auth_repository.dart';

class LogoutUseCase implements UseCase<void, NoParams> {

  LogoutUseCase(this._repository);
  final AuthRepository _repository;

  @override
  Future<void> call(NoParams params) async {
    await _repository.signOut();
  }
}
