import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/task_entity.dart';

part 'task_model.freezed.dart';
part 'task_model.g.dart';

@freezed
class TaskModel with _$TaskModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory TaskModel({
    int? id,
    required String title,
    required String description,
    required String priority,
    required String category,
    required DateTime dueDate,
    required bool isCompleted,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? userId,
  }) = _TaskModel;

  const TaskModel._();

  factory TaskModel.fromJson(Map<String, dynamic> json) =>
      _$TaskModelFromJson(json);

  factory TaskModel.fromEntity(TaskEntity entity) {
    return TaskModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      priority: entity.priority,
      category: entity.category,
      dueDate: entity.dueDate,
      isCompleted: entity.isCompleted,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      userId: entity.userId,
    );
  }

  TaskEntity toEntity() {
    return TaskEntity(
      id: id,
      title: title,
      description: description,
      priority: priority,
      category: category,
      dueDate: dueDate,
      isCompleted: isCompleted,
      createdAt: createdAt,
      updatedAt: updatedAt,
      userId: userId,
    );
  }
}
