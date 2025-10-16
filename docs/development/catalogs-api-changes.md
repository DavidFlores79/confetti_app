# Catalogs API Changes - Complete Update for All Endpoints

## Overview
All catalog endpoints have been updated to match the actual API response structure. All responses follow a **paginated format** with a `docs` array containing the actual data.

## Common Changes Across All Endpoints

### Paginated Response Structure
All endpoints now return:
```json
{
  "docs": [...],      // Array of items
  "totalDocs": 250,
  "limit": 250,
  "page": 1,
  "pages": 1,
  "hasPrevPage": false,
  "hasNextPage": false
}
```

### ID Removal
- ❌ Removed all `id` fields from entities
- ✅ Using `code` fields as identifiers
- ✅ Added appropriate relationship codes (countryCode, stateCode, etc.)

---

## Detailed Changes by Entity

### 1. Country Entity

**Fields Changed:**
- ❌ Removed: `id`
- ✅ Changed: `code` is now the identifier (e.g., "MX", "US", "AF")
- ✅ Added: `phoneCode` (e.g., "52", "1", "93")

**API Response:**
```json
{
  "docs": [
    {
      "name": "Mexico",
      "code": "MX",
      "phoneCode": "52"
    }
  ],
  "totalDocs": 250,
  "limit": 250
}
```

---

### 2. State Entity

**Fields Changed:**
- ❌ Removed: `id`, `countryId`
- ✅ Kept: `name`, `code`
- ✅ Added: `countryCode` (e.g., "MX")

**API Response:**
```json
{
  "docs": [
    {
      "name": "Aguascalientes",
      "code": "AGU",
      "countryCode": "MX"
    }
  ],
  "totalDocs": 32
}
```

**Usage:**
```dart
// Use country code
await getStates(GetStatesParams(countryId: 'MX'));

// Access state code
state.code // "AGU"
state.countryCode // "MX"
```

---

### 3. City Entity

**Fields Changed:**
- ❌ Removed: `id`, `stateId`
- ✅ Added: `code`, `countyCode`, `stateCode`, `countryCode`

**API Response:**
```json
{
  "docs": [
    {
      "name": "Mérida",
      "code": "01",
      "countyCode": "050",
      "stateCode": "YUC",
      "countryCode": "MX"
    }
  ],
  "totalDocs": 962
}
```

**Usage:**
```dart
await getCities(GetCitiesParams(
  countryId: 'MX',
  stateId: 'YUC',
));
```

---

### 4. County Entity

**Fields Changed:**
- ❌ Removed: `id`, `stateId`
- ✅ Added: `code`, `stateCode`, `countryCode`

**API Response:**
```json
{
  "docs": [
    {
      "name": "Mérida",
      "code": "050",
      "stateCode": "YUC",
      "countryCode": "MX"
    }
  ],
  "totalDocs": 106
}
```

---

### 5. Settlement Entity

**Fields Changed:**
- ❌ Removed: `id`, `stateId`, `postalCode`
- ✅ Added: `code`, `countyCode`, `stateCode`, `countryCode`

**API Response:**
```json
{
  "docs": [
    {
      "name": "Mérida Centro",
      "code": "0001",
      "countyCode": "050",
      "stateCode": "YUC",
      "countryCode": "MX"
    }
  ],
  "totalDocs": 1641
}
```

---

### 6. Economic Activity Entity

**Fields Changed:**
- ❌ Removed: `id`, `description`
- ✅ Kept: `name`, `code`

**API Response:**
```json
{
  "docs": [
    {
      "name": "CULTIVO DE ALPISTE",
      "code": "0111013"
    }
  ],
  "totalDocs": 1257
}
```

---

### 7. Purpose Entity

**Fields Changed:**
- ❌ Removed: `id`, `category`, `description`
- ✅ Kept: `name`, `code`

**API Response:**
```json
{
  "docs": [
    {
      "name": "SALARIO",
      "code": "salary"
    }
  ],
  "totalDocs": 7
}
```

**Important:** Category is only used as a URL parameter. Valid values: `'origin'` or `'destination'`

**Usage:**
```dart
// Get purposes for origin category
await getPurposes(GetPurposesParams(category: 'origin'));

// Get purposes for destination category
await getPurposes(GetPurposesParams(category: 'destination'));
```

---

## Complete API Endpoint Reference

