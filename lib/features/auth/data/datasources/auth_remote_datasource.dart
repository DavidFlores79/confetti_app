import 'dart:convert';

import 'package:http/http.dart' as http;
import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/app_logger.dart';
import '../models/login_response_model.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<LoginResponseModel> login({
    required String phone,
    required String password,
  });

  Future<UserModel> signUp({
    required String phone,
    required String password,
    required String confirmPassword,
    String? firstName,
    String? middleName,
    String? lastName,
    String? secondLastName,
  });

  Future<LoginResponseModel> confirmSignUp({
    required String userId,
    required String code,
  });

  Future<void> resendSignUpCode({required String userId});
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
  Future<UserModel> signUp({
    required String phone,
    required String password,
    required String confirmPassword,
    String? firstName,
    String? middleName,
    String? lastName,
    String? secondLastName,
  }) async {
    try {
      AppLogger.info('AuthRemoteDataSource: Sign-up attempt - Phone: $phone');

      // Build request body with required and optional fields
      final Map<String, dynamic> requestBody = {
        'phone': phone,
        'password': password,
        'confirmPassword': confirmPassword,
      };

      // Add optional fields only if they are provided
      if (firstName != null && firstName.isNotEmpty) {
        requestBody['firstName'] = firstName;
      }
      if (middleName != null && middleName.isNotEmpty) {
        requestBody['middleName'] = middleName;
      }
      if (lastName != null && lastName.isNotEmpty) {
        requestBody['lastName'] = lastName;
      }
      if (secondLastName != null && secondLastName.isNotEmpty) {
        requestBody['secondLastName'] = secondLastName;
      }

      AppLogger.debug(
        'AuthRemoteDataSource: Sign-up request body - ${requestBody.keys.join(", ")}',
      );

      final response = await client.post(
        Uri.parse('$baseUrl/v1/auth/sign-up'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestBody),
      );

      AppLogger.debug(
        'AuthRemoteDataSource: Sign-up response - Status: ${response.statusCode}',
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = json.decode(response.body);
        final userModel = UserModel.fromJson(jsonResponse);
        AppLogger.info(
          'AuthRemoteDataSource: Sign-up successful - User ID: ${userModel.id}',
        );
        return userModel;
      } else {
        // Parse error message from API response
        String errorMessage = 'Sign-up failed';
        try {
          final errorResponse =
              json.decode(response.body) as Map<String, dynamic>;
          errorMessage = _parseErrorMessage(
            errorResponse,
            'Sign-up failed with status: ${response.statusCode}',
          );
        } catch (e) {
          errorMessage = 'Sign-up failed with status: ${response.statusCode}';
        }

        AppLogger.error(
          'AuthRemoteDataSource: Sign-up failed - ${response.statusCode}: $errorMessage',
        );
        throw ServerException(errorMessage);
      }
    } catch (e, stackTrace) {
      if (e is ServerException) {
        AppLogger.error(
          'AuthRemoteDataSource: Server exception during sign-up',
          e,
        );
        rethrow;
      }
      AppLogger.error(
        'AuthRemoteDataSource: Unexpected error during sign-up',
        e,
        stackTrace,
      );
      throw ServerException('Failed to sign up: ${e.toString()}');
    }
  }

  @override
  Future<LoginResponseModel> confirmSignUp({
    required String userId,
    required String code,
  }) async {
    try {
      AppLogger.info(
        'AuthRemoteDataSource: Confirming sign-up - User ID: $userId',
      );

      final response = await client.post(
        Uri.parse('$baseUrl/v1/auth/confirm-sign-up'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'id': userId, 'code': code}),
      );

      AppLogger.debug(
        'AuthRemoteDataSource: Confirm sign-up response - Status: ${response.statusCode}',
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = json.decode(response.body);
        final loginResponse = LoginResponseModel.fromJson(jsonResponse);
        AppLogger.info(
          'AuthRemoteDataSource: Sign-up confirmed successfully - User ID: ${loginResponse.user.id}',
        );
        return loginResponse;
      } else {
        // Parse error message from API response
        String errorMessage = 'OTP verification failed';
        try {
          final errorResponse =
              json.decode(response.body) as Map<String, dynamic>;
          errorMessage = _parseErrorMessage(
            errorResponse,
            'OTP verification failed with status: ${response.statusCode}',
          );
        } catch (e) {
          errorMessage =
              'OTP verification failed with status: ${response.statusCode}';
        }

        AppLogger.error(
          'AuthRemoteDataSource: Confirm sign-up failed - ${response.statusCode}: $errorMessage',
        );
        throw ServerException(errorMessage);
      }
    } catch (e, stackTrace) {
      if (e is ServerException) {
        AppLogger.error(
          'AuthRemoteDataSource: Server exception during confirm sign-up',
          e,
        );
        rethrow;
      }
      AppLogger.error(
        'AuthRemoteDataSource: Unexpected error during confirm sign-up',
        e,
        stackTrace,
      );
      throw ServerException('Failed to confirm sign-up: ${e.toString()}');
    }
  }

  @override
  Future<void> resendSignUpCode({required String userId}) async {
    try {
      AppLogger.info(
        'AuthRemoteDataSource: Resending sign-up code - User ID: $userId',
      );

      final response = await client.post(
        Uri.parse('$baseUrl/v1/auth/resend-sign-up-code'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'id': userId}),
      );

      AppLogger.debug(
        'AuthRemoteDataSource: Resend code response - Status: ${response.statusCode}',
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        AppLogger.info('AuthRemoteDataSource: Code resent successfully');
        return;
      } else {
        // Parse error message from API response
        String errorMessage = 'Failed to resend code';
        try {
          final errorResponse =
              json.decode(response.body) as Map<String, dynamic>;
          errorMessage = _parseErrorMessage(
            errorResponse,
            'Failed to resend code with status: ${response.statusCode}',
          );
        } catch (e) {
          errorMessage =
              'Failed to resend code with status: ${response.statusCode}';
        }

        AppLogger.error(
          'AuthRemoteDataSource: Resend code failed - ${response.statusCode}: $errorMessage',
        );
        throw ServerException(errorMessage);
      }
    } catch (e, stackTrace) {
      if (e is ServerException) {
        AppLogger.error(
          'AuthRemoteDataSource: Server exception during resend code',
          e,
        );
        rethrow;
      }
      AppLogger.error(
        'AuthRemoteDataSource: Unexpected error during resend code',
        e,
        stackTrace,
      );
      throw ServerException('Failed to resend code: ${e.toString()}');
    }
  }
}
