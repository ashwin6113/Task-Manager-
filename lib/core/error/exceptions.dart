/// Base class for all application exceptions.
abstract class AppException implements Exception {

  const AppException({
    required this.message,
    this.code,
    this.originalError,
  });
  final String message;
  final String? code;
  final dynamic originalError;

  @override
  String toString() => '$runtimeType(message: $message, code: $code)';
}

/// Thrown when a network call fails (no connection, DNS, etc.).
class NetworkException extends AppException {
  const NetworkException({
    super.message = 'No internet connection. Please check your network.',
    super.code,
    super.originalError,
  });
}

/// Thrown when the server returns an unexpected/error response.
class ServerException extends AppException {

  const ServerException({
    super.message = 'Something went wrong on the server.',
    super.code,
    super.originalError,
    this.statusCode,
  });
  final int? statusCode;
}

/// Thrown when reading from or writing to local cache (Hive) fails.
class CacheException extends AppException {
  const CacheException({
    super.message = 'Failed to access local storage.',
    super.code,
    super.originalError,
  });
}

/// Thrown on authentication / authorization errors.
class AuthException extends AppException {
  const AuthException({
    super.message = 'Authentication failed. Please sign in again.',
    super.code,
    super.originalError,
  });
}

/// Thrown when input validation fails (forms, DTOs, etc.).
class ValidationException extends AppException {

  const ValidationException({
    super.message = 'Validation failed.',
    super.code,
    super.originalError,
    this.fieldErrors,
  });
  final Map<String, List<String>>? fieldErrors;
}

/// Thrown when automatic task synchronization fails.
class SyncException extends AppException {
  const SyncException({
    super.message = 'Failed to synchronize tasks with the server.',
    super.code,
    super.originalError,
  });
}

/// Thrown when local queue operations fail.
class QueueException extends AppException {
  const QueueException({
    super.message = 'Failed to process operation queue.',
    super.code,
    super.originalError,
  });
}

/// Thrown when connectivity service or state encounters an error.
class ConnectivityException extends AppException {
  const ConnectivityException({
    super.message = 'Failed to detect or update network connectivity status.',
    super.code,
    super.originalError,
  });
}