| Endpoint | Response Format | Key Fields |
|----------|----------------|------------|
| `/v1/catalogs/countries` | Paginated | name, code, phoneCode |
| `/v1/catalogs/countries/{code}/states` | Paginated | name, code, countryCode |
| `/v1/catalogs/countries/{code}/states/{code}/cities` | Paginated | name, code, countyCode, stateCode, countryCode |
| `/v1/catalogs/countries/{code}/states/{code}/counties` | Paginated | name, code, stateCode, countryCode |
| `/v1/catalogs/countries/{code}/states/{code}/settlements` | Paginated | name, code, countyCode, stateCode, countryCode |
| `/v1/catalogs/economic-activities` | Paginated | name, code |
| `/v1/catalogs/purposes/{category}` | Paginated | name, code |

---

## Migration Guide

### Before (Old Structure)
```dart
// Old way - using IDs
final countryId = country.id;
final stateId = state.id;

await getCities(GetCitiesParams(
  countryId: countryId,
  stateId: stateId,
));
```

### After (New Structure)
```dart
// New way - using codes
final countryCode = country.code; // "MX"
final stateCode = state.code;     // "YUC"

await getCities(GetCitiesParams(
  countryId: countryCode,  // Use country code
  stateId: stateCode,       // Use state code
));
```

---

## Updated Usage Examples

### Hierarchical Navigation Flow
```dart
// 1. Get countries
final countries = await getCountries(NoParams());
final mexico = countries.firstWhere((c) => c.code == 'MX');

// 2. Get states for Mexico
final states = await getStates(GetStatesParams(countryId: mexico.code));
final yucatan = states.firstWhere((s) => s.code == 'YUC');

// 3. Get cities in Yucatan
final cities = await getCities(GetCitiesParams(
  countryId: mexico.code,    // "MX"
  stateId: yucatan.code,     // "YUC"
));

// 4. Get counties in Yucatan
final counties = await getCounties(GetCountiesParams(
  countryId: mexico.code,
  stateId: yucatan.code,
));

// 5. Get settlements in Yucatan
final settlements = await getSettlements(GetSettlementsParams(
  countryId: mexico.code,
  stateId: yucatan.code,
));
```

### Business Catalogs
```dart
// Get economic activities
final activities = await getEconomicActivities(NoParams());
for (final activity in activities) {
  print('${activity.name}: ${activity.code}');
}

// Get purposes by category
final originPurposes = await getPurposes(
  GetPurposesParams(category: 'origin')
);
final destinationPurposes = await getPurposes(
  GetPurposesParams(category: 'destination')
);
```

---

## Files Modified

**Domain Entities:**
1. `lib/features/catalogs/domain/entities/country.dart`
2. `lib/features/catalogs/domain/entities/state.dart`
3. `lib/features/catalogs/domain/entities/city.dart`
4. `lib/features/catalogs/domain/entities/county.dart`
5. `lib/features/catalogs/domain/entities/settlement.dart`
6. `lib/features/catalogs/domain/entities/economic_activity.dart`
7. `lib/features/catalogs/domain/entities/purpose.dart`

**Data Models:**
1. `lib/features/catalogs/data/models/country_model.dart`
2. `lib/features/catalogs/data/models/state_model.dart`
3. `lib/features/catalogs/data/models/city_model.dart`
4. `lib/features/catalogs/data/models/county_model.dart`
5. `lib/features/catalogs/data/models/settlement_model.dart`
6. `lib/features/catalogs/data/models/economic_activity_model.dart`
7. `lib/features/catalogs/data/models/purpose_model.dart`

**Data Source:**
8. `lib/features/catalogs/data/datasources/catalogs_remote_datasource.dart` (All 7 methods updated)

**Documentation & Examples:**
9. `lib/features/catalogs/catalogs_usage_example.dart`
10. `CATALOGS_FEATURE.md`
11. `CATALOGS_API_CHANGES.md`

---

## Testing Status

✅ **All changes validated:**
- Flutter analyze: No errors
- JSON parsing tested with sample API responses
- All dependencies properly registered
- Documentation fully updated
- Usage examples reflect new structure

---

## Breaking Changes Summary

⚠️ **All entities have breaking changes:**

1. **No more `id` fields** - Use `code` fields instead
2. **Relationship fields renamed** - `countryId` → `countryCode`, etc.
3. **Added hierarchical codes** - Cities, counties, and settlements now include all parent codes
4. **Purpose category removed from entity** - Now only used as URL parameter
5. **Settlement postalCode removed** - Not in API response

**Action Required:** Update all code that references old field names.
