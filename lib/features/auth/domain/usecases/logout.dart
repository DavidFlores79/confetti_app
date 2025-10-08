import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/app_logger.dart';
import '../repositories/auth_repository.dart';

class Logout implements UseCase<void, NoParams> {
  final AuthRepository repository;

  Logout(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    AppLogger.info('LogoutUseCase: Executing logout');
    final result = await repository.logout();
    result.fold(
      (failure) => AppLogger.error('LogoutUseCase: Logout failed - ${failure.message}'),
      (_) => AppLogger.info('LogoutUseCase: Logout successful'),
    );
    return result;
  }
}
