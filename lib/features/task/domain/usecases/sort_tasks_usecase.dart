import '../../../../core/utils/usecase.dart';
import '../entities/task_entity.dart';

class SortTasksParams {
  final List<TaskEntity> tasks;
  final String sortBy; // 'created_at', 'due_date', 'priority'
  final bool ascending;

  const SortTasksParams({
    required this.tasks,
    required this.sortBy,
    required this.ascending,
  });
}

class SortTasksUseCase implements UseCase<List<TaskEntity>, SortTasksParams> {
  const SortTasksUseCase();

  int _getPriorityValue(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return 3;
      case 'medium':
        return 2;
      case 'low':
      default:
        return 1;
    }
  }

  @override
  Future<List<TaskEntity>> call(SortTasksParams params) async {
    final sortedList = List<TaskEntity>.from(params.tasks);

    sortedList.sort((a, b) {
      int comparison = 0;
      switch (params.sortBy.toLowerCase()) {
        case 'due_date':
          comparison = a.dueDate.compareTo(b.dueDate);
          break;
        case 'priority':
          comparison = _getPriorityValue(a.priority).compareTo(_getPriorityValue(b.priority));
          break;
        case 'created_at':
        default:
          final aTime = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
          final bTime = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
          comparison = aTime.compareTo(bTime);
          break;
      }
      return params.ascending ? comparison : -comparison;
    });

    return sortedList;
  }
}
