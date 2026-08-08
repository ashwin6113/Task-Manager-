import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/task_entity.dart';

part 'task_state.freezed.dart';

enum TaskStatus {
  initial,
  loading,
  loaded,
  empty,
  error,
  refreshing,
  paginating,
  submitting,
}

@freezed
class TaskState with _$TaskState {
  const factory TaskState({
    @Default(TaskStatus.initial) TaskStatus status,
    @Default([]) List<TaskEntity> tasks,
    @Default([]) List<TaskEntity> displayTasks,
    @Default(0) int skip,
    @Default(10) int limit,
    @Default(0) int total,
    @Default(false) bool hasReachedMax,
    @Default('') String searchQuery,
    @Default('all') String filter,
    @Default('created_at') String sortBy,
    @Default(false) bool sortAscending,
    String? errorMessage,
  }) = _TaskState;
}
