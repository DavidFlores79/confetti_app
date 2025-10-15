// Example usage of the Catalogs feature
// This file demonstrates how to use the catalog use cases in your application

import '../../config/service_locator.dart';
import '../../core/usecases/usecase.dart';
import 'domain/usecases/get_cities.dart';
import 'domain/usecases/get_countries.dart';
import 'domain/usecases/get_counties.dart';
import 'domain/usecases/get_economic_activities.dart';
import 'domain/usecases/get_purposes.dart';
import 'domain/usecases/get_settlements.dart';
import 'domain/usecases/get_states.dart';

class CatalogsUsageExample {
  /// Example: Get all countries
  Future<void> fetchCountries() async {
    final getCountries = sl<GetCountries>();

    final result = await getCountries(NoParams());

    result.fold(
      (failure) {
        print('Error fetching countries: ${failure.message}');
      },
      (countries) {
        print('Successfully fetched ${countries.length} countries');
        for (final country in countries) {
          print(
            'Country: ${country.name} (${country.code}) - Phone: ${country.phoneCode}',
          );
        }
      },
    );
  }

  /// Example: Get states for a specific country
  Future<void> fetchStates(String countryId) async {
    final getStates = sl<GetStates>();

    final result = await getStates(GetStatesParams(countryId: countryId));

    result.fold(
      (failure) {
        print('Error fetching states: ${failure.message}');
      },
      (states) {
        print('Successfully fetched ${states.length} states');
        for (final state in states) {
          print('State: ${state.name} (${state.code})');
        }
      },
    );
  }

  /// Example: Get cities for a specific state
  Future<void> fetchCities(String countryId, String stateId) async {
    final getCities = sl<GetCities>();

    final result = await getCities(
      GetCitiesParams(countryId: countryId, stateId: stateId),
    );

    result.fold(
      (failure) {
        print('Error fetching cities: ${failure.message}');
      },
      (cities) {
        print('Successfully fetched ${cities.length} cities');
        for (final city in cities) {
          print('City: ${city.name} (${city.code})');
        }
      },
    );
  }

  /// Example: Get counties for a specific state
  Future<void> fetchCounties(String countryId, String stateId) async {
    final getCounties = sl<GetCounties>();

    final result = await getCounties(
      GetCountiesParams(countryId: countryId, stateId: stateId),
    );

    result.fold(
      (failure) {
        print('Error fetching counties: ${failure.message}');
      },
      (counties) {
        print('Successfully fetched ${counties.length} counties');
        for (final county in counties) {
          print('County: ${county.name} (${county.code})');
        }
      },
    );
  }

  /// Example: Get settlements for a specific state
  Future<void> fetchSettlements(String countryId, String stateId) async {
    final getSettlements = sl<GetSettlements>();

    final result = await getSettlements(
      GetSettlementsParams(countryId: countryId, stateId: stateId),
    );

    result.fold(
      (failure) {
        print('Error fetching settlements: ${failure.message}');
      },
      (settlements) {
        print('Successfully fetched ${settlements.length} settlements');
        for (final settlement in settlements) {
          print('Settlement: ${settlement.name} (${settlement.code})');
        }
      },
    );
  }

  /// Example: Get all economic activities
  Future<void> fetchEconomicActivities() async {
    final getEconomicActivities = sl<GetEconomicActivities>();

    final result = await getEconomicActivities(NoParams());

    result.fold(
      (failure) {
        print('Error fetching economic activities: ${failure.message}');
      },
      (activities) {
        print('Successfully fetched ${activities.length} economic activities');
        for (final activity in activities) {
          print('Activity: ${activity.name} (${activity.code})');
        }
      },
    );
  }

  /// Example: Get purposes for a specific category
  Future<void> fetchPurposes(String category) async {
    final getPurposes = sl<GetPurposes>();

    final result = await getPurposes(GetPurposesParams(category: category));

    result.fold(
      (failure) {
        print('Error fetching purposes: ${failure.message}');
      },
      (purposes) {
        print('Successfully fetched ${purposes.length} purposes');
        for (final purpose in purposes) {
          print('Purpose: ${purpose.name} (Code: ${purpose.code})');
        }
      },
    );
  }

  /// Example: Complete flow - fetch country, then states, then cities
  Future<void> completeGeographicFlow() async {
    // 1. Get all countries
    final getCountries = sl<GetCountries>();
    final countriesResult = await getCountries(NoParams());

    await countriesResult.fold(
      (failure) async {
        print('Error: ${failure.message}');
      },
      (countries) async {
        if (countries.isEmpty) {
          print('No countries found');
          return;
        }

        // Use first country as example
        final country = countries.first;
        print('Using country: ${country.name}');

        // 2. Get states for this country
        final getStates = sl<GetStates>();
        final statesResult = await getStates(
          GetStatesParams(countryId: country.code),
        );

        await statesResult.fold(
          (failure) async {
            print('Error: ${failure.message}');
          },
          (states) async {
            if (states.isEmpty) {
              print('No states found');
              return;
            }

            // Use first state as example
            final state = states.first;
            print('Using state: ${state.name}');

            // 3. Get cities for this state
            final getCities = sl<GetCities>();
            final citiesResult = await getCities(
              GetCitiesParams(countryId: country.code, stateId: state.code),
            );

            citiesResult.fold(
              (failure) {
                print('Error: ${failure.message}');
              },
              (cities) {
                print('Found ${cities.length} cities in ${state.name}');
              },
            );
          },
        );
      },
    );
  }
}
