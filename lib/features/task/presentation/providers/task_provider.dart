import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';
import '../../data/datasources/task_remote_datasource.dart';
import '../../data/repositories/task_repository_impl.dart';
import '../../domain/repositories/task_repository.dart';
import '../../domain/usecases/create_task_usecase.dart';
import '../../domain/usecases/delete_task_usecase.dart';
import '../../domain/usecases/fetch_tasks_usecase.dart';
import '../../domain/usecases/filter_tasks_usecase.dart';
import '../../domain/usecases/search_tasks_usecase.dart';
import '../../domain/usecases/sort_tasks_usecase.dart';
import '../../domain/usecases/update_task_usecase.dart';
import '../controllers/task_controller.dart';
import '../state/task_state.dart';

// ── Reusable API Client ──
final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());

// ── Remote DataSource ──
final taskRemoteDataSourceProvider = Provider<TaskRemoteDataSource>((ref) {
  return TaskRemoteDataSource(ref.watch(apiClientProvider));
});

// ── Repository ──
final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  return TaskRepositoryImpl(ref.watch(taskRemoteDataSourceProvider));
});

// ── Use Cases ──
final fetchTasksUseCaseProvider = Provider<FetchTasksUseCase>((ref) {
  return FetchTasksUseCase(ref.watch(taskRepositoryProvider));
});

final createTaskUseCaseProvider = Provider<CreateTaskUseCase>((ref) {
  return CreateTaskUseCase(ref.watch(taskRepositoryProvider));
});

final updateTaskUseCaseProvider = Provider<UpdateTaskUseCase>((ref) {
  return UpdateTaskUseCase(ref.watch(taskRepositoryProvider));
});

final deleteTaskUseCaseProvider = Provider<DeleteTaskUseCase>((ref) {
  return DeleteTaskUseCase(ref.watch(taskRepositoryProvider));
});

final searchTasksUseCaseProvider = Provider<SearchTasksUseCase>((ref) {
  return const SearchTasksUseCase();
});

final filterTasksUseCaseProvider = Provider<FilterTasksUseCase>((ref) {
  return const FilterTasksUseCase();
});

final sortTasksUseCaseProvider = Provider<SortTasksUseCase>((ref) {
  return const SortTasksUseCase();
});

// ── Controller Provider ──
final taskControllerProvider = StateNotifierProvider<TaskController, TaskState>((ref) {
  return TaskController(
    fetchTasksUseCase: ref.watch(fetchTasksUseCaseProvider),
    createTaskUseCase: ref.watch(createTaskUseCaseProvider),
    updateTaskUseCase: ref.watch(updateTaskUseCaseProvider),
    deleteTaskUseCase: ref.watch(deleteTaskUseCaseProvider),
    searchTasksUseCase: ref.watch(searchTasksUseCaseProvider),
    filterTasksUseCase: ref.watch(filterTasksUseCaseProvider),
    sortTasksUseCase: ref.watch(sortTasksUseCaseProvider),
  );
});
