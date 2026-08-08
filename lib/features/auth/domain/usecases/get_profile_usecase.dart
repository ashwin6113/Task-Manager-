import '../../../../core/utils/usecase.dart';
import '../../domain/entities/user_profile_entity.dart';
import '../../domain/repositories/auth_repository.dart';

class GetProfileUseCase implements UseCase<UserProfileEntity?, String> {

  GetProfileUseCase(this._repository);
  final AuthRepository _repository;

  @override
  Future<UserProfileEntity?> call(String uid) async {
    return _repository.getProfile(uid);
  }
}
