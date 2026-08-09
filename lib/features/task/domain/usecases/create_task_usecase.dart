import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/either.dart';
import '../../../../core/utils/usecase.dart';
import '../entities/task_entity.dart';
import '../repositories/task_repository.dart';

class CreateTaskUseCase implements UseCase<Either<AppException, TaskEntity>, TaskEntity> {

  CreateTaskUseCase(this._repository);
  final TaskRepository _repository;

  @override
  Future<Either<AppException, TaskEntity>> call(TaskEntity task) {
    return _repository.createTask(task);
  }
}
