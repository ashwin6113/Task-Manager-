import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/either.dart';
import '../../../../core/utils/usecase.dart';
import '../repositories/task_repository.dart';

class FetchTasksParams {
  final int skip;
  final int limit;

  const FetchTasksParams({required this.skip, required this.limit});
}

class FetchTasksUseCase implements UseCase<Either<AppException, Map<String, dynamic>>, FetchTasksParams> {
  final TaskRepository _repository;

  FetchTasksUseCase(this._repository);

  @override
  Future<Either<AppException, Map<String, dynamic>>> call(FetchTasksParams params) {
    return _repository.getTasks(skip: params.skip, limit: params.limit);
  }
}
