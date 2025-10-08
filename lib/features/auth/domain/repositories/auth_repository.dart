import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/login_response_model.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> login({
    required String phone,
    required String password,
  });
  
  Future<Either<Failure, User>> signUp({
    required String phone,
    required String password,
    required String confirmPassword,
    String? firstName,
    String? middleName,
    String? lastName,
    String? secondLastName,
  });
  
  Future<Either<Failure, LoginResponseModel>> confirmSignUp({
    required String userId,
    required String code,
  });
  
  Future<Either<Failure, void>> logout();
  
  Future<Either<Failure, User?>> getCurrentUser();
  
  Future<Either<Failure, bool>> isLoggedIn();
  
  Future<Either<Failure, String?>> getAccessToken();
  
  Future<Either<Failure, String?>> getRefreshToken();
}
