import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/utils/app_logger.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';

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
  Future<Either<Failure, User>> register({
    required String phone,
    required String password,
    required String name,
  }) async {
    AppLogger.info('AuthRepository: Registration request - Phone: $phone, Name: $name');
    
    if (await networkInfo.isConnected) {
      try {
        AppLogger.debug('AuthRepository: Network available, calling remote data source');
        final loginResponse = await remoteDataSource.register(
          phone: phone,
          password: password,
          name: name,
        );
        
        AppLogger.debug('AuthRepository: Caching user and tokens');
        await localDataSource.cacheUser(loginResponse.user);
        await localDataSource.cacheTokens(
          jwt: loginResponse.jwt,
          refreshToken: loginResponse.refreshToken,
          kid: loginResponse.kid,
        );
        
        AppLogger.info('AuthRepository: Registration successful - User: ${loginResponse.user.phone}');
        return Right(loginResponse.user);
      } on ServerException catch (e) {
        AppLogger.error('AuthRepository: Server exception during registration', e);
        return Left(ServerFailure(e.message));
      } on CacheException catch (e) {
        AppLogger.error('AuthRepository: Cache exception during registration', e);
        return Left(CacheFailure(e.message));
      } catch (e, stackTrace) {
        AppLogger.error('AuthRepository: Unexpected error during registration', e, stackTrace);
        return Left(ServerFailure('Unexpected error: ${e.toString()}'));
      }
    } else {
      AppLogger.warning('AuthRepository: Registration failed - No internet connection');
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
}
