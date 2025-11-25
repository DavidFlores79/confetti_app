// lib/core/errors/server_exception.dart

class ServerException implements Exception {
  final String message;
  final int statusCode;
  final StackTrace? stackTrace;

  ServerException(this.message, this.statusCode, [this.stackTrace]);

  @override
  String toString() => 'ServerException: $message (status $statusCode)';
}
