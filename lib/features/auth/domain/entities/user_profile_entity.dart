import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/constants/type.dart';

part 'user_profile_entity.freezed.dart';
part 'user_profile_entity.g.dart';

@freezed
class UserProfileEntity with _$UserProfileEntity {
  const factory UserProfileEntity({
    required String uid,
    required String name,
    required String email,
    required DateTime createdAt,
    @Default('system') String themeMode,
  }) = _UserProfileEntity;

  factory UserProfileEntity.fromJson(Map<String, dynamic> json) =>
      _$UserProfileEntityFromJson(json);
}
