import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
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
    required String phone,
    required String password,
  }) async {
    AppLogger.info('AuthRepository: Login request - Phone: $phone');
    
    if (await networkInfo.isConnected) {
      try {
        AppLogger.debug('AuthRepository: Network available, calling remote data source');
        final loginResponse = await remoteDataSource.login(
          phone: phone,
          password: password,
        );
        
        AppLogger.debug('AuthRepository: Caching user and tokens');
        await localDataSource.cacheUser(loginResponse.user);
        await localDataSource.cacheTokens(
          jwt: loginResponse.jwt,
          refreshToken: loginResponse.refreshToken,
          kid: loginResponse.kid,
        );
        
        AppLogger.info('AuthRepository: Login successful - User: ${loginResponse.user.phone}');
        return Right(loginResponse.user);
      } on ServerException catch (e) {
        AppLogger.error('AuthRepository: Server exception during login', e);
        return Left(ServerFailure(e.message));
      } on CacheException catch (e) {
        AppLogger.error('AuthRepository: Cache exception during login', e);
        return Left(CacheFailure(e.message));
      } catch (e, stackTrace) {
        AppLogger.error('AuthRepository: Unexpected error during login', e, stackTrace);
        return Left(ServerFailure('Unexpected error: ${e.toString()}'));
      }
    } else {
      AppLogger.warning('AuthRepository: Login failed - No internet connection');
      return const Left(NetworkFailure('No internet connection'));
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
        AppLogger.debug('AuthRepository: Network available, calling remote data source');
        final userModel = await remoteDataSource.signUp(
          phone: phone,
          password: password,
          confirmPassword: confirmPassword,
          firstName: firstName,
          middleName: middleName,
          lastName: lastName,
          secondLastName: secondLastName,
        );
        
        AppLogger.debug('AuthRepository: Caching user (no tokens returned from sign-up)');
        await localDataSource.cacheUser(userModel);
        
        AppLogger.info('AuthRepository: Sign-up successful - User: ${userModel.phone}');
        return Right(userModel);
      } on ServerException catch (e) {
        AppLogger.error('AuthRepository: Server exception during sign-up', e);
        return Left(ServerFailure(e.message));
      } on CacheException catch (e) {
        AppLogger.error('AuthRepository: Cache exception during sign-up', e);
        return Left(CacheFailure(e.message));
      } catch (e, stackTrace) {
        AppLogger.error('AuthRepository: Unexpected error during sign-up', e, stackTrace);
        return Left(ServerFailure('Unexpected error: ${e.toString()}'));
      }
    } else {
      AppLogger.warning('AuthRepository: Sign-up failed - No internet connection');
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      AppLogger.info('AuthRepository: Logout request');
      await localDataSource.clearUser();
      AppLogger.info('AuthRepository: Logout successful');
      return const Right(null);
    } on CacheException catch (e) {
      AppLogger.error('AuthRepository: Cache exception during logout', e);
      return Left(CacheFailure(e.message));
    } catch (e, stackTrace) {
      AppLogger.error('AuthRepository: Unexpected error during logout', e, stackTrace);
      return Left(CacheFailure('Failed to logout: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      AppLogger.debug('AuthRepository: Getting current user');
      final user = await localDataSource.getCachedUser();
      AppLogger.debug('AuthRepository: Current user retrieved - exists: ${user != null}');
      return Right(user);
    } on CacheException catch (e) {
      AppLogger.error('AuthRepository: Cache exception getting current user', e);
      return Left(CacheFailure(e.message));
    } catch (e, stackTrace) {
      AppLogger.error('AuthRepository: Unexpected error getting current user', e, stackTrace);
      return Left(CacheFailure('Failed to get current user: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, bool>> isLoggedIn() async {
    try {
      AppLogger.debug('AuthRepository: Checking login status');
      final isLoggedIn = await localDataSource.isLoggedIn();
      AppLogger.debug('AuthRepository: Login status - isLoggedIn: $isLoggedIn');
      return Right(isLoggedIn);
    } on CacheException catch (e) {
      AppLogger.error('AuthRepository: Cache exception checking auth status', e);
      return Left(CacheFailure(e.message));
    } catch (e, stackTrace) {
      AppLogger.error('AuthRepository: Unexpected error checking auth status', e, stackTrace);
      return Left(CacheFailure('Failed to check auth status: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, String?>> getAccessToken() async {
    try {
      AppLogger.debug('AuthRepository: Getting access token');
      final token = await localDataSource.getAccessToken();
      AppLogger.debug('AuthRepository: Access token retrieved - exists: ${token != null}');
      return Right(token);
    } on CacheException catch (e) {
      AppLogger.error('AuthRepository: Cache exception getting access token', e);
      return Left(CacheFailure(e.message));
    } catch (e, stackTrace) {
      AppLogger.error('AuthRepository: Unexpected error getting access token', e, stackTrace);
      return Left(CacheFailure('Failed to get access token: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, String?>> getRefreshToken() async {
    try {
      AppLogger.debug('AuthRepository: Getting refresh token');
      final token = await localDataSource.getRefreshToken();
      AppLogger.debug('AuthRepository: Refresh token retrieved - exists: ${token != null}');
      return Right(token);
    } on CacheException catch (e) {
      AppLogger.error('AuthRepository: Cache exception getting refresh token', e);
      return Left(CacheFailure(e.message));
    } catch (e, stackTrace) {
      AppLogger.error('AuthRepository: Unexpected error getting refresh token', e, stackTrace);
      return Left(CacheFailure('Failed to get refresh token: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, LoginResponseModel>> confirmSignUp({
    required String userId,
    required String code,
  }) async {
    AppLogger.info('AuthRepository: Confirm sign-up request - User ID: $userId');
    
    if (await networkInfo.isConnected) {
      try {
        AppLogger.debug('AuthRepository: Network available, calling remote data source');
        final loginResponse = await remoteDataSource.confirmSignUp(
          userId: userId,
          code: code,
        );
        
        AppLogger.debug('AuthRepository: Caching user and tokens');
        await localDataSource.cacheUser(loginResponse.user);
        await localDataSource.cacheTokens(
          jwt: loginResponse.jwt,
          refreshToken: loginResponse.refreshToken,
          kid: loginResponse.kid,
        );
        
        AppLogger.info('AuthRepository: Sign-up confirmed successfully - User: ${loginResponse.user.phone}');
        return Right(loginResponse);
      } on ServerException catch (e) {
        AppLogger.error('AuthRepository: Server exception during confirm sign-up', e);
        return Left(ServerFailure(e.message));
      } on CacheException catch (e) {
        AppLogger.error('AuthRepository: Cache exception during confirm sign-up', e);
        return Left(CacheFailure(e.message));
      } catch (e, stackTrace) {
        AppLogger.error('AuthRepository: Unexpected error during confirm sign-up', e, stackTrace);
        return Left(ServerFailure('Unexpected error: ${e.toString()}'));
      }
    } else {
      AppLogger.warning('AuthRepository: Confirm sign-up failed - No internet connection');
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> resendSignUpCode({
    required String userId,
  }) async {
    AppLogger.info('AuthRepository: Resend sign-up code request - User ID: $userId');
    
    if (await networkInfo.isConnected) {
      try {
        AppLogger.debug('AuthRepository: Network available, calling remote data source');
        await remoteDataSource.resendSignUpCode(
          userId: userId,
        );
        
        AppLogger.info('AuthRepository: Code resent successfully');
        return const Right(null);
      } on ServerException catch (e) {
        AppLogger.error('AuthRepository: Server exception during resend code', e);
        return Left(ServerFailure(e.message));
      } catch (e, stackTrace) {
        AppLogger.error('AuthRepository: Unexpected error during resend code', e, stackTrace);
        return Left(ServerFailure('Unexpected error: ${e.toString()}'));
      }
    } else {
      AppLogger.warning('AuthRepository: Resend code failed - No internet connection');
      return const Left(NetworkFailure('No internet connection'));
    }
  }
}
