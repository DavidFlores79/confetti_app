import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/settlement.dart';
import '../repositories/catalogs_repository.dart';

class GetSettlements implements UseCase<List<Settlement>, GetSettlementsParams> {
  final CatalogsRepository repository;

  GetSettlements(this.repository);

  @override
  Future<Either<Failure, List<Settlement>>> call(
    GetSettlementsParams params,
  ) async {
    return await repository.getSettlements(params.countryId, params.stateId);
  }
}

class GetSettlementsParams {
  final String countryId;
  final String stateId;

  GetSettlementsParams({
    required this.countryId,
    required this.stateId,
  });
}
