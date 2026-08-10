import '../../domain/entities/user_profile_entity.dart';

abstract class AuthRepository {
  Stream<String?> get authStateChanges;
  
  Future<UserProfileEntity> signIn({
    required String email,
    required String password,
  });

  Future<UserProfileEntity> register({
    required String name,
    required String email,
    required String password,
  });

  Future<void> signOut();

  Future<UserProfileEntity?> getProfile(String uid);

  Future<UserProfileEntity> createProfile(UserProfileEntity profile);
}
