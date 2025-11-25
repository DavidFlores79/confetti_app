import 'package:dio/dio.dart';

class NetworkExceptions {
  final String message;
  final int? code;

  NetworkExceptions(this.message, {this.code});

  @override
  String toString() => 'NetworkExceptions(code: $code, message: $message)';

  static NetworkExceptions fromDioError(DioException error) {
    // Manejo de timeouts
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout) {
      return NetworkExceptions('Timeout: ${error.message}');
    }

    // Manejo de respuestas del servidor (400, 401, 500, etc.)
    if (error.type == DioExceptionType.badResponse) {
      final status = error.response?.statusCode ?? 0;
      final data = error.response?.data;

      String message = 'Error $status';
      try {
        if (data is Map<String, dynamic>) {
          final rawMsg = data['message'];

          if (rawMsg is List) {
            // ✅ Caso: message es una lista de strings
            message = rawMsg.join(', ');
          } else if (rawMsg is String) {
            message = rawMsg;
          } else if (data['error'] != null) {
            message = data['error'].toString();
          }
        } else if (data is String) {
          message = data;
        }
      } catch (e) {
        message = 'Error parsing server response';
      }

      return NetworkExceptions(message, code: status);
    }

    // Request cancelado
    if (error.type == DioExceptionType.cancel) {
      return NetworkExceptions('Request cancelled');
    }

    // Otros errores no esperados
    return NetworkExceptions('Unexpected network error: ${error.message}');
  }
}
