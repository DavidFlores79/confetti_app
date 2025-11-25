import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:dartz/dartz.dart';
import '../error/network_exceptions.dart';

abstract class ApiClient {
  Future<Either<NetworkExceptions, T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  });
  Future<Either<NetworkExceptions, T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  });
  Future<Either<NetworkExceptions, T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  });
  Future<Either<NetworkExceptions, T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  });
  Future<Either<NetworkExceptions, T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  });
}

class DioApiClient implements ApiClient {
  final Dio _dio;
  final Logger _logger;

  DioApiClient(this._dio, this._logger);

  Future<Either<NetworkExceptions, T>> _request<T>(
    Future<Response> Function() fn,
  ) async {
    try {
      final response = await fn();
      // Nota: dejamos el parseo de response.data al datasource/repository para SRP.
      return Right(response.data as T);
    } on DioException catch (e) {
      _logger.e('DioError: ${e.message}');
      return Left(NetworkExceptions.fromDioError(e));
    } catch (e) {
      _logger.e('Unexpected error: $e');
      return Left(NetworkExceptions('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<NetworkExceptions, T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) {
    return _request<T>(
      () => _dio.get(
        path,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      ),
    );
  }

  @override
  Future<Either<NetworkExceptions, T>> post<T>(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) {
    return _request<T>(
      () => _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      ),
    );
  }

  @override
  Future<Either<NetworkExceptions, T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) {
    return _request<T>(
      () => _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      ),
    );
  }

  @override
  Future<Either<NetworkExceptions, T>> put<T>(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) {
    return _request<T>(
      () => _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      ),
    );
  }

  @override
  Future<Either<NetworkExceptions, T>> delete<T>(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) {
    return _request<T>(
      () => _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      ),
    );
  }
}
