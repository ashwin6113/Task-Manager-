// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserProfileEntityImpl _$$UserProfileEntityImplFromJson(
        Map<String, dynamic> json) =>
    _$UserProfileEntityImpl(
      uid: json['uid'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      themeMode: json['themeMode'] as String? ?? 'system',
    );

Map<String, dynamic> _$$UserProfileEntityImplToJson(
        _$UserProfileEntityImpl instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'name': instance.name,
      'email': instance.email,
      'createdAt': instance.createdAt.toIso8601String(),
      'themeMode': instance.themeMode,
    };
