import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/app_logger.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class GetCurrentUser implements UseCase<User?, NoParams> {
  final AuthRepository repository;

  GetCurrentUser(this.repository);

  @override
  Future<Either<Failure, User?>> call(NoParams params) async {
    AppLogger.debug('GetCurrentUserUseCase: Getting current user');
    final result = await repository.getCurrentUser();
    result.fold(
      (failure) => AppLogger.error('GetCurrentUserUseCase: Failed - ${failure.message}'),
      (user) => AppLogger.debug('GetCurrentUserUseCase: User retrieved - exists: ${user != null}'),
    );
    return result;
  }
}
