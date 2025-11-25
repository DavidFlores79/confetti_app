import 'package:confetti_app/core/network/api_config.dart';
import 'package:confetti_app/core/network/dio_client.dart';
import '../../../../core/error/server_exception.dart';
import '../../../../core/utils/app_logger.dart';
import '../models/city_model.dart';
import '../models/country_model.dart';
import '../models/county_model.dart';
import '../models/economic_activity_model.dart';
import '../models/purpose_model.dart';
import '../models/settlement_model.dart';
import '../models/state_model.dart';

abstract class CatalogsRemoteDataSource {
  Future<List<CountryModel>> getCountries();
  Future<List<StateModel>> getStates(String countryId);
  Future<List<CityModel>> getCities(String countryId, String stateId);
  Future<List<CountyModel>> getCounties(String countryId, String stateId);
  Future<List<SettlementModel>> getSettlements(
    String countryId,
    String stateId,
  );
  Future<List<EconomicActivityModel>> getEconomicActivities();
  Future<List<PurposeModel>> getPurposes(String category);
}

class CatalogsRemoteDataSourceImpl implements CatalogsRemoteDataSource {
  final ApiClient client;

  CatalogsRemoteDataSourceImpl({required this.client});

  @override
  Future<List<CountryModel>> getCountries() async {
    try {
      AppLogger.info('CatalogsRemoteDataSource: Fetching countries');

      final result = await client.get(
        '${ApiConfig.baseUrl}/v1/catalogs/countries',
      );

      return result.fold(
        (failure) {
          AppLogger.error(
            'CatalogsRemoteDataSource: Get countries failed - ${failure.message}',
          );
          throw ServerException(failure.message, 0);
        },
        (data) {
          final Map<String, dynamic> jsonResponse = data;
          final List<dynamic> docs = jsonResponse['docs'] ?? [];

          final countries =
              docs
                  .map(
                    (json) =>
                        CountryModel.fromJson(json as Map<String, dynamic>),
                  )
                  .toList();

          AppLogger.info(
            'CatalogsRemoteDataSource: Fetched ${countries.length} countries '
            '(Total: ${jsonResponse['totalDocs'] ?? countries.length})',
          );
          return countries;
        },
      );
    } catch (e, stackTrace) {
      if (e is ServerException) {
        AppLogger.error(
          'CatalogsRemoteDataSource: Server exception during get countries',
          e,
        );
        rethrow;
      }
      AppLogger.error(
        'CatalogsRemoteDataSource: Unexpected error during get countries',
        e,
        stackTrace,
      );
      throw ServerException(
        'Failed to fetch countries: ${e.toString()}',
        0,
        stackTrace,
      );
    }
  }

  @override
  Future<List<StateModel>> getStates(String countryId) async {
    try {
      AppLogger.info(
        'CatalogsRemoteDataSource: Fetching states for country: $countryId',
      );

      final result = await client.get(
        '${ApiConfig.baseUrl}/v1/catalogs/countries/$countryId/states',
      );

      return result.fold(
        (failure) {
          AppLogger.error(
            'CatalogsRemoteDataSource: Get states failed - ${failure.message}',
          );
          throw ServerException(failure.message, 0);
        },
        (data) {
          final Map<String, dynamic> jsonResponse = data;
          final List<dynamic> docs = jsonResponse['docs'] ?? [];

          final states =
              docs
                  .map(
                    (json) => StateModel.fromJson(json as Map<String, dynamic>),
                  )
                  .toList();

          AppLogger.info(
            'CatalogsRemoteDataSource: Fetched ${states.length} states '
            '(Total: ${jsonResponse['totalDocs'] ?? states.length})',
          );
          return states;
        },
      );
    } catch (e, stackTrace) {
      if (e is ServerException) {
        AppLogger.error(
          'CatalogsRemoteDataSource: Server exception during get states',
          e,
        );
        rethrow;
      }
      AppLogger.error(
        'CatalogsRemoteDataSource: Unexpected error during get states',
        e,
        stackTrace,
      );
      throw ServerException(
        'Failed to fetch states: ${e.toString()}',
        0,
        stackTrace,
      );
    }
  }

