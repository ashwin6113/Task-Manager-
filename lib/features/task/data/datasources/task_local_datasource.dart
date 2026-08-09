import 'package:hive/hive.dart';

import '../../../../core/services/hive_service.dart';
import '../models/pending_operation_model.dart';
import '../models/task_hive_model.dart';

abstract class TaskLocalDataSource {
  Future<void> saveTasks(List<TaskHiveModel> tasks);
  Future<List<TaskHiveModel>> getTasks();
  Future<void> saveTask(TaskHiveModel task);
  Future<void> updateTask(TaskHiveModel task);
  Future<void> deleteTask(int taskId);
  Future<void> clearTasks();
  Stream<BoxEvent> watchTasks();

  // Queue Operations
  Future<List<PendingOperationModel>> getQueue();
  Future<void> enqueue(PendingOperationModel operation);
  Future<void> dequeue(String operationId);
  Future<void> clearQueue();
}

class TaskLocalDataSourceImpl implements TaskLocalDataSource {
  static const String _tasksBoxName = 'tasks';
  static const String _queueBoxName = 'pending_operations';

  Future<Box<TaskHiveModel>> get _tasksBox =>
      HiveService.openBox<TaskHiveModel>(_tasksBoxName);

  Future<Box<PendingOperationModel>> get _queueBox =>
      HiveService.openBox<PendingOperationModel>(_queueBoxName);

  @override
  Future<void> saveTasks(List<TaskHiveModel> tasks) async {
    final box = await _tasksBox;
    final Map<int, TaskHiveModel> taskMap = {
      for (var task in tasks) task.id ?? task.hashCode: task
    };
    await box.putAll(taskMap);
  }

  @override
  Future<List<TaskHiveModel>> getTasks() async {
    final box = await _tasksBox;
    return box.values.toList();
  }

  @override
  Future<void> saveTask(TaskHiveModel task) async {
    final box = await _tasksBox;
    await box.put(task.id ?? task.hashCode, task);
  }

  @override
  Future<void> updateTask(TaskHiveModel task) async {
    final box = await _tasksBox;
    await box.put(task.id ?? task.hashCode, task);
  }

  @override
  Future<void> deleteTask(int taskId) async {
    final box = await _tasksBox;
    await box.delete(taskId);
  }

  @override
  Future<void> clearTasks() async {
    final box = await _tasksBox;
    await box.clear();
  }

  @override
  Stream<BoxEvent> watchTasks() {
    // Return a stream that emits events when the tasks box updates
    return Stream.fromFuture(_tasksBox).asyncExpand((box) => box.watch());
  }

  // Queue Methods
  @override
  Future<List<PendingOperationModel>> getQueue() async {
    final box = await _queueBox;
    return box.values.toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
  }

  @override
  Future<void> enqueue(PendingOperationModel operation) async {
    final box = await _queueBox;
    await box.put(operation.id, operation);
  }

  @override
  Future<void> dequeue(String operationId) async {
    final box = await _queueBox;
    await box.delete(operationId);
  }

  @override
  Future<void> clearQueue() async {
    final box = await _queueBox;
    await box.clear();
  }
}
