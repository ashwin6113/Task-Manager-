import '../../../../core/utils/usecase.dart';
import '../entities/task_entity.dart';

class SearchTasksParams {
  final List<TaskEntity> tasks;
  final String query;

  const SearchTasksParams({required this.tasks, required this.query});
}

class SearchTasksUseCase implements UseCase<List<TaskEntity>, SearchTasksParams> {
  const SearchTasksUseCase();

  @override
  Future<List<TaskEntity>> call(SearchTasksParams params) async {
    if (params.query.trim().isEmpty) return params.tasks;
    final lowerQuery = params.query.toLowerCase();
    return params.tasks
        .where((task) => task.title.toLowerCase().contains(lowerQuery))
        .toList();
  }
}
