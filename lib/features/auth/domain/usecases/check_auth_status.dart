import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/app_logger.dart';
import '../repositories/auth_repository.dart';

class CheckAuthStatus implements UseCase<bool, NoParams> {
  final AuthRepository repository;

  CheckAuthStatus(this.repository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    AppLogger.debug('CheckAuthStatusUseCase: Checking auth status');
    final result = await repository.isLoggedIn();
    result.fold(
      (failure) => AppLogger.error('CheckAuthStatusUseCase: Failed - ${failure.message}'),
      (isLoggedIn) => AppLogger.debug('CheckAuthStatusUseCase: Status - isLoggedIn: $isLoggedIn'),
    );
    return result;
  }
}
