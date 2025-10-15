import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/county.dart';
import '../repositories/catalogs_repository.dart';

class GetCounties implements UseCase<List<County>, GetCountiesParams> {
  final CatalogsRepository repository;

  GetCounties(this.repository);

  @override
  Future<Either<Failure, List<County>>> call(GetCountiesParams params) async {
    return await repository.getCounties(params.countryId, params.stateId);
  }
}

class GetCountiesParams {
  final String countryId;
  final String stateId;

  GetCountiesParams({
    required this.countryId,
    required this.stateId,
  });
}
