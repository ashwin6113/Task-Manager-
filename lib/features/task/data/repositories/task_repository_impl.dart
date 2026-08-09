import 'package:flutter/foundation.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/services/connectivity_service.dart';
import '../../../../core/utils/either.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasources/task_local_datasource.dart';
import '../datasources/task_remote_datasource.dart';
import '../models/pending_operation_model.dart';
import '../models/task_hive_model.dart';
import '../models/task_model.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteDataSource _remoteDataSource;
  final TaskLocalDataSource _localDataSource;
  final ConnectivityService _connectivityService;

  TaskRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
    this._connectivityService,
  );

  @override
  Future<Either<AppException, Map<String, dynamic>>> getTasks({
    required int skip,
    required int limit,
  }) async {
    final isOnline = await _connectivityService.isConnected;
    if (isOnline) {
      try {
        final result = await _remoteDataSource.getTasks(skip: skip, limit: limit);
        final remoteModels = result['tasks'] as List<TaskModel>;
        final total = result['total'] as int;

        final entities = remoteModels.map((m) => m.toEntity()).toList();
        final hiveModels = entities.map((e) => TaskHiveModel.fromEntity(e)).toList();
        
        // Cache in Hive Box
        await _localDataSource.saveTasks(hiveModels);

        return Right({
          'tasks': entities,
          'total': total,
        });
      } catch (e) {
        debugPrint('⚠️ TaskRepository: Remote fetch failed, falling back to cache: $e');
      }
    }

    // Offline / Local Cache Fallback
    try {
      final hiveModels = await _localDataSource.getTasks();
      final entities = hiveModels.map((m) => m.toEntity()).toList();
      return Right({
        'tasks': entities,
        'total': entities.length,
      });
    } catch (e) {
      return Left(CacheException(message: e.toString()));
    }
  }

  @override
  Future<Either<AppException, TaskEntity>> createTask(TaskEntity task) async {
    final isOnline = await _connectivityService.isConnected;

    // Optimistic Save to Local Storage
    final hiveModel = TaskHiveModel.fromEntity(task);
    await _localDataSource.saveTask(hiveModel);

    if (isOnline) {
      try {
        final model = TaskModel.fromEntity(task);
        final result = await _remoteDataSource.createTask(model);
        final savedEntity = result.toEntity();

        // Update local cache with server data (including generated ID)
        await _localDataSource.deleteTask(task.id ?? task.hashCode);
        await _localDataSource.saveTask(TaskHiveModel.fromEntity(savedEntity));

        return Right(savedEntity);
      } catch (e) {
        debugPrint('⚠️ TaskRepository: Remote create failed, queueing operation: $e');
      }
    }

    // Queue operation offline
    final pendingOp = PendingOperationModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      operationType: 'CREATE',
      payload: TaskModel.fromEntity(task).toJson(),
      createdAt: DateTime.now(),
      status: 'PENDING',
    );
    await _localDataSource.enqueue(pendingOp);

    return Right(task);
  }

  @override
  Future<Either<AppException, TaskEntity>> updateTask(int taskId, TaskEntity task) async {
    final isOnline = await _connectivityService.isConnected;

    // Optimistic Save to Local Storage
    final hiveModel = TaskHiveModel.fromEntity(task);
    await _localDataSource.updateTask(hiveModel);

    if (isOnline) {
      try {
        final model = TaskModel.fromEntity(task);
        final result = await _remoteDataSource.updateTask(taskId, model);
        final savedEntity = result.toEntity();

        await _localDataSource.saveTask(TaskHiveModel.fromEntity(savedEntity));
        return Right(savedEntity);
      } catch (e) {
        debugPrint('⚠️ TaskRepository: Remote update failed, queueing operation: $e');
      }
    }

    // Queue operation offline
    final pendingOp = PendingOperationModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      operationType: 'UPDATE',
      payload: TaskModel.fromEntity(task).toJson(),
      createdAt: DateTime.now(),
      status: 'PENDING',
    );
    await _localDataSource.enqueue(pendingOp);

    return Right(task);
  }

  @override
  Future<Either<AppException, TaskEntity>> deleteTask(int taskId) async {
    final isOnline = await _connectivityService.isConnected;

    // Optimistic Delete from Local Storage
    await _localDataSource.deleteTask(taskId);

    if (isOnline) {
      try {
        final result = await _remoteDataSource.deleteTask(taskId);
        return Right(result.toEntity());
      } catch (e) {
        debugPrint('⚠️ TaskRepository: Remote delete failed, queueing operation: $e');
      }
    }

    // Queue operation offline
    final pendingOp = PendingOperationModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      operationType: 'DELETE',
      payload: TaskModel(
        id: taskId,
        title: '',
        description: '',
        priority: 'Low',
        category: 'Work',
        dueDate: DateTime.now(),
        isCompleted: false,
      ).toJson(),
      createdAt: DateTime.now(),
      status: 'PENDING',
    );
    await _localDataSource.enqueue(pendingOp);

    return Right(TaskEntity(
      id: taskId,
      title: '',
      description: '',
      dueDate: DateTime.now(),
    ));
  }
}
