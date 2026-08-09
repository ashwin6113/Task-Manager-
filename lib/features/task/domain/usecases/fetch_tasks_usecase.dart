import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/either.dart';
import '../../../../core/utils/usecase.dart';
import '../repositories/task_repository.dart';

class FetchTasksParams {

  const FetchTasksParams({required this.skip, required this.limit});
  final int skip;
  final int limit;
}

class FetchTasksUseCase implements UseCase<Either<AppException, Map<String, dynamic>>, FetchTasksParams> {

  FetchTasksUseCase(this._repository);
  final TaskRepository _repository;

  @override
  Future<Either<AppException, Map<String, dynamic>>> call(FetchTasksParams params) {
    return _repository.getTasks(skip: params.skip, limit: params.limit);
  }
}
