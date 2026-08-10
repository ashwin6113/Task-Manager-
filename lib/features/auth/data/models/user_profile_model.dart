import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/user_profile_entity.dart';

part 'user_profile_model.freezed.dart';
part 'user_profile_model.g.dart';

@freezed
class UserProfileModel with _$UserProfileModel {
  const factory UserProfileModel({
    required String uid,
    required String name,
    required String email,
    required DateTime createdAt,
    @Default('system') String themeMode,
  }) = _UserProfileModel;

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      _$UserProfileModelFromJson(json);

  factory UserProfileModel.fromEntity(UserProfileEntity entity) {
    return UserProfileModel(
      uid: entity.uid,
      name: entity.name,
      email: entity.email,
      createdAt: entity.createdAt,
      themeMode: entity.themeMode,
    );
  }

  const UserProfileModel._();

  UserProfileEntity toEntity() {
    return UserProfileEntity(
      uid: uid,
      name: name,
      email: email,
      createdAt: createdAt,
      themeMode: themeMode,
    );
  }
}
