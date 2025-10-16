# Authentication Feature Documentation

## Overview
This authentication feature has been implemented following **Clean Architecture** and **SOLID principles** with Flutter BLoC for state management, GoRouter for navigation, and GetIt for dependency injection. The authentication uses **phone number and password** credentials.

## API Integration

### Login Response Structure
The authentication system is designed to work with the following API response format:

```json
{
    "user": {
        "id": "e7393ea9-8540-4d3f-8c14-b72016755e67",
        "firstName": null,
        "middleName": null,
        "lastName": null,
        "secondLastName": null,
        "fullName": "",
        "displayName": null,
        "email": null,
        "phone": "+529991992696",
        "gender": null,
        "group": "client_user",
        "rfc": null,
        "curp": null,
        "birthDate": null,
        "nationality": null,
        "countryOfBirth": null,
        "stateOfBirth": null,
        "riskLevel": "low",
        "profileCompleted": false,
        "status": "validated",
        "verified": true,
        "createdAt": "2025-10-06T22:00:00.012Z",
        "updatedAt": "2025-10-06T22:34:07.722Z"
    },
    "kid": "de632d78-3084-4e31-b99d-b39dc25cc910",
    "jwt": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

The system properly handles:
- User data with all Mexican-specific fields (RFC, CURP, etc.)
- JWT access token for API authentication
- Refresh token for token renewal
- Key ID (kid) for token verification

## Architecture

The feature follows a three-layer clean architecture:

### 1. **Domain Layer** (Business Logic)
- **Entities**: Pure Dart classes representing core business objects
  - `User`: Comprehensive user entity with all profile fields including Mexican-specific data
  
- **Repository Interfaces**: Abstract contracts for data operations
  - `AuthRepository`: Defines authentication operations (login, register, logout, token management)

- **Use Cases**: Single-responsibility business logic operations
  - `Login`: Handles user login with phone/password
  - `Logout`: Handles user logout and token cleanup
  - `GetCurrentUser`: Retrieves cached user
  - `CheckAuthStatus`: Checks if user is logged in

### 2. **Data Layer** (Data Management)
- **Models**: Data transfer objects that extend domain entities
  - `UserModel`: Extends User entity with JSON serialization for all API fields
  - `LoginResponseModel`: Handles complete API response with user, tokens, and kid

- **Data Sources**:
  - `AuthRemoteDataSource`: Handles API calls (includes mock implementation)
  - `AuthLocalDataSource`: Handles SharedPreferences operations including token storage

- **Repository Implementation**:
  - `AuthRepositoryImpl`: Implements AuthRepository interface with proper token management

### 3. **Presentation Layer** (UI)
- **BLoC**: State management using flutter_bloc
  - `AuthBloc`: Manages authentication state
  - `AuthEvent`: Authentication events (login with phone)
  - `AuthState`: Authentication states

- **Pages**:
  - `SplashPage`: Initial loading screen with auth check
  - `LoginPage`: Phone-based login form with validation

## Dependencies

```yaml
# State Management
flutter_bloc: ^8.1.3

# Dependency Injection
get_it: ^7.6.4

# Routing
go_router: ^13.0.0

# Local Storage
shared_preferences: ^2.2.2

# HTTP Client
http: ^1.2.0

