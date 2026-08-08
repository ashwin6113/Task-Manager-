// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TaskEntityImpl _$$TaskEntityImplFromJson(Map<String, dynamic> json) =>
    _$TaskEntityImpl(
      id: (json['id'] as num?)?.toInt(),
      title: json['title'] as String,
      description: json['description'] as String,
      priority: json['priority'] as String? ?? 'Medium',
      category: json['category'] as String? ?? 'Work',
      dueDate: DateTime.parse(json['dueDate'] as String),
      isCompleted: json['isCompleted'] as bool? ?? false,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      userId: json['userId'] as String?,
    );

Map<String, dynamic> _$$TaskEntityImplToJson(_$TaskEntityImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'priority': instance.priority,
      'category': instance.category,
      'dueDate': instance.dueDate.toIso8601String(),
      'isCompleted': instance.isCompleted,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'userId': instance.userId,
    };
