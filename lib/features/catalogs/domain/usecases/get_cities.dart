import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/city.dart';
import '../repositories/catalogs_repository.dart';

class GetCities implements UseCase<List<City>, GetCitiesParams> {
  final CatalogsRepository repository;

  GetCities(this.repository);

  @override
  Future<Either<Failure, List<City>>> call(GetCitiesParams params) async {
    return await repository.getCities(params.countryId, params.stateId);
  }
}

class GetCitiesParams {
  final String countryId;
  final String stateId;

  GetCitiesParams({
    required this.countryId,
    required this.stateId,
  });
}
