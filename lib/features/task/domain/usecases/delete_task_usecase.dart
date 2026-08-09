import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/either.dart';
import '../../../../core/utils/usecase.dart';
import '../entities/task_entity.dart';
import '../repositories/task_repository.dart';

class DeleteTaskUseCase implements UseCase<Either<AppException, TaskEntity>, int> {

  DeleteTaskUseCase(this._repository);
  final TaskRepository _repository;

  @override
  Future<Either<AppException, TaskEntity>> call(int taskId) {
    return _repository.deleteTask(taskId);
  }
}
