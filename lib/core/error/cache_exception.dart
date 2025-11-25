// lib/core/errors/cache_exception.dart

class CacheException implements Exception {
  final String message;
  final StackTrace? stackTrace;

  CacheException(this.message, [this.stackTrace]);

  @override
  String toString() => 'CacheException: $message';
}
