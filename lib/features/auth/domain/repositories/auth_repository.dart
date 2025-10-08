import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> login({
    required String phone,
    required String password,
  });
  
  Future<Either<Failure, User>> register({
    required String phone,
    required String password,
    required String name,
  });
  
  Future<Either<Failure, void>> logout();
  
  Future<Either<Failure, User?>> getCurrentUser();
  
  Future<Either<Failure, bool>> isLoggedIn();
  
  Future<Either<Failure, String?>> getAccessToken();
  
  Future<Either<Failure, String?>> getRefreshToken();
}
