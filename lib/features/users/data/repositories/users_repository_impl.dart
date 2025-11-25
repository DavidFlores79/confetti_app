import 'package:confetti_app/core/error/exception_to_failure_mapper.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../auth/data/models/user_model.dart';
import '../../domain/repositories/users_repository.dart';
import '../datasources/user_remote_datasource.dart';

class UsersRepositoryImpl implements UsersRepository {
  final UserRemoteDataSource remoteDataSource;

  UsersRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<UserModel>>> getUsers() async {
    try {
      final users = await remoteDataSource.getUsers();
      return Right(users);
    } on Exception catch (e) {
      final failure = e.toFailure();
      return Left(failure); // ahora failure es ServerFailure o CacheFailure
    }
  }
}
