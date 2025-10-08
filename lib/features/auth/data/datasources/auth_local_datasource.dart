import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/app_logger.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<UserModel?> getCachedUser();
  Future<void> cacheUser(UserModel user);
  Future<void> clearUser();
  Future<bool> isLoggedIn();
  Future<void> cacheTokens({
    required String jwt,
    required String refreshToken,
    required String kid,
  });
  Future<String?> getAccessToken();
  Future<String?> getRefreshToken();
  Future<String?> getKid();
  Future<void> clearTokens();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  static const String _cachedUserKey = 'CACHED_USER';
  static const String _isLoggedInKey = 'IS_LOGGED_IN';
  static const String _jwtKey = 'JWT_TOKEN';
  static const String _refreshTokenKey = 'REFRESH_TOKEN';
  static const String _kidKey = 'KID';
  
  final SharedPreferences sharedPreferences;

  AuthLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<UserModel?> getCachedUser() async {
    try {
      AppLogger.debug('AuthLocalDataSource: Getting cached user');
      final jsonString = sharedPreferences.getString(_cachedUserKey);
      if (jsonString != null) {
        final user = UserModel.fromJsonString(jsonString);
        AppLogger.info('AuthLocalDataSource: Cached user found - ID: ${user.id}, Phone: ${user.phone}');
        return user;
      }
      AppLogger.debug('AuthLocalDataSource: No cached user found');
      return null;
    } catch (e, stackTrace) {
      AppLogger.error('AuthLocalDataSource: Failed to get cached user', e, stackTrace);
      throw CacheException('Failed to get cached user: ${e.toString()}');
    }
  }

  @override
  Future<void> cacheUser(UserModel user) async {
    try {
      AppLogger.debug('AuthLocalDataSource: Caching user - ID: ${user.id}, Phone: ${user.phone}');
      await sharedPreferences.setString(_cachedUserKey, user.toJsonString());
      await sharedPreferences.setBool(_isLoggedInKey, true);
      AppLogger.info('AuthLocalDataSource: User cached successfully');
    } catch (e, stackTrace) {
      AppLogger.error('AuthLocalDataSource: Failed to cache user', e, stackTrace);
      throw CacheException('Failed to cache user: ${e.toString()}');
    }
  }

  @override
  Future<void> clearUser() async {
    try {
      AppLogger.debug('AuthLocalDataSource: Clearing user data');
      await sharedPreferences.remove(_cachedUserKey);
      await sharedPreferences.setBool(_isLoggedInKey, false);
      await clearTokens();
      AppLogger.info('AuthLocalDataSource: User data cleared successfully');
    } catch (e, stackTrace) {
      AppLogger.error('AuthLocalDataSource: Failed to clear user', e, stackTrace);
      throw CacheException('Failed to clear user: ${e.toString()}');
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    try {
      final isLoggedIn = sharedPreferences.getBool(_isLoggedInKey) ?? false;
      AppLogger.debug('AuthLocalDataSource: Login status checked - isLoggedIn: $isLoggedIn');
      return isLoggedIn;
    } catch (e, stackTrace) {
      AppLogger.error('AuthLocalDataSource: Failed to check login status', e, stackTrace);
      throw CacheException('Failed to check login status: ${e.toString()}');
    }
  }

  @override
  Future<void> cacheTokens({
    required String jwt,
    required String refreshToken,
    required String kid,
  }) async {
    try {
      AppLogger.debug('AuthLocalDataSource: Caching tokens - kid: $kid');
      await sharedPreferences.setString(_jwtKey, jwt);
      await sharedPreferences.setString(_refreshTokenKey, refreshToken);
      await sharedPreferences.setString(_kidKey, kid);
      AppLogger.info('AuthLocalDataSource: Tokens cached successfully');
    } catch (e, stackTrace) {
      AppLogger.error('AuthLocalDataSource: Failed to cache tokens', e, stackTrace);
      throw CacheException('Failed to cache tokens: ${e.toString()}');
    }
  }

  @override
  Future<String?> getAccessToken() async {
    try {
      final token = sharedPreferences.getString(_jwtKey);
      AppLogger.debug('AuthLocalDataSource: Access token retrieved - exists: ${token != null}');
      return token;
    } catch (e, stackTrace) {
      AppLogger.error('AuthLocalDataSource: Failed to get access token', e, stackTrace);
      throw CacheException('Failed to get access token: ${e.toString()}');
    }
  }

  @override
  Future<String?> getRefreshToken() async {
    try {
      final token = sharedPreferences.getString(_refreshTokenKey);
      AppLogger.debug('AuthLocalDataSource: Refresh token retrieved - exists: ${token != null}');
      return token;
    } catch (e, stackTrace) {
      AppLogger.error('AuthLocalDataSource: Failed to get refresh token', e, stackTrace);
      throw CacheException('Failed to get refresh token: ${e.toString()}');
    }
  }

  @override
  Future<String?> getKid() async {
    try {
      final kid = sharedPreferences.getString(_kidKey);
      AppLogger.debug('AuthLocalDataSource: Kid retrieved - value: $kid');
      return kid;
    } catch (e, stackTrace) {
      AppLogger.error('AuthLocalDataSource: Failed to get kid', e, stackTrace);
      throw CacheException('Failed to get kid: ${e.toString()}');
    }
  }

  @override
  Future<void> clearTokens() async {
    try {
      AppLogger.debug('AuthLocalDataSource: Clearing tokens');
      await sharedPreferences.remove(_jwtKey);
      await sharedPreferences.remove(_refreshTokenKey);
      await sharedPreferences.remove(_kidKey);
      AppLogger.info('AuthLocalDataSource: Tokens cleared successfully');
    } catch (e, stackTrace) {
      AppLogger.error('AuthLocalDataSource: Failed to clear tokens', e, stackTrace);
      throw CacheException('Failed to clear tokens: ${e.toString()}');
    }
  }
}