# Functional Programming
dartz: ^0.10.1
```

## Project Structure

```
lib/
├── config/
│   ├── router.dart                      # GoRouter configuration
│   └── service_locator.dart             # GetIt dependency injection setup
├── core/
│   ├── error/
│   │   ├── exceptions.dart              # Exception classes
│   │   └── failures.dart                # Failure classes
│   ├── network/
│   │   └── network_info.dart            # Network connectivity check
│   └── usecases/
│       └── usecase.dart                 # Base use case class
├── features/
│   └── auth/
│       ├── data/
│       │   ├── datasources/
│       │   │   ├── auth_local_datasource.dart    # Token & user caching
│       │   │   └── auth_remote_datasource.dart   # API integration
│       │   ├── models/
│       │   │   ├── user_model.dart               # User data model
│       │   │   └── login_response_model.dart     # Login API response model
│       │   └── repositories/
│       │       └── auth_repository_impl.dart
│       ├── domain/
│       │   ├── entities/
│       │   │   └── user.dart                     # Complete user entity
│       │   ├── repositories/
│       │   │   └── auth_repository.dart
│       │   └── usecases/
│       │       ├── check_auth_status.dart
│       │       ├── get_current_user.dart
│       │       ├── login.dart                     # Phone-based login
│       │       └── logout.dart
│       └── presentation/
│           ├── bloc/
│           │   ├── auth_bloc.dart
│           │   ├── auth_event.dart
│           │   └── auth_state.dart
│           └── pages/
│               ├── login_page.dart                # Phone input UI
│               └── splash_page.dart
└── main.dart
```

## SOLID Principles Implementation

### Single Responsibility Principle (SRP)
- Each use case has one specific responsibility
- Data sources are separated (remote vs local)
- BLoC handles only state management

### Open/Closed Principle (OCP)
- Repository interfaces allow extending without modifying
- Use cases can be added without changing existing code

### Liskov Substitution Principle (LSP)
- Models extend entities and can be used interchangeably
- Repository implementation substitutes interface

### Interface Segregation Principle (ISP)
- Small, focused interfaces (AuthRepository)
- Separate data source interfaces

### Dependency Inversion Principle (DIP)
- High-level modules depend on abstractions
- Use cases depend on repository interfaces, not implementations
- GetIt manages all dependencies

## Features

### Authentication Flow
1. **App Launch**: 
   - Displays splash screen
   - Checks authentication status and token validity
   - Redirects to login or home based on status

2. **Login**:
   - Phone number validation (must start with country code, e.g., +52)
   - Password validation (minimum 6 characters)
   - Form validation with user feedback
   - Async login with loading state
   - Error handling with user-friendly messages
   - Automatic navigation on success
   - Complete data caching (user profile + JWT + refresh token + kid)

3. **Token Management**:
   - JWT access token stored securely
   - Refresh token for session renewal
   - Key ID (kid) stored for token verification
   - All tokens cleared on logout

4. **Logout**:
   - Clear cached user data
   - Clear all authentication tokens
   - Navigate back to login screen

### State Management with BLoC
- **Events**: User actions trigger events (phone-based login)
- **States**: UI reflects current authentication state
- **No Equatable**: States comparison handled manually

### Navigation with GoRouter
- Declarative routing
- Deep linking support ready
- Protected routes based on auth state

### Dependency Injection with GetIt
- Centralized dependency management
- Lazy singleton pattern for services
- Factory pattern for BLoC instances

## How to Use

### 1. Initialize Dependencies
Dependencies are automatically initialized in `main.dart`:
```dart
await initializeDependencies();
```

### 2. Login
Enter a phone number with country code (e.g., +529991234567) and password (minimum 6 characters). The mock implementation will accept any valid credentials.

### 3. Logout
Click the logout icon in the app bar on the home screen.

## Testing Credentials
Since this uses a mock implementation, you can use any valid phone format and password:
- Phone: +529991234567 (must include country code)
- Password: password123 (minimum 6 characters)

## User Profile Fields

The User entity includes comprehensive profile information:
- **Basic Info**: firstName, middleName, lastName, secondLastName, fullName, displayName
- **Contact**: email, phone
- **Identity**: gender, rfc, curp, birthDate, nationality
- **Location**: countryOfBirth, stateOfBirth
- **Status**: group, riskLevel, profileCompleted, status, verified
- **Timestamps**: createdAt, updatedAt

All fields are properly serialized/deserialized for API and local storage.

## Customization

### Connecting to Real API
1. Update `AuthRemoteDataSourceImpl` in `auth_remote_datasource.dart`
2. Uncomment the HTTP client code
3. Update `baseUrl` with your API endpoint
4. The models are already configured to match your API response structure
5. Example integration:
```dart
final response = await client.post(
  Uri.parse('$baseUrl/auth/login'),
  headers: {'Content-Type': 'application/json'},
  body: json.encode({
    'phone': phone,
    'password': password,
  }),
);

if (response.statusCode == 200) {
  final jsonResponse = json.decode(response.body);
  return LoginResponseModel.fromJson(jsonResponse);
}
```

### Adding Registration
The foundation is already in place:
1. Use case already exists: `domain/usecases/register.dart` (needs to be created)
2. Repository method exists: `AuthRepository.register()`
3. Add registration event and state to BLoC
4. Create registration page UI

## Error Handling
- **ServerFailure**: API/remote errors
- **CacheFailure**: Local storage errors
- **NetworkFailure**: No internet connection
- **ValidationFailure**: Input validation errors (phone format, password requirements)

All errors are handled gracefully with user-friendly messages.

## Token Management
The system provides secure token management:
- **JWT Token**: Short-lived access token for API requests
- **Refresh Token**: Long-lived token for obtaining new access tokens
- **Kid (Key ID)**: Token identifier for verification
- All tokens are stored securely in SharedPreferences
- Automatic token cleanup on logout

## Best Practices Followed
- ✅ Clean Architecture layers separation
- ✅ SOLID principles
- ✅ Repository pattern
- ✅ Dependency injection with GetIt
- ✅ State management with BLoC
- ✅ Error handling with Either type (dartz)
- ✅ Phone number validation with country code
- ✅ Input validation
- ✅ Secure password entry
- ✅ Loading states
- ✅ No Equatable dependency (manual state comparison)
- ✅ JWT and refresh token management
- ✅ Mexican user profile fields (RFC, CURP)
- ✅ Complete API response mapping

## Future Enhancements
- [ ] Registration page with phone verification
- [ ] Forgot password flow with SMS
- [ ] Token refresh logic with automatic renewal
- [ ] Biometric authentication
- [ ] Profile completion flow for incomplete profiles
- [ ] SMS OTP verification
- [ ] Profile management for Mexican-specific fields
- [ ] Email verification (when email is added)
- [ ] Social authentication
- [ ] Multi-factor authentication

## Notes
- The authentication is phone-based following Mexican standards
- User model supports all required fields for Mexican KYC compliance
- Profile includes RFC (tax ID) and CURP (citizen ID) fields
- Risk level assessment is tracked
- Profile completion status is monitored
