import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/app_logger.dart';
import '../repositories/auth_repository.dart';

class ResendSignUpCode {
  final AuthRepository repository;

  ResendSignUpCode(this.repository);

  Future<Either<Failure, void>> call({
    required String userId,
  }) async {
    AppLogger.info('ResendSignUpCode: Resending code for user ID: $userId');
    final result = await repository.resendSignUpCode(userId: userId);
    result.fold(
      (failure) => AppLogger.error('ResendSignUpCode: Failed - ${failure.message}'),
      (_) => AppLogger.info('ResendSignUpCode: Code resent successfully'),
    );
    return result;
  }
}
