import 'package:confetti_app/core/network/api_config.dart';
import 'package:confetti_app/core/network/dio_client.dart';
import '../../../../core/error/server_exception.dart';
import '../../../../core/utils/app_logger.dart';
import '../models/login_response_model.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<LoginResponseModel> login({
    required String email,
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
  final ApiClient client;

  AuthRemoteDataSourceImpl({required this.client});

  @override
  Future<LoginResponseModel> login({
    required String email,
    required String password,
  }) async {
    try {
      AppLogger.info('AuthRemoteDataSource: Login attempt - Email: $email');

      final result = await client.post(
        '${ApiConfig.baseUrl}/auth/login',
        data: {'email': email, 'password': password},
      );

      return result.fold(
        (failure) {
          AppLogger.error(
            'AuthRemoteDataSource: Login failed - ${failure.message}',
          );
          throw ServerException(failure.message, 0);
        },
        (data) {
          final loginResponse = LoginResponseModel.fromJson(data);
          AppLogger.info(
            'AuthRemoteDataSource: Login successful - User ID: ${loginResponse.user.id}',
          );
          return loginResponse;
        },
      );
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
      throw ServerException('Failed to login: ${e.toString()}', 0, stackTrace);
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

      final result = await client.post(
        '${ApiConfig.baseUrl}/v1/auth/sign-up',
        data: requestBody,
      );

      return result.fold(
        (failure) {
          AppLogger.error(
            'AuthRemoteDataSource: Sign-up failed - ${failure.message}',
          );
          throw ServerException(failure.message, 0);
        },
        (data) {
          final userModel = UserModel.fromJson(data);
          AppLogger.info(
            'AuthRemoteDataSource: Sign-up successful - User ID: ${userModel.id}',
          );
          return userModel;
        },
      );
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
      throw ServerException(
        'Failed to sign up: ${e.toString()}',
        0,
        stackTrace,
      );
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

      final result = await client.post(
        '${ApiConfig.baseUrl}/v1/auth/confirm-sign-up',
        data: {'id': userId, 'code': code},
      );

      return result.fold(
        (failure) {
          AppLogger.error(
            'AuthRemoteDataSource: Confirm sign-up failed - ${failure.message}',
          );
          throw ServerException(failure.message, 0);
        },
        (data) {
          final loginResponse = LoginResponseModel.fromJson(data);
          AppLogger.info(
            'AuthRemoteDataSource: Sign-up confirmed successfully - User ID: ${loginResponse.user.id}',
          );
          return loginResponse;
        },
      );
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
      throw ServerException(
        'Failed to confirm sign-up: ${e.toString()}',
        0,
        stackTrace,
      );
    }
  }

  @override
  Future<void> resendSignUpCode({required String userId}) async {
    try {
      AppLogger.info(
        'AuthRemoteDataSource: Resending sign-up code - User ID: $userId',
      );

      final result = await client.post(
        '${ApiConfig.baseUrl}/v1/auth/resend-sign-up-code',
        data: {'id': userId},
      );

      result.fold(
        (failure) {
          AppLogger.error(
            'AuthRemoteDataSource: Resend code failed - ${failure.message}',
          );
          throw ServerException(failure.message, 0);
        },
        (_) {
          AppLogger.info('AuthRemoteDataSource: Code resent successfully');
        },
      );
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
      throw ServerException(
        'Failed to resend code: ${e.toString()}',
        0,
        stackTrace,
      );
    }
  }
}
