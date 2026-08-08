part of 'user_profile_model.dart';

_$UserProfileModelImpl _$$UserProfileModelImplFromJson(
        JSONObject json,) =>
    _$UserProfileModelImpl(
      uid: json['uid'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      themeMode: json['themeMode'] as String? ?? 'system',
    );

Map<String, dynamic> _$$UserProfileModelImplToJson(
        _$UserProfileModelImpl instance,) =>
    <String, dynamic>{
      'uid': instance.uid,
      'name': instance.name,
      'email': instance.email,
      'createdAt': instance.createdAt.toIso8601String(),
      'themeMode': instance.themeMode,
    };
