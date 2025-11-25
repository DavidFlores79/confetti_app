import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/app_logger.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class Login implements UseCase<User, LoginParams> {
  final AuthRepository repository;

  Login(this.repository);

  @override
  Future<Either<Failure, User>> call(LoginParams params) async {
    AppLogger.info('LoginUseCase: Executing login - Email: ${params.email}');
    final result = await repository.login(
      email: params.email,
      password: params.password,
    );
    result.fold(
      (failure) =>
          AppLogger.error('LoginUseCase: Login failed - ${failure.message}'),
      (user) => AppLogger.info(
        'LoginUseCase: Login successful - User ID: ${user.id}',
      ),
    );
    return result;
  }
}

class LoginParams {
  final String email;
  final String password;

  LoginParams({required this.email, required this.password});
}
