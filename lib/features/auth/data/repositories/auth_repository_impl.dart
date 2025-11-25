import 'package:dartz/dartz.dart';
import '../../../../core/error/exception_to_failure_mapper.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/utils/app_logger.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/login_response_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  }) async {
    AppLogger.info('AuthRepository: Login request - Email: $email');

    if (await networkInfo.isConnected) {
      try {
        AppLogger.debug(
          'AuthRepository: Network available, calling remote data source',
        );
        final loginResponse = await remoteDataSource.login(
          email: email,
          password: password,
        );

        AppLogger.debug('AuthRepository: Caching user and tokens');
        await localDataSource.cacheUser(loginResponse.user);
        await localDataSource.cacheTokens(jwt: loginResponse.jwt);

        AppLogger.info(
          'AuthRepository: Login successful - User: ${loginResponse.user.email}',
        );
        return Right(loginResponse.user);
      } on Exception catch (e, stackTrace) {
        AppLogger.error(
          'AuthRepository: Exception during login',
          e,
          stackTrace,
        );
        return Left(e.toFailure());
      }
    } else {
      AppLogger.warning(
        'AuthRepository: Login failed - No internet connection',
      );
      return Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, User>> signUp({
    required String phone,
    required String password,
    required String confirmPassword,
    String? firstName,
    String? middleName,
    String? lastName,
    String? secondLastName,
  }) async {
    AppLogger.info('AuthRepository: Sign-up request - Phone: $phone');

    if (await networkInfo.isConnected) {
      try {
        AppLogger.debug(
          'AuthRepository: Network available, calling remote data source',
        );
        final userModel = await remoteDataSource.signUp(
          phone: phone,
          password: password,
          confirmPassword: confirmPassword,
          firstName: firstName,
          middleName: middleName,
          lastName: lastName,
          secondLastName: secondLastName,
        );

        AppLogger.debug(
          'AuthRepository: Caching user (no tokens returned from sign-up)',
        );
        await localDataSource.cacheUser(userModel);

        AppLogger.info(
          'AuthRepository: Sign-up successful - User: ${userModel.email}',
        );
        return Right(userModel);
      } on Exception catch (e, stackTrace) {
        AppLogger.error(
          'AuthRepository: Exception during sign-up',
          e,
          stackTrace,
        );
        return Left(e.toFailure());
      }
    } else {
      AppLogger.warning(
        'AuthRepository: Sign-up failed - No internet connection',
      );
      return Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      AppLogger.info('AuthRepository: Logout request');
      await localDataSource.clearUser();
      AppLogger.info('AuthRepository: Logout successful');
      return const Right(null);
    } on Exception catch (e, stackTrace) {
      AppLogger.error('AuthRepository: Exception during logout', e, stackTrace);
      return Left(e.toFailure());
    }
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      AppLogger.debug('AuthRepository: Getting current user');
      final user = await localDataSource.getCachedUser();
      AppLogger.debug(
        'AuthRepository: Current user retrieved - exists: ${user != null}',
      );
      return Right(user);
    } on Exception catch (e, stackTrace) {
      AppLogger.error(
        'AuthRepository: Exception getting current user',
        e,
        stackTrace,
      );
      return Left(e.toFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> isLoggedIn() async {
    try {
      AppLogger.debug('AuthRepository: Checking login status');
      final isLoggedIn = await localDataSource.isLoggedIn();
      AppLogger.debug('AuthRepository: Login status - isLoggedIn: $isLoggedIn');
      return Right(isLoggedIn);
    } on Exception catch (e, stackTrace) {
      AppLogger.error(
        'AuthRepository: Exception checking auth status',
        e,
        stackTrace,
      );
      return Left(e.toFailure());
    }
  }

  @override
  Future<Either<Failure, String?>> getAccessToken() async {
    try {
      AppLogger.debug('AuthRepository: Getting access token');
      final token = await localDataSource.getAccessToken();
      AppLogger.debug(
        'AuthRepository: Access token retrieved - exists: ${token != null}',
      );
      return Right(token);
    } on Exception catch (e, stackTrace) {
      AppLogger.error(
        'AuthRepository: Exception getting access token',
        e,
        stackTrace,
      );
      return Left(e.toFailure());
    }
  }

  @override
  Future<Either<Failure, String?>> getRefreshToken() async {
    try {
      AppLogger.debug('AuthRepository: Getting refresh token');
      final token = await localDataSource.getRefreshToken();
      AppLogger.debug(
        'AuthRepository: Refresh token retrieved - exists: ${token != null}',
      );
      return Right(token);
    } on Exception catch (e, stackTrace) {
      AppLogger.error(
        'AuthRepository: Exception getting refresh token',
        e,
        stackTrace,
      );
      return Left(e.toFailure());
    }
  }

  @override
  Future<Either<Failure, LoginResponseModel>> confirmSignUp({
    required String userId,
    required String code,
  }) async {
    AppLogger.info(
      'AuthRepository: Confirm sign-up request - User ID: $userId',
    );

    if (await networkInfo.isConnected) {
      try {
        AppLogger.debug(
          'AuthRepository: Network available, calling remote data source',
        );
        final loginResponse = await remoteDataSource.confirmSignUp(
          userId: userId,
          code: code,
        );

        AppLogger.debug('AuthRepository: Caching user and tokens');
        await localDataSource.cacheUser(loginResponse.user);
        await localDataSource.cacheTokens(jwt: loginResponse.jwt);

        AppLogger.info(
          'AuthRepository: Sign-up confirmed successfully - User: ${loginResponse.user.email}',
        );
        return Right(loginResponse);
      } on Exception catch (e, stackTrace) {
        AppLogger.error(
          'AuthRepository: Exception during confirm sign-up',
          e,
          stackTrace,
        );
        return Left(e.toFailure());
      }
    } else {
      AppLogger.warning(
        'AuthRepository: Confirm sign-up failed - No internet connection',
      );
      return Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> resendSignUpCode({
    required String userId,
  }) async {
    AppLogger.info(
      'AuthRepository: Resend sign-up code request - User ID: $userId',
    );

    if (await networkInfo.isConnected) {
      try {
        AppLogger.debug(
          'AuthRepository: Network available, calling remote data source',
        );
        await remoteDataSource.resendSignUpCode(userId: userId);

        AppLogger.info('AuthRepository: Code resent successfully');
        return const Right(null);
      } on Exception catch (e, stackTrace) {
        AppLogger.error(
          'AuthRepository: Exception during resend code',
          e,
          stackTrace,
        );
        return Left(e.toFailure());
      }
    } else {
      AppLogger.warning(
        'AuthRepository: Resend code failed - No internet connection',
      );
      return Left(NetworkFailure('No internet connection'));
    }
  }
}
