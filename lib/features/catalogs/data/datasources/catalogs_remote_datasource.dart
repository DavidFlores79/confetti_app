import 'dart:convert';

import 'package:http/http.dart' as http;
import '../../../../core/error/exceptions.dart';
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
  Future<List<SettlementModel>> getSettlements(String countryId, String stateId);
  Future<List<EconomicActivityModel>> getEconomicActivities();
  Future<List<PurposeModel>> getPurposes(String category);
}

class CatalogsRemoteDataSourceImpl implements CatalogsRemoteDataSource {
  final http.Client client;
  static const String baseUrl = 'http://192.168.0.176:3000';

  CatalogsRemoteDataSourceImpl({required this.client});

  String _parseErrorMessage(
    Map<String, dynamic> errorResponse,
    String fallbackMessage,
  ) {
    try {
      final message = errorResponse['message'];

      if (message is List) {
        if (message.isEmpty) {
          return fallbackMessage;
        }
        return message.map((e) => e.toString()).join('\n');
      }

      if (message is String) {
        return message;
      }

      if (errorResponse['error'] is String) {
        return errorResponse['error'];
      }

      return fallbackMessage;
    } catch (e) {
      AppLogger.warning(
        'CatalogsRemoteDataSource: Failed to parse error message - $e',
      );
      return fallbackMessage;
    }
  }

  @override
  Future<List<CountryModel>> getCountries() async {
    try {
      AppLogger.info('CatalogsRemoteDataSource: Fetching countries');

      final response = await client.get(
        Uri.parse('$baseUrl/v1/catalogs/countries'),
        headers: {'Content-Type': 'application/json'},
      );

      AppLogger.debug(
        'CatalogsRemoteDataSource: Countries response - Status: ${response.statusCode}',
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        
        // Extract the 'docs' array from the paginated response
        final List<dynamic> docs = jsonResponse['docs'] ?? [];
        
        final countries = docs
            .map((json) => CountryModel.fromJson(json as Map<String, dynamic>))
            .toList();
        
        AppLogger.info(
          'CatalogsRemoteDataSource: Fetched ${countries.length} countries '
          '(Total: ${jsonResponse['totalDocs'] ?? countries.length})',
        );
        return countries;
      } else {
        String errorMessage = 'Failed to fetch countries';
        try {
          final errorResponse =
              json.decode(response.body) as Map<String, dynamic>;
          errorMessage = _parseErrorMessage(
            errorResponse,
            'Failed to fetch countries with status: ${response.statusCode}',
          );
        } catch (e) {
          errorMessage =
              'Failed to fetch countries with status: ${response.statusCode}';
        }

        AppLogger.error(
          'CatalogsRemoteDataSource: Get countries failed - ${response.statusCode}: $errorMessage',
        );
        throw ServerException(errorMessage);
      }
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
      throw ServerException('Failed to fetch countries: ${e.toString()}');
    }
  }

  @override
  Future<List<StateModel>> getStates(String countryId) async {
    try {
      AppLogger.info(
        'CatalogsRemoteDataSource: Fetching states for country: $countryId',
      );

      final response = await client.get(
        Uri.parse('$baseUrl/v1/catalogs/countries/$countryId/states'),
        headers: {'Content-Type': 'application/json'},
      );

      AppLogger.debug(
        'CatalogsRemoteDataSource: States response - Status: ${response.statusCode}',
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        
        // Extract the 'docs' array from the paginated response
        final List<dynamic> docs = jsonResponse['docs'] ?? [];
        
        final states = docs
            .map((json) => StateModel.fromJson(json as Map<String, dynamic>))
            .toList();
        
        AppLogger.info(
          'CatalogsRemoteDataSource: Fetched ${states.length} states '
          '(Total: ${jsonResponse['totalDocs'] ?? states.length})',
        );
        return states;
      } else {
        String errorMessage = 'Failed to fetch states';
        try {
          final errorResponse =
              json.decode(response.body) as Map<String, dynamic>;
          errorMessage = _parseErrorMessage(
            errorResponse,
            'Failed to fetch states with status: ${response.statusCode}',
          );
        } catch (e) {
          errorMessage =
              'Failed to fetch states with status: ${response.statusCode}';
        }

        AppLogger.error(
          'CatalogsRemoteDataSource: Get states failed - ${response.statusCode}: $errorMessage',
        );
        throw ServerException(errorMessage);
      }
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
      throw ServerException('Failed to fetch states: ${e.toString()}');
    }
  }