  @override
  Future<List<CityModel>> getCities(String countryId, String stateId) async {
    try {
      AppLogger.info(
        'CatalogsRemoteDataSource: Fetching cities for state: $stateId',
      );

      final result = await client.get(
        '${ApiConfig.baseUrl}/v1/catalogs/countries/$countryId/states/$stateId/cities',
      );

      return result.fold(
        (failure) {
          AppLogger.error(
            'CatalogsRemoteDataSource: Get cities failed - ${failure.message}',
          );
          throw ServerException(failure.message, 0);
        },
        (data) {
          final Map<String, dynamic> jsonResponse = data;
          final List<dynamic> docs = jsonResponse['docs'] ?? [];

          final cities =
              docs
                  .map(
                    (json) => CityModel.fromJson(json as Map<String, dynamic>),
                  )
                  .toList();

          AppLogger.info(
            'CatalogsRemoteDataSource: Fetched ${cities.length} cities '
            '(Total: ${jsonResponse['totalDocs'] ?? cities.length})',
          );
          return cities;
        },
      );
    } catch (e, stackTrace) {
      if (e is ServerException) {
        AppLogger.error(
          'CatalogsRemoteDataSource: Server exception during get cities',
          e,
        );
        rethrow;
      }
      AppLogger.error(
        'CatalogsRemoteDataSource: Unexpected error during get cities',
        e,
        stackTrace,
      );
      throw ServerException(
        'Failed to fetch cities: ${e.toString()}',
        0,
        stackTrace,
      );
    }
  }

  @override
  Future<List<CountyModel>> getCounties(
    String countryId,
    String stateId,
  ) async {
    try {
      AppLogger.info(
        'CatalogsRemoteDataSource: Fetching counties for state: $stateId',
      );

      final result = await client.get(
        '${ApiConfig.baseUrl}/v1/catalogs/countries/$countryId/states/$stateId/counties',
      );

      return result.fold(
        (failure) {
          AppLogger.error(
            'CatalogsRemoteDataSource: Get counties failed - ${failure.message}',
          );
          throw ServerException(failure.message, 0);
        },
        (data) {
          final Map<String, dynamic> jsonResponse = data;
          final List<dynamic> docs = jsonResponse['docs'] ?? [];

          final counties =
              docs
                  .map(
                    (json) =>
                        CountyModel.fromJson(json as Map<String, dynamic>),
                  )
                  .toList();

          AppLogger.info(
            'CatalogsRemoteDataSource: Fetched ${counties.length} counties '
            '(Total: ${jsonResponse['totalDocs'] ?? counties.length})',
          );
          return counties;
        },
      );
    } catch (e, stackTrace) {
      if (e is ServerException) {
        AppLogger.error(
          'CatalogsRemoteDataSource: Server exception during get counties',
          e,
        );
        rethrow;
      }
      AppLogger.error(
        'CatalogsRemoteDataSource: Unexpected error during get counties',
        e,
        stackTrace,
      );
      throw ServerException(
        'Failed to fetch counties: ${e.toString()}',
        0,
        stackTrace,
      );
    }
  }

