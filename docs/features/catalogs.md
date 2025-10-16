# Catalogs Feature

## Overview
The Catalogs feature provides API integration to fetch various catalog data from the backend, including geographical locations (countries, states, cities, counties, settlements) and business-related catalogs (economic activities, purposes).

## Architecture
This feature follows Clean Architecture principles with three layers:

### Domain Layer
- **Entities**: Pure Dart classes representing business objects
  - `Country`: Country information (name, code, phoneCode)
  - `StateEntity`: State/Province information (id, name, code, countryId)
  - `City`: City information (id, name, stateId)
  - `County`: County/Municipality information (id, name, stateId)
  - `Settlement`: Settlement/Colony information (id, name, stateId, postalCode)
  - `EconomicActivity`: Economic activity catalog (id, name, code, description)
  - `Purpose`: Purpose catalog (id, name, category, description)

- **Repositories**: Abstract interfaces defining data operations
  - `CatalogsRepository`: Interface for all catalog operations

- **Use Cases**: Business logic for each catalog operation
  - `GetCountries`: Fetch list of countries
  - `GetStates`: Fetch states for a specific country
  - `GetCities`: Fetch cities for a specific state
  - `GetCounties`: Fetch counties for a specific state
  - `GetSettlements`: Fetch settlements for a specific state
  - `GetEconomicActivities`: Fetch economic activities catalog
  - `GetPurposes`: Fetch purposes for a specific category

### Data Layer
- **Models**: Data models that extend domain entities with JSON serialization
  - `CountryModel`
  - `StateModel`
  - `CityModel`
  - `CountyModel`
  - `SettlementModel`
  - `EconomicActivityModel`
  - `PurposeModel`

- **Data Sources**: API communication implementation
  - `CatalogsRemoteDataSource`: HTTP client for API calls

- **Repositories**: Implementation of domain repository interfaces
  - `CatalogsRepositoryImpl`: Implements `CatalogsRepository`

## API Endpoints

### Geographic Catalogs
- `GET /v1/catalogs/countries` - Get all countries (paginated response with `docs` array)
- `GET /v1/catalogs/countries/{countryId}/states` - Get states for a country
- `GET /v1/catalogs/countries/{countryId}/states/{stateId}/cities` - Get cities for a state
- `GET /v1/catalogs/countries/{countryId}/states/{stateId}/counties` - Get counties for a state
- `GET /v1/catalogs/countries/{countryId}/states/{stateId}/settlements` - Get settlements for a state

**Note:** The countries endpoint returns a paginated response:
```json
{
  "docs": [
    {
      "name": "Afghanistan",
      "code": "AF",
      "phoneCode": "93"
    }
  ],
  "totalDocs": 250,
  "limit": 250,
  "page": 1,
  "pages": 1,
  "hasPrevPage": false,
  "hasNextPage": false
}
```
The `code` field (e.g., "MX", "US", "AF") is used as the country identifier in subsequent API calls.

### Business Catalogs
- `GET /v1/catalogs/economic-activities` - Get all economic activities
- `GET /v1/catalogs/purposes/{category}` - Get purposes by category

## Usage Example

### 1. Inject Use Cases
Use cases are registered in the service locator and can be injected via dependency injection:

```dart
import 'package:confetti_app/config/service_locator.dart';
import 'package:confetti_app/features/catalogs/domain/usecases/get_countries.dart';
import 'package:confetti_app/core/usecases/usecase.dart';

// Get the use case from service locator
final getCountries = sl<GetCountries>();

// Call the use case
final result = await getCountries(NoParams());

result.fold(
  (failure) => print('Error: ${failure.message}'),
  (countries) {
    print('Loaded ${countries.length} countries');
    // Countries have: name, code, phoneCode
    for (final country in countries) {
      print('${country.name} (${country.code}) - ${country.phoneCode}');
    }
  },
);
```

### 2. Using with Parameters
For use cases that require parameters (use country.code as countryId):

```dart
import 'package:confetti_app/features/catalogs/domain/usecases/get_states.dart';

final getStates = sl<GetStates>();

// Note: Use the country code (e.g., 'MX', 'US') as countryId
final result = await getStates(
  GetStatesParams(countryId: 'MX'), // Use country code
);

result.fold(
  (failure) => print('Error: ${failure.message}'),
  (states) => print('Loaded ${states.length} states'),
);
```

### 3. Getting Cities
```dart
import 'package:confetti_app/features/catalogs/domain/usecases/get_cities.dart';

final getCities = sl<GetCities>();

// Note: countryId should be the country code (e.g., 'MX')
final result = await getCities(
  GetCitiesParams(
    countryId: 'MX', // Use country code
    stateId: 'state-id',
  ),
);

result.fold(
  (failure) => print('Error: ${failure.message}'),
  (cities) => print('Loaded ${cities.length} cities'),
);
```

### 4. Getting Economic Activities
```dart
import 'package:confetti_app/features/catalogs/domain/usecases/get_economic_activities.dart';
import 'package:confetti_app/core/usecases/usecase.dart';

final getEconomicActivities = sl<GetEconomicActivities>();

final result = await getEconomicActivities(NoParams());

result.fold(
  (failure) => print('Error: ${failure.message}'),
  (activities) => print('Loaded ${activities.length} activities'),
);
```

### 5. Getting Purposes by Category
```dart
import 'package:confetti_app/features/catalogs/domain/usecases/get_purposes.dart';

final getPurposes = sl<GetPurposes>();

final result = await getPurposes(
  GetPurposesParams(category: 'loan'),
);

result.fold(
  (failure) => print('Error: ${failure.message}'),
  (purposes) => print('Loaded ${purposes.length} purposes'),
);
```

## Error Handling
All use cases return `Either<Failure, Result>` using the `dartz` package:
- **Left**: Contains a `Failure` object with error message
- **Right**: Contains the successful result

Common failure types:
- `ServerFailure`: API errors or network issues
- Error messages are parsed from the API response

## Logging
All operations are logged using `AppLogger`:
- Info logs for successful operations
- Debug logs for request/response details
- Error logs for failures with stack traces

## Dependencies
The catalogs feature is registered in the service locator (`lib/config/service_locator.dart`) with all necessary dependencies:
- Remote data source
- Repository implementation
- All use cases

## Configuration
Base URL is configured in `CatalogsRemoteDataSourceImpl`:
```dart
static const String baseUrl = 'http://192.168.0.176:3000';
```

Update this value to match your API server address.

## Testing
To test the feature:
1. Ensure the API server is running and accessible
2. Use the use cases in your presentation layer (BLoC/Cubit)
3. Check logs for detailed request/response information

## Future Enhancements
Potential improvements:
- Add local caching for catalog data
- Implement pagination for large datasets
- Add search/filter capabilities
- Create presentation layer (BLoC/Cubit) for state management
- Add UI components for catalog selection
