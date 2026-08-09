import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/connectivity_service.dart';
import '../providers/task_provider.dart';

enum ConnectivityStatus { online, offline }
enum SyncStatus { idle, syncing }

// ── Connectivity Service Provider ──
final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  return ConnectivityService();
});

// ── Connectivity Status Provider ──
final connectivityStatusProvider = StateNotifierProvider<ConnectivityStatusNotifier, ConnectivityStatus>((ref) {
  final service = ref.watch(connectivityServiceProvider);
  return ConnectivityStatusNotifier(service);
});

class ConnectivityStatusNotifier extends StateNotifier<ConnectivityStatus> {
  final ConnectivityService _service;

  ConnectivityStatusNotifier(this._service) : super(ConnectivityStatus.online) {
    _checkInitial();
    _service.onConnectivityChanged.listen((results) async {
      final hasConnection = results.any((r) => r != ConnectivityResult.none);
      if (hasConnection) {
        state = ConnectivityStatus.online;
      } else {
        // Double-check using host lookup to verify actual internet access and prevent sandbox false-negatives
        final connected = await _service.isConnected;
        state = connected ? ConnectivityStatus.online : ConnectivityStatus.offline;
      }
    });
  }

  Future<void> _checkInitial() async {
    final connected = await _service.isConnected;
    state = connected ? ConnectivityStatus.online : ConnectivityStatus.offline;
  }
}

// ── Sync Status Provider ──
final syncStatusProvider = StateProvider<SyncStatus>((ref) => SyncStatus.idle);

// ── Queue Count Provider ──
final pendingQueueCountProvider = StateNotifierProvider<QueueCountNotifier, int>((ref) {
  final localDataSource = ref.watch(taskLocalDataSourceProvider);
  return QueueCountNotifier(localDataSource);
});

class QueueCountNotifier extends StateNotifier<int> {

  QueueCountNotifier(this._localDataSource) : super(0) {
    updateCount();
  }
  final dynamic _localDataSource;

  Future<void> updateCount() async {
    final queue = await _localDataSource.getQueue();
    state = queue.length;
  }
}
