import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/usecases/create_task_usecase.dart';
import '../../domain/usecases/delete_task_usecase.dart';
import '../../domain/usecases/fetch_tasks_usecase.dart';
import '../../domain/usecases/filter_tasks_usecase.dart';
import '../../domain/usecases/search_tasks_usecase.dart';
import '../../domain/usecases/sort_tasks_usecase.dart';
import '../../domain/usecases/update_task_usecase.dart';
import '../state/task_state.dart';

class TaskController extends StateNotifier<TaskState> {
  final FetchTasksUseCase _fetchTasksUseCase;
  final CreateTaskUseCase _createTaskUseCase;
  final UpdateTaskUseCase _updateTaskUseCase;
  final DeleteTaskUseCase _deleteTaskUseCase;
  final SearchTasksUseCase _searchTasksUseCase;
  final FilterTasksUseCase _filterTasksUseCase;
  final SortTasksUseCase _sortTasksUseCase;

  TaskController({
    required FetchTasksUseCase fetchTasksUseCase,
    required CreateTaskUseCase createTaskUseCase,
    required UpdateTaskUseCase updateTaskUseCase,
    required DeleteTaskUseCase deleteTaskUseCase,
    required SearchTasksUseCase searchTasksUseCase,
    required FilterTasksUseCase filterTasksUseCase,
    required SortTasksUseCase sortTasksUseCase,
  })  : _fetchTasksUseCase = fetchTasksUseCase,
        _createTaskUseCase = createTaskUseCase,
        _updateTaskUseCase = updateTaskUseCase,
        _deleteTaskUseCase = deleteTaskUseCase,
        _searchTasksUseCase = searchTasksUseCase,
        _filterTasksUseCase = filterTasksUseCase,
        _sortTasksUseCase = sortTasksUseCase,
        super(const TaskState()) {
    // Initial fetch
    fetchTasks();
  }

  Future<void> fetchTasks({bool isRefresh = false}) async {
    if (state.status == TaskStatus.loading || state.status == TaskStatus.paginating) return;

    if (isRefresh) {
      state = state.copyWith(
        status: TaskStatus.refreshing,
        skip: 0,
        hasReachedMax: false,
      );
    } else {
      if (state.hasReachedMax) return;
      state = state.copyWith(
        status: state.skip == 0 ? TaskStatus.loading : TaskStatus.paginating,
      );
    }

    final params = FetchTasksParams(skip: state.skip, limit: state.limit);
    final result = await _fetchTasksUseCase(params);

    result.fold(
      (failure) {
        state = state.copyWith(
          status: TaskStatus.error,
          errorMessage: failure.message,
        );
      },
      (data) {
        final List<TaskEntity> newTasks = data['tasks'] as List<TaskEntity>;
        final int total = data['total'] as int;

        List<TaskEntity> updatedTasks;
        if (isRefresh) {
          updatedTasks = newTasks;
        } else {
          final Map<dynamic, TaskEntity> taskMap = {
            for (var t in state.tasks) t.id ?? t.hashCode: t
          };
          for (var t in newTasks) {
            taskMap[t.id ?? t.hashCode] = t;
          }
          updatedTasks = taskMap.values.toList();
        }

        final hasReachedMax = updatedTasks.length >= total || newTasks.isEmpty;

        state = state.copyWith(
          status: updatedTasks.isEmpty ? TaskStatus.empty : TaskStatus.loaded,
          tasks: updatedTasks,
          total: total,
          skip: isRefresh ? newTasks.length : state.skip + newTasks.length,
          hasReachedMax: hasReachedMax,
        );

        _applyClientProcessing();
      },
    );
  }

  Future<void> _applyClientProcessing() async {
    try {
      // Apply search
      var processed = await _searchTasksUseCase(
        SearchTasksParams(tasks: state.tasks, query: state.searchQuery),
      );

      // Apply filter
      processed = await _filterTasksUseCase(
        FilterTasksParams(tasks: processed, filter: state.filter),
      );

      // Apply sort
      processed = await _sortTasksUseCase(
        SortTasksParams(
          tasks: processed,
          sortBy: state.sortBy,
          ascending: state.sortAscending,
        ),
      );

      state = state.copyWith(displayTasks: processed);
    } catch (e) {
      state = state.copyWith(
        status: TaskStatus.error,
        errorMessage: 'Error processing tasks: ${e.toString()}',
      );
    }
  }

  Future<void> setSearch(String query) async {
    state = state.copyWith(searchQuery: query);
    await _applyClientProcessing();
  }

  Future<void> setFilter(String filter) async {
    state = state.copyWith(filter: filter);
    await _applyClientProcessing();
  }

  Future<void> setSorting(String sortBy, bool ascending) async {
    state = state.copyWith(sortBy: sortBy, sortAscending: ascending);
    await _applyClientProcessing();
  }

  Future<bool> createTask(TaskEntity task) async {
    state = state.copyWith(status: TaskStatus.submitting);
    final result = await _createTaskUseCase(task);

    return result.fold(
      (failure) {
        state = state.copyWith(status: TaskStatus.loaded, errorMessage: failure.message);
        return false;
      },
      (newTask) {
        state = state.copyWith(
          status: TaskStatus.loaded,
          tasks: [newTask, ...state.tasks.where((t) => t.id != newTask.id || t.id == null)],
        );
        _applyClientProcessing();
        return true;
      },
    );
  }

  Future<bool> updateTask(TaskEntity task) async {
    if (task.id == null) return false;
    state = state.copyWith(status: TaskStatus.submitting);

    final params = UpdateTaskParams(taskId: task.id!, task: task);
    final result = await _updateTaskUseCase(params);

    return result.fold(
      (failure) {
        state = state.copyWith(status: TaskStatus.loaded, errorMessage: failure.message);
        return false;
      },
      (updatedTask) {
        state = state.copyWith(
          status: TaskStatus.loaded,
          tasks: state.tasks.map((t) => t.id == task.id ? updatedTask : t).toList(),
        );
        _applyClientProcessing();
        return true;
      },
    );
  }

  Future<bool> deleteTask(int taskId) async {
    // Optimistic UI for delete
    final previousTasks = state.tasks;
    state = state.copyWith(
      tasks: state.tasks.where((t) => t.id != taskId).toList(),
    );
    _applyClientProcessing();

    final result = await _deleteTaskUseCase(taskId);

    return result.fold(
      (failure) {
        // Rollback on failure
        state = state.copyWith(
          tasks: previousTasks,
          errorMessage: 'Failed to delete task: ${failure.message}',
        );
        _applyClientProcessing();
        return false;
      },
      (_) => true,
    );
  }

  Future<bool> toggleTaskCompletion(TaskEntity task) async {
    if (task.id == null) return false;

    final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
    final previousTasks = state.tasks;

    // Optimistic UI update
    state = state.copyWith(
      tasks: state.tasks.map((t) => t.id == task.id ? updatedTask : t).toList(),
    );
    _applyClientProcessing();

    final params = UpdateTaskParams(taskId: task.id!, task: updatedTask);
    final result = await _updateTaskUseCase(params);

    return result.fold(
      (failure) {
        // Rollback
        state = state.copyWith(
          tasks: previousTasks,
          errorMessage: 'Failed to update task: ${failure.message}',
        );
        _applyClientProcessing();
        return false;
      },
      (savedTask) {
        state = state.copyWith(
          tasks: state.tasks.map((t) => t.id == task.id ? savedTask : t).toList(),
        );
        _applyClientProcessing();
        return true;
      },
    );
  }
}
