/// A reusable abstract base for all use cases.
///
/// Every use case implements a single `call()` method (SOLID: Single Responsibility).
/// This makes each use case independently injectable, testable, and composable.
abstract class UseCase<ReturnType, Params> {
  Future<ReturnType> call(Params params);
}

/// Use when a use case requires no parameters.
class NoParams {
  const NoParams();
}