  @override
  Future<List<SettlementModel>> getSettlements(
    String countryId,
    String stateId,
  ) async {
    try {
      AppLogger.info(
        'CatalogsRemoteDataSource: Fetching settlements for state: $stateId',
      );

      final result = await client.get(
        '${ApiConfig.baseUrl}/v1/catalogs/countries/$countryId/states/$stateId/settlements',
      );

      return result.fold(
        (failure) {
          AppLogger.error(
            'CatalogsRemoteDataSource: Get settlements failed - ${failure.message}',
          );
          throw ServerException(failure.message, 0);
        },
        (data) {
          final Map<String, dynamic> jsonResponse = data;
          final List<dynamic> docs = jsonResponse['docs'] ?? [];

          final settlements =
              docs
                  .map(
                    (json) =>
                        SettlementModel.fromJson(json as Map<String, dynamic>),
                  )
                  .toList();

          AppLogger.info(
            'CatalogsRemoteDataSource: Fetched ${settlements.length} settlements '
            '(Total: ${jsonResponse['totalDocs'] ?? settlements.length})',
          );
          return settlements;
        },
      );
    } catch (e, stackTrace) {
      if (e is ServerException) {
        AppLogger.error(
          'CatalogsRemoteDataSource: Server exception during get settlements',
          e,
        );
        rethrow;
      }
      AppLogger.error(
        'CatalogsRemoteDataSource: Unexpected error during get settlements',
        e,
        stackTrace,
      );
      throw ServerException(
        'Failed to fetch settlements: ${e.toString()}',
        0,
        stackTrace,
      );
    }
  }

  @override
  Future<List<EconomicActivityModel>> getEconomicActivities() async {
    try {
      AppLogger.info('CatalogsRemoteDataSource: Fetching economic activities');

      final result = await client.get(
        '${ApiConfig.baseUrl}/v1/catalogs/economic-activities',
      );

      return result.fold(
        (failure) {
          AppLogger.error(
            'CatalogsRemoteDataSource: Get economic activities failed - ${failure.message}',
          );
          throw ServerException(failure.message, 0);
        },
        (data) {
          final Map<String, dynamic> jsonResponse = data;
          final List<dynamic> docs = jsonResponse['docs'] ?? [];

          final activities =
              docs
                  .map(
                    (json) => EconomicActivityModel.fromJson(
                      json as Map<String, dynamic>,
                    ),
                  )
                  .toList();

          AppLogger.info(
            'CatalogsRemoteDataSource: Fetched ${activities.length} economic activities '
            '(Total: ${jsonResponse['totalDocs'] ?? activities.length})',
          );
          return activities;
        },
      );
    } catch (e, stackTrace) {
      if (e is ServerException) {
        AppLogger.error(
          'CatalogsRemoteDataSource: Server exception during get economic activities',
          e,
        );
        rethrow;
      }
      AppLogger.error(
        'CatalogsRemoteDataSource: Unexpected error during get economic activities',
        e,
        stackTrace,
      );
      throw ServerException(
        'Failed to fetch economic activities: ${e.toString()}',
        0,
        stackTrace,
      );
    }
  }

  @override
  Future<List<PurposeModel>> getPurposes(String category) async {
    try {
      AppLogger.info(
        'CatalogsRemoteDataSource: Fetching purposes for category: $category',
      );

      final result = await client.get(
        '${ApiConfig.baseUrl}/v1/catalogs/purposes/$category',
      );

      return result.fold(
        (failure) {
          AppLogger.error(
            'CatalogsRemoteDataSource: Get purposes failed - ${failure.message}',
          );
          throw ServerException(failure.message, 0);
        },
        (data) {
          final Map<String, dynamic> jsonResponse = data;
          final List<dynamic> docs = jsonResponse['docs'] ?? [];

          final purposes =
              docs
                  .map(
                    (json) =>
                        PurposeModel.fromJson(json as Map<String, dynamic>),
                  )
                  .toList();

          AppLogger.info(
            'CatalogsRemoteDataSource: Fetched ${purposes.length} purposes '
            '(Total: ${jsonResponse['totalDocs'] ?? purposes.length})',
          );
          return purposes;
        },
      );
    } catch (e, stackTrace) {
      if (e is ServerException) {
        AppLogger.error(
          'CatalogsRemoteDataSource: Server exception during get purposes',
          e,
        );
        rethrow;
      }
      AppLogger.error(
        'CatalogsRemoteDataSource: Unexpected error during get purposes',
        e,
        stackTrace,
      );
      throw ServerException(
        'Failed to fetch purposes: ${e.toString()}',
        0,
        stackTrace,
      );
    }
  }
}
