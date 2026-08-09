import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  ConnectivityService({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity();
  final Connectivity _connectivity;

  Future<bool> get isConnected async {
    try {
      final result = await _connectivity.checkConnectivity();
      if (result.any((r) => r != ConnectivityResult.none)) {
        return true;
      }
      
      // Fallback: Check real host lookup to avoid false-negatives (macOS sandbox limits)
      final lookup = await InternetAddress.lookup('api-dev.smarttaskmanager.com').timeout(
        const Duration(seconds: 2),
      );
      return lookup.isNotEmpty && lookup[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  Stream<List<ConnectivityResult>> get onConnectivityChanged =>
      _connectivity.onConnectivityChanged;
}
