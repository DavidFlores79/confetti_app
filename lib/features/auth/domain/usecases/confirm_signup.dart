import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/app_logger.dart';
import '../../data/models/login_response_model.dart';
import '../repositories/auth_repository.dart';

class ConfirmSignUp {
  final AuthRepository repository;

  ConfirmSignUp(this.repository);

  Future<Either<Failure, LoginResponseModel>> call({
    required String userId,
    required String code,
  }) async {
    AppLogger.info('ConfirmSignUp: Confirming OTP - User ID: $userId');
    return await repository.confirmSignUp(userId: userId, code: code);
  }
}