  @override
  Future<List<CityModel>> getCities(String countryId, String stateId) async {
    try {
      AppLogger.info(
        'CatalogsRemoteDataSource: Fetching cities for state: $stateId',
      );

      final response = await client.get(
        Uri.parse(
          '$baseUrl/v1/catalogs/countries/$countryId/states/$stateId/cities',
        ),
        headers: {'Content-Type': 'application/json'},
      );

      AppLogger.debug(
        'CatalogsRemoteDataSource: Cities response - Status: ${response.statusCode}',
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        
        // Extract the 'docs' array from the paginated response
        final List<dynamic> docs = jsonResponse['docs'] ?? [];
        
        final cities = docs
            .map((json) => CityModel.fromJson(json as Map<String, dynamic>))
            .toList();
        
        AppLogger.info(
          'CatalogsRemoteDataSource: Fetched ${cities.length} cities '
          '(Total: ${jsonResponse['totalDocs'] ?? cities.length})',
        );
        return cities;
      } else {
        String errorMessage = 'Failed to fetch cities';
        try {
          final errorResponse =
              json.decode(response.body) as Map<String, dynamic>;
          errorMessage = _parseErrorMessage(
            errorResponse,
            'Failed to fetch cities with status: ${response.statusCode}',
          );
        } catch (e) {
          errorMessage =
              'Failed to fetch cities with status: ${response.statusCode}';
        }

        AppLogger.error(
          'CatalogsRemoteDataSource: Get cities failed - ${response.statusCode}: $errorMessage',
        );
        throw ServerException(errorMessage);
      }
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
      throw ServerException('Failed to fetch cities: ${e.toString()}');
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

      final response = await client.get(
        Uri.parse(
          '$baseUrl/v1/catalogs/countries/$countryId/states/$stateId/counties',
        ),
        headers: {'Content-Type': 'application/json'},
      );

      AppLogger.debug(
        'CatalogsRemoteDataSource: Counties response - Status: ${response.statusCode}',
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        
        // Extract the 'docs' array from the paginated response
        final List<dynamic> docs = jsonResponse['docs'] ?? [];
        
        final counties = docs
            .map((json) => CountyModel.fromJson(json as Map<String, dynamic>))
            .toList();
        
        AppLogger.info(
          'CatalogsRemoteDataSource: Fetched ${counties.length} counties '
          '(Total: ${jsonResponse['totalDocs'] ?? counties.length})',
        );
        return counties;
      } else {
        String errorMessage = 'Failed to fetch counties';
        try {
          final errorResponse =
              json.decode(response.body) as Map<String, dynamic>;
          errorMessage = _parseErrorMessage(
            errorResponse,
            'Failed to fetch counties with status: ${response.statusCode}',
          );
        } catch (e) {
          errorMessage =
              'Failed to fetch counties with status: ${response.statusCode}';
        }

        AppLogger.error(
          'CatalogsRemoteDataSource: Get counties failed - ${response.statusCode}: $errorMessage',
        );
        throw ServerException(errorMessage);
      }
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
      throw ServerException('Failed to fetch counties: ${e.toString()}');
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

      final response = await client.get(
        Uri.parse(
          '$baseUrl/v1/catalogs/countries/$countryId/states/$stateId/settlements',
        ),
        headers: {'Content-Type': 'application/json'},
      );

      AppLogger.debug(
        'CatalogsRemoteDataSource: Settlements response - Status: ${response.statusCode}',
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        
        // Extract the 'docs' array from the paginated response
        final List<dynamic> docs = jsonResponse['docs'] ?? [];
        
        final settlements = docs
            .map((json) =>
                SettlementModel.fromJson(json as Map<String, dynamic>))
            .toList();
        
        AppLogger.info(
          'CatalogsRemoteDataSource: Fetched ${settlements.length} settlements '
          '(Total: ${jsonResponse['totalDocs'] ?? settlements.length})',
        );
        return settlements;
      } else {
        String errorMessage = 'Failed to fetch settlements';
        try {
          final errorResponse =
              json.decode(response.body) as Map<String, dynamic>;
          errorMessage = _parseErrorMessage(
            errorResponse,
            'Failed to fetch settlements with status: ${response.statusCode}',
          );
        } catch (e) {
          errorMessage =
              'Failed to fetch settlements with status: ${response.statusCode}';
        }

        AppLogger.error(
          'CatalogsRemoteDataSource: Get settlements failed - ${response.statusCode}: $errorMessage',
        );
        throw ServerException(errorMessage);
      }
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
      throw ServerException('Failed to fetch settlements: ${e.toString()}');
    }
  }

