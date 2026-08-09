import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/services/connectivity_service.dart';
import '../datasources/task_local_datasource.dart';
import '../datasources/task_remote_datasource.dart';
import '../models/pending_operation_model.dart';
import '../models/task_hive_model.dart';
import '../models/task_model.dart';

class SyncManager {

  SyncManager({
    required TaskRemoteDataSource remoteDataSource,
    required TaskLocalDataSource localDataSource,
    required ConnectivityService connectivityService,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource,
        _connectivityService = connectivityService;
  final TaskRemoteDataSource _remoteDataSource;
  final TaskLocalDataSource _localDataSource;
  final ConnectivityService _connectivityService;
  StreamSubscription? _connectivitySubscription;
  bool _isSyncing = false;

  // Stream/Callback to notify when sync completes
  final StreamController<void> _syncCompletedController = StreamController<void>.broadcast();
  Stream<void> get onSyncCompleted => _syncCompletedController.stream;

  void start() {
    _connectivitySubscription = _connectivityService.onConnectivityChanged.listen((results) async {
      final isConnected = !results.contains(ConnectivityResult.none);
      if (isConnected) {
        debugPrint('🌐 SyncManager: Connection restored. Starting automatic sync...');
        await runSync();
      }
    });
  }

  void stop() {
    _connectivitySubscription?.cancel();
  }

  Future<void> runSync() async {
    if (_isSyncing) return;
    _isSyncing = true;

    try {
      final queue = await _localDataSource.getQueue();
      if (queue.isEmpty) {
        _isSyncing = false;
        return;
      }

      debugPrint('🔄 SyncManager: Syncing ${queue.length} pending operations...');
      for (final operation in queue) {
        try {
          await _processOperation(operation);
          await _localDataSource.dequeue(operation.id);
        } catch (e) {
          debugPrint('❌ SyncManager: Failed to process operation ${operation.id}: $e');
          // Update status to failed so we can retry later
          final failedOperation = PendingOperationModel(
            id: operation.id,
            operationType: operation.operationType,
            payload: operation.payload,
            createdAt: operation.createdAt,
            status: 'FAILED',
          );
          await _localDataSource.enqueue(failedOperation);
        }
      }

      _syncCompletedController.add(null);
    } finally {
      _isSyncing = false;
    }
  }

  Future<void> _processOperation(PendingOperationModel operation) async {
    final taskData = TaskModel.fromJson(operation.payload);
    
    switch (operation.operationType.toUpperCase()) {
      case 'CREATE':
        final created = await _remoteDataSource.createTask(taskData);
        await _localDataSource.saveTask(TaskHiveModel.fromEntity(created.toEntity()));
        break;

      case 'UPDATE':
      case 'TOGGLE':
        if (taskData.id != null) {
          try {
            final serverTask = await _remoteDataSource.getTasks(skip: 0, limit: 100);
            final List<dynamic> serverList = serverTask['tasks'];
            final matched = serverList.firstWhere(
              (t) => t.id == taskData.id,
              orElse: () => null,
            );

            if (matched != null) {
              final serverTime = matched.updatedAt ?? matched.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
              final clientTime = taskData.updatedAt ?? taskData.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);

              if (serverTime.isAfter(clientTime)) {
                debugPrint('⚠️ SyncManager: Conflict detected. Server wins for task ${taskData.id}.');
                // Server wins: Update local cache with server data
                await _localDataSource.saveTask(TaskHiveModel.fromEntity(matched.toEntity()));
                return;
              }
            }
          } catch (e) {
            debugPrint('⚠️ SyncManager: Failed conflict check, proceeding with client update: $e');
          }

          final updated = await _remoteDataSource.updateTask(taskData.id!, taskData);
          await _localDataSource.saveTask(TaskHiveModel.fromEntity(updated.toEntity()));
        }
        break;

      case 'DELETE':
        if (taskData.id != null) {
          await _remoteDataSource.deleteTask(taskData.id!);
          await _localDataSource.deleteTask(taskData.id!);
        }
        break;

      default:
        throw Exception('Unknown operation type: ${operation.operationType}');
    }
  }
}
