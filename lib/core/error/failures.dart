// lib/core/errors/failures.dart

class Failure {
  final String message;
  final StackTrace? stackTrace;

  Failure(this.message, [this.stackTrace]);

  @override
  String toString() => 'Failure(message: $message)';
}

class ServerFailure extends Failure {
  final int statusCode;

  ServerFailure(String message, this.statusCode, [StackTrace? stackTrace])
    : super(message, stackTrace);

  @override
  String toString() => 'ServerFailure(status: $statusCode, message: $message)';
}

class CacheFailure extends Failure {
  CacheFailure(String message, [StackTrace? stackTrace])
    : super(message, stackTrace);

  @override
  String toString() => 'CacheFailure(message: $message)';
}

class NetworkFailure extends Failure {
  NetworkFailure(String message) : super(message);

  @override
  String toString() => 'NetworkFailure(message: $message)';
}
