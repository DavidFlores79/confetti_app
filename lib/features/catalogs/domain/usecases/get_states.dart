import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/state.dart';
import '../repositories/catalogs_repository.dart';

class GetStates implements UseCase<List<StateEntity>, GetStatesParams> {
  final CatalogsRepository repository;

  GetStates(this.repository);

  @override
  Future<Either<Failure, List<StateEntity>>> call(
    GetStatesParams params,
  ) async {
    return await repository.getStates(params.countryId);
  }
}

class GetStatesParams {
  final String countryId;

  GetStatesParams({required this.countryId});
}
