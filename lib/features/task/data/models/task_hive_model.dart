import 'package:hive/hive.dart';
import '../../domain/entities/task_entity.dart';

@HiveType(typeId: 0)
class TaskHiveModel extends HiveObject {

  factory TaskHiveModel.fromEntity(TaskEntity entity) {
    return TaskHiveModel(
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

  TaskHiveModel({
    this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.category,
    required this.dueDate,
    required this.isCompleted,
    this.createdAt,
    this.updatedAt,
    this.userId,
  });
  @HiveField(0)
  final int? id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String priority;

  @HiveField(4)
  final String category;

  @HiveField(5)
  final DateTime dueDate;

  @HiveField(6)
  final bool isCompleted;

  @HiveField(7)
  final DateTime? createdAt;

  @HiveField(8)
  final DateTime? updatedAt;

  @HiveField(9)
  final String? userId;

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
