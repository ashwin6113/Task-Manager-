import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/either.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasources/task_remote_datasource.dart';
import '../models/task_model.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteDataSource _remoteDataSource;

  TaskRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<AppException, Map<String, dynamic>>> getTasks({
    required int skip,
    required int limit,
  }) async {
    try {
      final result = await _remoteDataSource.getTasks(skip: skip, limit: limit);
      final tasks = (result['tasks'] as List<TaskModel>)
          .map((model) => model.toEntity())
          .toList();
      final total = result['total'] as int;
      return Right({
        'tasks': tasks,
        'total': total,
      });
    } on AppException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerException(message: e.toString()));
    }
  }

  @override
  Future<Either<AppException, TaskEntity>> createTask(TaskEntity task) async {
    try {
      final model = TaskModel.fromEntity(task);
      final result = await _remoteDataSource.createTask(model);
      return Right(result.toEntity());
    } on AppException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerException(message: e.toString()));
    }
  }

  @override
  Future<Either<AppException, TaskEntity>> updateTask(int taskId, TaskEntity task) async {
    try {
      final model = TaskModel.fromEntity(task);
      final result = await _remoteDataSource.updateTask(taskId, model);
      return Right(result.toEntity());
    } on AppException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerException(message: e.toString()));
    }
  }

  @override
  Future<Either<AppException, TaskEntity>> deleteTask(int taskId) async {
    try {
      final result = await _remoteDataSource.deleteTask(taskId);
      return Right(result.toEntity());
    } on AppException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerException(message: e.toString()));
    }
  }
}
