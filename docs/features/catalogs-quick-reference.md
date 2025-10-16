# Catalogs API - Quick Reference

## All Endpoints Return Paginated Responses

```json
{
  "docs": [...],        // Array of items
  "totalDocs": 250,
  "limit": 250,
  "page": 1,
  "pages": 1
}
```

## Entity Fields Reference

| Entity | Fields | Identifier |
|--------|--------|------------|
| **Country** | name, code, phoneCode | `code` ("MX", "US") |
| **State** | name, code, countryCode | `code` ("AGU", "YUC") |
| **City** | name, code, countyCode, stateCode, countryCode | `code` ("01", "07") |
| **County** | name, code, stateCode, countryCode | `code` ("050") |
| **Settlement** | name, code, countyCode, stateCode, countryCode | `code` ("0001") |
| **EconomicActivity** | name, code | `code` ("0111013") |
| **Purpose** | name, code | `code` ("salary") |

## Quick Usage Examples

### Get Countries
```dart
final result = await sl<GetCountries>()(NoParams());
// Access: country.code, country.name, country.phoneCode
```

### Get States for a Country
```dart
final result = await sl<GetStates>()(
  GetStatesParams(countryId: 'MX'), // Use country code
);
// Access: state.code, state.name, state.countryCode
```

### Get Cities
```dart
final result = await sl<GetCities>()(
  GetCitiesParams(
    countryId: 'MX',   // Country code
    stateId: 'YUC',    // State code
  ),
);
// Access: city.code, city.name, city.countyCode, city.stateCode, city.countryCode
```

### Get Counties
```dart
final result = await sl<GetCounties>()(
  GetCountiesParams(
    countryId: 'MX',
    stateId: 'YUC',
  ),
);
```

### Get Settlements
```dart
final result = await sl<GetSettlements>()(
  GetSettlementsParams(
    countryId: 'MX',
    stateId: 'YUC',
  ),
);
```

### Get Economic Activities
```dart
final result = await sl<GetEconomicActivities>()(NoParams());
// Access: activity.code, activity.name
```

### Get Purposes (origin or destination)
```dart
// For origin purposes
final result = await sl<GetPurposes>()(
  GetPurposesParams(category: 'origin'),
);

// For destination purposes
final result = await sl<GetPurposes>()(
  GetPurposesParams(category: 'destination'),
);
// Access: purpose.code, purpose.name
```

## Important Notes

- ✅ Use **codes** (not IDs) for all relationships
- ✅ Country code examples: "MX", "US", "AF"
- ✅ State code examples: "AGU", "YUC", "CAL"
- ✅ Purpose category: Only **'origin'** or **'destination'**
- ❌ No `id` fields exist in any entity
- ✅ Cities, counties, and settlements include all parent codes

## Error Handling Pattern

```dart
final result = await getCountries(NoParams());

result.fold(
  (failure) {
    // Handle error
    print('Error: ${failure.message}');
  },
  (countries) {
    // Handle success
    for (final country in countries) {
      print('${country.name}: ${country.code}');
    }
  },
);
```

## Hierarchical Navigation Example

```dart
// 1. Get country
final countries = await getCountries(NoParams());
final mexico = countries.first; // mexico.code = "MX"

// 2. Get states for country
final states = await getStates(
  GetStatesParams(countryId: mexico.code),
);
final yucatan = states.first; // yucatan.code = "YUC"

// 3. Get cities for state
final cities = await getCities(
  GetCitiesParams(
    countryId: mexico.code,
    stateId: yucatan.code,
  ),
);
```

## Service Locator Access

All use cases are registered and accessible via:
```dart
import 'package:confetti_app/config/service_locator.dart';

final getCountries = sl<GetCountries>();
final getStates = sl<GetStates>();
final getCities = sl<GetCities>();
final getCounties = sl<GetCounties>();
final getSettlements = sl<GetSettlements>();
final getEconomicActivities = sl<GetEconomicActivities>();
final getPurposes = sl<GetPurposes>();
```

## UI Components

### AppCountryDropdown Widget

A ready-to-use dropdown widget for country selection with flags.

**Location**: `lib/features/auth/presentation/widgets/app_country_dropdown.dart`

**Basic Usage**:
```dart
import 'package:confetti_app/features/auth/presentation/widgets/app_country_dropdown.dart';

AppCountryDropdown(
  labelText: 'Select Country',
  onChanged: (Country? country) {
    if (country != null) {
      print('Selected: ${country.name} (+${country.phoneCode})');
    }
  },
)
```

**With Form Validation**:
```dart
Country? _selectedCountry;

AppCountryDropdown(
  labelText: 'Country',
  onChanged: (Country? country) {
    setState(() {
      _selectedCountry = country;
    });
  },
  validator: (Country? value) {
    if (value == null) {
      return 'Please select a country';
    }
    return null;
  },
)
```

**Features**:
- ✅ Fetches countries from API automatically
- ✅ Shows country flags using circle_flags library
- ✅ Displays phone codes in dropdown
- ✅ MX (Mexico) selected by default
- ✅ Loading and error states handled
- ✅ Form validation support
- ✅ Theme-aware styling

**Properties**:
- `labelText` - Label for the dropdown (default: "Country")
- `errorText` - Error text to display
- `onChanged` - Callback when selection changes
- `initialCountry` - Initial country (overrides default MX)
- `validator` - Form field validator

