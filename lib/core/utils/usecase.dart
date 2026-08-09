abstract class UseCase<ReturnType, Params> {
  Future<ReturnType> call(Params params);
}

/// Use when a use case requires no parameters.
class NoParams {
  const NoParams();
}
