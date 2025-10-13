import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/app_logger.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class SignUp implements UseCase<User, SignUpParams> {
  final AuthRepository repository;

  SignUp(this.repository);

  @override
  Future<Either<Failure, User>> call(SignUpParams params) async {
    AppLogger.info('SignUp UseCase: Executing sign-up - Phone: ${params.phone}');
    return await repository.signUp(
      phone: params.phone,
      password: params.password,
      confirmPassword: params.confirmPassword,
      firstName: params.firstName,
      middleName: params.middleName,
      lastName: params.lastName,
      secondLastName: params.secondLastName,
    );
  }
}

class SignUpParams {
  final String phone;
  final String password;
  final String confirmPassword;
  final String? firstName;
  final String? middleName;
  final String? lastName;
  final String? secondLastName;

  SignUpParams({
    required this.phone,
    required this.password,
    required this.confirmPassword,
    this.firstName,
    this.middleName,
    this.lastName,
    this.secondLastName,
  });
}
