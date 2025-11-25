// lib/core/errors/exception_to_failure_mapper.dart

import 'cache_exception.dart';
import 'server_exception.dart';
import 'failures.dart';

extension FailureMapper on Exception {
  Failure toFailure() {
    if (this is ServerException) {
      final e = this as ServerException;
      return ServerFailure(e.message, e.statusCode, e.stackTrace);
    } else if (this is CacheException) {
      final e = this as CacheException;
      return CacheFailure(e.message, e.stackTrace);
    } else {
      return ServerFailure(toString(), 0, null);
    }
  }
}
