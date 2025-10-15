import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/country_model.dart';
import '../entities/city.dart';
import '../entities/county.dart';
import '../entities/economic_activity.dart';
import '../entities/purpose.dart';
import '../entities/settlement.dart';
import '../entities/state.dart';

abstract class CatalogsRepository {
  Future<Either<Failure, List<CountryModel>>> getCountries();
  Future<Either<Failure, List<StateEntity>>> getStates(String countryId);
  Future<Either<Failure, List<City>>> getCities(
    String countryId,
    String stateId,
  );
  Future<Either<Failure, List<County>>> getCounties(
    String countryId,
    String stateId,
  );
  Future<Either<Failure, List<Settlement>>> getSettlements(
    String countryId,
    String stateId,
  );
  Future<Either<Failure, List<EconomicActivity>>> getEconomicActivities();
  Future<Either<Failure, List<Purpose>>> getPurposes(String category);
}
