import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/either.dart';
import '../entities/task_entity.dart';

abstract class TaskRepository {
  Future<Either<AppException, Map<String, dynamic>>> getTasks({
    required int skip,
    required int limit,
  });

  Future<Either<AppException, TaskEntity>> createTask(TaskEntity task);

  Future<Either<AppException, TaskEntity>> updateTask(int taskId, TaskEntity task);

  Future<Either<AppException, TaskEntity>> deleteTask(int taskId);
}
