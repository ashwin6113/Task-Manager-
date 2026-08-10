abstract class Either<L, R> {
  const Either();

  /// Applies [fnL] if this is a [Left] or [fnR] if this is a [Right].
  T fold<T>(T Function(L left) fnL, T Function(R right) fnR);

  /// Returns true if this is a [Left].
  bool isLeft() => fold((_) => true, (_) => false);

  /// Returns true if this is a [Right].
  bool isRight() => fold((_) => false, (_) => true);

  /// Returns the value of Left if it exists, otherwise throws.
  L getLeft() => fold((l) => l, (r) => throw StateError('Expected Left, got Right($r)'));

  /// Returns the value of Right if it exists, otherwise throws.
  R getRight() => fold((l) => throw StateError('Expected Right, got Left($l)'), (r) => r);
}

class Left<L, R> extends Either<L, R> {
  const Left(this.value);
  final L value;

  @override
  T fold<T>(T Function(L left) fnL, T Function(R right) fnR) => fnL(value);

  @override
  bool operator ==(Object other) => other is Left<L, R> && other.value == value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'Left($value)';
}

class Right<L, R> extends Either<L, R> {
  const Right(this.value);
  final R value;

  @override
  T fold<T>(T Function(L left) fnL, T Function(R right) fnR) => fnR(value);

  @override
  bool operator ==(Object other) => other is Right<L, R> && other.value == value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'Right($value)';
}
