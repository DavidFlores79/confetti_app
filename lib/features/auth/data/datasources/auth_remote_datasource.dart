import 'dart:convert';

import 'package:http/http.dart' as http;
import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/app_logger.dart';
import '../models/login_response_model.dart';

abstract class AuthRemoteDataSource {
  Future<LoginResponseModel> login({
    required String phone,
    required String password,
  });

  Future<LoginResponseModel> register({
    required String phone,
    required String password,
    required String name,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;
  static const String baseUrl = 'http://192.168.0.176:3000';

  AuthRemoteDataSourceImpl({required this.client});

  /// Parse error message from API response
  /// Handles both single string messages and array of validation errors
  String _parseErrorMessage(
    Map<String, dynamic> errorResponse,
    String fallbackMessage,
  ) {
    try {
      final message = errorResponse['message'];

      // If message is a List (validation errors)
      if (message is List) {
        if (message.isEmpty) {
          return fallbackMessage;
        }
        // Join multiple error messages with line breaks
        return message.map((e) => e.toString()).join('\n');
      }

      // If message is a String
      if (message is String) {
        return message;
      }

      // Fallback to error field if message is not available
      if (errorResponse['error'] is String) {
        return errorResponse['error'];
      }

      return fallbackMessage;
    } catch (e) {
      AppLogger.warning(
        'AuthRemoteDataSource: Failed to parse error message - $e',
      );
      return fallbackMessage;
    }
  }

  @override
  Future<LoginResponseModel> login({
    required String phone,
    required String password,
  }) async {
    try {
      AppLogger.info('AuthRemoteDataSource: Login attempt - Phone: $phone');

      final response = await client.post(
        Uri.parse('$baseUrl/v1/auth/sign-in'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'phone': phone,
          'password': password,
          // 'group': 'client_user',
          // 'audience': 'wallet-service.local.paisamex.mx',
        }),
      );

      AppLogger.debug(
        'AuthRemoteDataSource: Login response - Status: ${response.statusCode}',
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final loginResponse = LoginResponseModel.fromJson(jsonResponse);
        AppLogger.info(
          'AuthRemoteDataSource: Login successful - User ID: ${loginResponse.user.id}',
        );
        return loginResponse;
      } else {
        // Parse error message from API response
        String errorMessage = 'Login failed';
        try {
          final errorResponse =
              json.decode(response.body) as Map<String, dynamic>;
          errorMessage = _parseErrorMessage(
            errorResponse,
            'Login failed with status: ${response.statusCode}',
          );
        } catch (e) {
          errorMessage = 'Login failed with status: ${response.statusCode}';
        }

        AppLogger.error(
          'AuthRemoteDataSource: Login failed - ${response.statusCode}: $errorMessage',
        );
        throw ServerException(errorMessage);
      }
    } catch (e, stackTrace) {
      if (e is ServerException) {
        AppLogger.error(
          'AuthRemoteDataSource: Server exception during login',
          e,
        );
        rethrow;
      }
      AppLogger.error(
        'AuthRemoteDataSource: Unexpected error during login',
        e,
        stackTrace,
      );
      throw ServerException('Failed to login: ${e.toString()}');
    }
  }

  @override
  Future<LoginResponseModel> register({
    required String phone,
    required String password,
    required String name,
  }) async {
    try {
      AppLogger.info(
        'AuthRemoteDataSource: Registration attempt - Phone: $phone, Name: $name',
      );

      final response = await client.post(
        Uri.parse('$baseUrl/v1/auth/sign-up'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'phone': phone, 'password': password, 'name': name}),
      );

      AppLogger.debug(
        'AuthRemoteDataSource: Registration response - Status: ${response.statusCode}',
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = json.decode(response.body);
        final loginResponse = LoginResponseModel.fromJson(jsonResponse);
        AppLogger.info(
          'AuthRemoteDataSource: Registration successful - User ID: ${loginResponse.user.id}',
        );
        return loginResponse;
      } else {
        // Parse error message from API response
        String errorMessage = 'Registration failed';
        try {
          final errorResponse =
              json.decode(response.body) as Map<String, dynamic>;
          errorMessage = _parseErrorMessage(
            errorResponse,
            'Registration failed with status: ${response.statusCode}',
          );
        } catch (e) {
          errorMessage =
              'Registration failed with status: ${response.statusCode}';
        }

        AppLogger.error(
          'AuthRemoteDataSource: Registration failed - ${response.statusCode}: $errorMessage',
        );
        throw ServerException(errorMessage);
      }
    } catch (e, stackTrace) {
      if (e is ServerException) {
        AppLogger.error(
          'AuthRemoteDataSource: Server exception during registration',
          e,
        );
        rethrow;
      }
      AppLogger.error(
        'AuthRemoteDataSource: Unexpected error during registration',
        e,
        stackTrace,
      );
      throw ServerException('Failed to register: ${e.toString()}');
    }
  }
}
