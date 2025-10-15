import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
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
    } on ServerException catch (e) {
      AppLogger.error(
        'CatalogsRepository: Server exception getting countries',
        e,
      );
      return Left(ServerFailure(e.message));
    } catch (e, stackTrace) {
      AppLogger.error(
        'CatalogsRepository: Unexpected error getting countries',
        e,
        stackTrace,
      );
      return Left(ServerFailure('Failed to fetch countries: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<StateEntity>>> getStates(String countryId) async {
    try {
      final states = await remoteDataSource.getStates(countryId);
      return Right(states);
    } on ServerException catch (e) {
      AppLogger.error('CatalogsRepository: Server exception getting states', e);
      return Left(ServerFailure(e.message));
    } catch (e, stackTrace) {
      AppLogger.error(
        'CatalogsRepository: Unexpected error getting states',
        e,
        stackTrace,
      );
      return Left(ServerFailure('Failed to fetch states: ${e.toString()}'));
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
    } on ServerException catch (e) {
      AppLogger.error('CatalogsRepository: Server exception getting cities', e);
      return Left(ServerFailure(e.message));
    } catch (e, stackTrace) {
      AppLogger.error(
        'CatalogsRepository: Unexpected error getting cities',
        e,
        stackTrace,
      );
      return Left(ServerFailure('Failed to fetch cities: ${e.toString()}'));
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
    } on ServerException catch (e) {
      AppLogger.error(
        'CatalogsRepository: Server exception getting counties',
        e,
      );
      return Left(ServerFailure(e.message));
    } catch (e, stackTrace) {
      AppLogger.error(
        'CatalogsRepository: Unexpected error getting counties',
        e,
        stackTrace,
      );
      return Left(ServerFailure('Failed to fetch counties: ${e.toString()}'));
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
    } on ServerException catch (e) {
      AppLogger.error(
        'CatalogsRepository: Server exception getting settlements',
        e,
      );
      return Left(ServerFailure(e.message));
    } catch (e, stackTrace) {
      AppLogger.error(
        'CatalogsRepository: Unexpected error getting settlements',
        e,
        stackTrace,
      );
      return Left(
        ServerFailure('Failed to fetch settlements: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, List<EconomicActivity>>>
  getEconomicActivities() async {
    try {
      final activities = await remoteDataSource.getEconomicActivities();
      return Right(activities);
    } on ServerException catch (e) {
      AppLogger.error(
        'CatalogsRepository: Server exception getting economic activities',
        e,
      );
      return Left(ServerFailure(e.message));
    } catch (e, stackTrace) {
      AppLogger.error(
        'CatalogsRepository: Unexpected error getting economic activities',
        e,
        stackTrace,
      );
      return Left(
        ServerFailure('Failed to fetch economic activities: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, List<Purpose>>> getPurposes(String category) async {
    try {
      final purposes = await remoteDataSource.getPurposes(category);
      return Right(purposes);
    } on ServerException catch (e) {
      AppLogger.error(
        'CatalogsRepository: Server exception getting purposes',
        e,
      );
      return Left(ServerFailure(e.message));
    } catch (e, stackTrace) {
      AppLogger.error(
        'CatalogsRepository: Unexpected error getting purposes',
        e,
        stackTrace,
      );
      return Left(ServerFailure('Failed to fetch purposes: ${e.toString()}'));
    }
  }
}
