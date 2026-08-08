import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_entity.freezed.dart';
part 'task_entity.g.dart';

@freezed
class TaskEntity with _$TaskEntity {
  const factory TaskEntity({
    int? id,
    required String title,
    required String description,
    @Default('Medium') String priority,
    @Default('Work') String category,
    required DateTime dueDate,
    @Default(false) bool isCompleted,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? userId,
  }) = _TaskEntity;

  factory TaskEntity.fromJson(Map<String, dynamic> json) =>
      _$TaskEntityFromJson(json);
}
