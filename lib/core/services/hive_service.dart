import 'package:hive_flutter/hive_flutter.dart';
import '../../features/task/data/models/pending_operation_model.g.dart';
import '../../features/task/data/models/task_hive_model.g.dart';

class HiveService {
  HiveService._();

  /// Initialize Hive for Flutter (uses app document directory).
  static Future<void> init() async {
    await Hive.initFlutter();

    // Register Hive type adapters
    Hive.registerAdapter(TaskHiveModelAdapter());
    Hive.registerAdapter(PendingOperationModelAdapter());
  }

  /// Opens a typed Hive box. Returns an existing one if already open.
  static Future<Box<T>> openBox<T>(String name) async {
    if (Hive.isBoxOpen(name)) {
      return Hive.box<T>(name);
    }
    return Hive.openBox<T>(name);
  }

  /// Closes all open boxes. Call during app teardown or logout.
  static Future<void> closeAll() async {
    await Hive.close();
  }
}
