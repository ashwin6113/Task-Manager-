import 'package:hive_flutter/hive_flutter.dart';

/// Manages Hive initialization and box registration.
///
/// Call [HiveService.init] once in `main()` before `runApp`.
/// Each feature registers its own adapters through this service.
class HiveService {
  HiveService._();

  /// Initialize Hive for Flutter (uses app document directory).
  static Future<void> init() async {
    await Hive.initFlutter();

    // TODO: Phase 2+ — Register Hive type adapters here:
    // Hive.registerAdapter(TaskModelAdapter());
    // Hive.registerAdapter(UserModelAdapter());
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
