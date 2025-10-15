import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../data/models/country_model.dart';
import '../repositories/catalogs_repository.dart';

class GetCountries implements UseCase<List<CountryModel>, NoParams> {
  final CatalogsRepository repository;

  GetCountries(this.repository);

  @override
  Future<Either<Failure, List<CountryModel>>> call(NoParams params) async {
    return await repository.getCountries();
  }
}
