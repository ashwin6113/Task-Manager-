import '../../../../core/utils/usecase.dart';
import '../entities/task_entity.dart';

class FilterTasksParams { // 'all', 'completed', 'pending'

  const FilterTasksParams({required this.tasks, required this.filter});
  final List<TaskEntity> tasks;
  final String filter;
}

class FilterTasksUseCase implements UseCase<List<TaskEntity>, FilterTasksParams> {
  const FilterTasksUseCase();

  @override
  Future<List<TaskEntity>> call(FilterTasksParams params) async {
    switch (params.filter.toLowerCase()) {
      case 'completed':
        return params.tasks.where((task) => task.isCompleted).toList();
      case 'pending':
        return params.tasks.where((task) => !task.isCompleted).toList();
      case 'all':
      default:
        return params.tasks;
    }
  }
}