  @override
  Future<List<EconomicActivityModel>> getEconomicActivities() async {
    try {
      AppLogger.info(
        'CatalogsRemoteDataSource: Fetching economic activities',
      );

      final response = await client.get(
        Uri.parse('$baseUrl/v1/catalogs/economic-activities'),
        headers: {'Content-Type': 'application/json'},
      );

      AppLogger.debug(
        'CatalogsRemoteDataSource: Economic activities response - Status: ${response.statusCode}',
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        
        // Extract the 'docs' array from the paginated response
        final List<dynamic> docs = jsonResponse['docs'] ?? [];
        
        final activities = docs
            .map((json) =>
                EconomicActivityModel.fromJson(json as Map<String, dynamic>))
            .toList();
        
        AppLogger.info(
          'CatalogsRemoteDataSource: Fetched ${activities.length} economic activities '
          '(Total: ${jsonResponse['totalDocs'] ?? activities.length})',
        );
        return activities;
      } else {
        String errorMessage = 'Failed to fetch economic activities';
        try {
          final errorResponse =
              json.decode(response.body) as Map<String, dynamic>;
          errorMessage = _parseErrorMessage(
            errorResponse,
            'Failed to fetch economic activities with status: ${response.statusCode}',
          );
        } catch (e) {
          errorMessage =
              'Failed to fetch economic activities with status: ${response.statusCode}';
        }

        AppLogger.error(
          'CatalogsRemoteDataSource: Get economic activities failed - ${response.statusCode}: $errorMessage',
        );
        throw ServerException(errorMessage);
      }
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
      );
    }
  }

  @override
  Future<List<PurposeModel>> getPurposes(String category) async {
    try {
      AppLogger.info(
        'CatalogsRemoteDataSource: Fetching purposes for category: $category',
      );

      final response = await client.get(
        Uri.parse('$baseUrl/v1/catalogs/purposes/$category'),
        headers: {'Content-Type': 'application/json'},
      );

      AppLogger.debug(
        'CatalogsRemoteDataSource: Purposes response - Status: ${response.statusCode}',
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        
        // Extract the 'docs' array from the paginated response
        final List<dynamic> docs = jsonResponse['docs'] ?? [];
        
        final purposes = docs
            .map((json) => PurposeModel.fromJson(json as Map<String, dynamic>))
            .toList();
        
        AppLogger.info(
          'CatalogsRemoteDataSource: Fetched ${purposes.length} purposes '
          '(Total: ${jsonResponse['totalDocs'] ?? purposes.length})',
        );
        return purposes;
      } else {
        String errorMessage = 'Failed to fetch purposes';
        try {
          final errorResponse =
              json.decode(response.body) as Map<String, dynamic>;
          errorMessage = _parseErrorMessage(
            errorResponse,
            'Failed to fetch purposes with status: ${response.statusCode}',
          );
        } catch (e) {
          errorMessage =
              'Failed to fetch purposes with status: ${response.statusCode}';
        }

        AppLogger.error(
          'CatalogsRemoteDataSource: Get purposes failed - ${response.statusCode}: $errorMessage',
        );
        throw ServerException(errorMessage);
      }
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
      throw ServerException('Failed to fetch purposes: ${e.toString()}');
    }
  }
}
