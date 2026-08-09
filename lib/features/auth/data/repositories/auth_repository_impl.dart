import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/services/secure_storage_service.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/entities/user_profile_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../datasources/profile_remote_datasource.dart';
import '../models/user_profile_model.dart';

class AuthRepositoryImpl implements AuthRepository {

  AuthRepositoryImpl({
    required AuthRemoteDataSource authDataSource,
    required ProfileRemoteDataSource profileDataSource,
  })  : _authDataSource = authDataSource,
        _profileDataSource = profileDataSource;
  final AuthRemoteDataSource _authDataSource;
  final ProfileRemoteDataSource _profileDataSource;

  @override
  Stream<String?> get authStateChanges =>
      _authDataSource.authStateChanges.map((user) => user?.uid);

  @override
  Future<UserProfileEntity> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _authDataSource.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final uid = credential.user!.uid;

      // Extract and save tokens to SecureStorage
      final accessToken = await credential.user!.getIdToken() ?? '';
      final refreshToken = credential.user!.refreshToken ?? '';
      await SecureStorageService.saveTokens(
        accessToken: accessToken,
        refreshToken: refreshToken,
      );

      final profileModel = await _profileDataSource.getUserProfile(uid);
      if (profileModel != null) {
        return profileModel.toEntity();
      }

      // Automatically create Firestore profile if authenticated but missing profile document
      final newProfile = UserProfileEntity(
        uid: uid,
        name: credential.user!.displayName ?? email.split('@').first,
        email: email,
        createdAt: DateTime.now(),
      );
      await _profileDataSource.createUserProfile(UserProfileModel.fromEntity(newProfile));
      return newProfile;
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseAuthException(e);
    } catch (e) {
      throw ServerException(message: 'Sign in failed: ${e.toString()}');
    }
  }

  @override
  Future<UserProfileEntity> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _authDataSource.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final uid = credential.user!.uid;

      // Extract and save tokens to SecureStorage
      final accessToken = await credential.user!.getIdToken() ?? '';
      final refreshToken = credential.user!.refreshToken ?? '';
      await SecureStorageService.saveTokens(
        accessToken: accessToken,
        refreshToken: refreshToken,
      );

      final newProfile = UserProfileEntity(
        uid: uid,
        name: name.trim(),
        email: email,
        createdAt: DateTime.now(),
      );
      await _profileDataSource.createUserProfile(UserProfileModel.fromEntity(newProfile));
      return newProfile;
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseAuthException(e);
    } catch (e) {
      throw ServerException(message: 'Registration failed: ${e.toString()}');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _authDataSource.signOut();
    } catch (e) {
      throw ServerException(message: 'Sign out failed: ${e.toString()}');
    }
  }

  @override
  Future<UserProfileEntity?> getProfile(String uid) async {
    try {
      final profileModel = await _profileDataSource.getUserProfile(uid);
      return profileModel?.toEntity();
    } catch (e) {
      throw CacheException(message: 'Failed to retrieve profile: ${e.toString()}');
    }
  }

  @override
  Future<UserProfileEntity> createProfile(UserProfileEntity profile) async {
    try {
      final model = UserProfileModel.fromEntity(profile);
      await _profileDataSource.createUserProfile(model);
      return profile;
    } catch (e) {
      throw ServerException(message: 'Failed to create profile: ${e.toString()}');
    }
  }

  AppException _mapFirebaseAuthException(FirebaseAuthException e) {
    String message;
    switch (e.code) {
      case 'email-already-in-use':
        message = 'The email address is already in use by another account.';
        break;
      case 'weak-password':
        message = 'The password provided is too weak. Must be at least 6 characters.';
        break;
      case 'invalid-email':
        message = 'The email address is not formatted correctly.';
        break;
      case 'wrong-password':
      case 'user-not-found':
        message = 'Invalid email or password combination.';
        break;
      case 'too-many-requests':
        message = 'Too many failed login attempts. Please try again later.';
        break;
      case 'network-request-failed':
        message = 'A network error occurred. Please check your connection.';
        break;
      case 'operation-not-allowed':
        message = 'Email/password sign-in is disabled in Firebase Console.';
        break;
      default:
        message = e.message ?? 'An unknown authentication error occurred.';
    }
    return AuthException(message: message, code: e.code, originalError: e);
  }
}
