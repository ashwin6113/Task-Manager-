import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/either.dart';
import '../../../../core/utils/usecase.dart';
import '../entities/task_entity.dart';
import '../repositories/task_repository.dart';

class UpdateTaskParams {

  const UpdateTaskParams({required this.taskId, required this.task});
  final int taskId;
  final TaskEntity task;
}

class UpdateTaskUseCase implements UseCase<Either<AppException, TaskEntity>, UpdateTaskParams> {

  UpdateTaskUseCase(this._repository);
  final TaskRepository _repository;

  @override
  Future<Either<AppException, TaskEntity>> call(UpdateTaskParams params) {
    return _repository.updateTask(params.taskId, params.task);
  }
}
