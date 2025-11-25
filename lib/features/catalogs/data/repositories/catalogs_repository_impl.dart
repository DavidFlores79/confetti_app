import 'package:dartz/dartz.dart';
import '../../../../core/error/exception_to_failure_mapper.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/app_logger.dart';
import '../../domain/entities/city.dart';
import '../../domain/entities/county.dart';
import '../../domain/entities/economic_activity.dart';
import '../../domain/entities/purpose.dart';
import '../../domain/entities/settlement.dart';
import '../../domain/entities/state.dart';
import '../../domain/repositories/catalogs_repository.dart';
import '../datasources/catalogs_remote_datasource.dart';
import '../models/country_model.dart';

class CatalogsRepositoryImpl implements CatalogsRepository {
  final CatalogsRemoteDataSource remoteDataSource;

  CatalogsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<CountryModel>>> getCountries() async {
    try {
      final countries = await remoteDataSource.getCountries();
      return Right(countries);
    } on Exception catch (e, stackTrace) {
      AppLogger.error(
        'CatalogsRepository: Exception getting countries',
        e,
        stackTrace,
      );
      return Left(e.toFailure());
    }
  }

  @override
  Future<Either<Failure, List<StateEntity>>> getStates(String countryId) async {
    try {
      final states = await remoteDataSource.getStates(countryId);
      return Right(states);
    } on Exception catch (e, stackTrace) {
      AppLogger.error(
        'CatalogsRepository: Exception getting states',
        e,
        stackTrace,
      );
      return Left(e.toFailure());
    }
  }

  @override
  Future<Either<Failure, List<City>>> getCities(
    String countryId,
    String stateId,
  ) async {
    try {
      final cities = await remoteDataSource.getCities(countryId, stateId);
      return Right(cities);
    } on Exception catch (e, stackTrace) {
      AppLogger.error(
        'CatalogsRepository: Exception getting cities',
        e,
        stackTrace,
      );
      return Left(e.toFailure());
    }
  }

  @override
  Future<Either<Failure, List<County>>> getCounties(
    String countryId,
    String stateId,
  ) async {
    try {
      final counties = await remoteDataSource.getCounties(countryId, stateId);
      return Right(counties);
    } on Exception catch (e, stackTrace) {
      AppLogger.error(
        'CatalogsRepository: Exception getting counties',
        e,
        stackTrace,
      );
      return Left(e.toFailure());
    }
  }

  @override
  Future<Either<Failure, List<Settlement>>> getSettlements(
    String countryId,
    String stateId,
  ) async {
    try {
      final settlements = await remoteDataSource.getSettlements(
        countryId,
        stateId,
      );
      return Right(settlements);
    } on Exception catch (e, stackTrace) {
      AppLogger.error(
        'CatalogsRepository: Exception getting settlements',
        e,
        stackTrace,
      );
      return Left(e.toFailure());
    }
  }

  @override
  Future<Either<Failure, List<EconomicActivity>>>
  getEconomicActivities() async {
    try {
      final activities = await remoteDataSource.getEconomicActivities();
      return Right(activities);
    } on Exception catch (e, stackTrace) {
      AppLogger.error(
        'CatalogsRepository: Exception getting economic activities',
        e,
        stackTrace,
      );
      return Left(e.toFailure());
    }
  }

  @override
  Future<Either<Failure, List<Purpose>>> getPurposes(String category) async {
    try {
      final purposes = await remoteDataSource.getPurposes(category);
      return Right(purposes);
    } on Exception catch (e, stackTrace) {
      AppLogger.error(
        'CatalogsRepository: Exception getting purposes',
        e,
        stackTrace,
      );
      return Left(e.toFailure());
    }
  }
}
