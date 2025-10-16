# Logging Implementation

## Overview
Comprehensive logging has been added to all features of the authentication system using the `logger` package. This provides detailed visibility into the application flow for debugging and monitoring purposes.

## Logger Package
- **Package**: `logger: ^2.6.2`
- **Features**: 
  - Pretty printing with colors and emojis
  - Stack trace support
  - Multiple log levels
  - Timestamp formatting

## Logger Configuration

### AppLogger Utility
Located at: `lib/core/utils/app_logger.dart`

```dart
class AppLogger {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
  );
}
```

### Log Levels
1. **Trace** (`AppLogger.trace`) - Most detailed information
2. **Debug** (`AppLogger.debug`) - Diagnostic information
3. **Info** (`AppLogger.info`) - General informational messages
4. **Warning** (`AppLogger.warning`) - Warning messages
5. **Error** (`AppLogger.error`) - Error messages with stack traces
6. **Fatal** (`AppLogger.fatal`) - Critical errors

## Logging Coverage

### 1. Core Layer
**File**: `lib/core/utils/app_logger.dart`
- Centralized logging utility
- Consistent logging interface across the app

### 2. Configuration Layer

**File**: `lib/config/service_locator.dart`
- Logs dependency injection initialization
- Tracks registration of each service type
- Confirms successful initialization

**File**: `lib/main.dart`
- App startup logging
- Initialization tracking

### 3. Data Layer

**File**: `lib/features/auth/data/datasources/auth_local_datasource.dart`
Logs:
- ✅ User caching operations
- ✅ Token storage operations
- ✅ User retrieval with details
- ✅ Login status checks
- ✅ Cache clearing operations
- ✅ All exceptions with stack traces

**File**: `lib/features/auth/data/datasources/auth_remote_datasource.dart`
Logs:
- ✅ API call attempts
- ✅ Request details (phone number)
- ✅ Response status codes
- ✅ Success/failure outcomes
- ✅ Server exceptions
- ✅ Network errors with stack traces

**File**: `lib/features/auth/data/repositories/auth_repository_impl.dart`
Logs:
- ✅ Login requests
- ✅ Registration requests
- ✅ Logout operations
- ✅ Token retrieval
- ✅ User data operations
- ✅ Network connectivity status
- ✅ All failure cases

### 4. Domain Layer

**File**: `lib/features/auth/domain/usecases/login.dart`
Logs:
- ✅ Use case execution
- ✅ Login success/failure
- ✅ User ID on success

**File**: `lib/features/auth/domain/usecases/logout.dart`
Logs:
- ✅ Logout execution
- ✅ Logout result

**File**: `lib/features/auth/domain/usecases/check_auth_status.dart`
Logs:
- ✅ Auth status checks
- ✅ Login status result

**File**: `lib/features/auth/domain/usecases/get_current_user.dart`
Logs:
- ✅ User retrieval attempts
- ✅ User existence status

### 5. Presentation Layer

**File**: `lib/features/auth/presentation/bloc/auth_bloc.dart`
Logs:
- ✅ BLoC initialization
- ✅ All events received (Login, Logout, CheckAuthStatus, GetCurrentUser)
- ✅ State transitions
- ✅ Authentication success/failure
- ✅ User information

**File**: `lib/features/auth/presentation/pages/login_page.dart`
Logs:
- ✅ Page initialization
- ✅ Form submission attempts
- ✅ Form validation results
- ✅ Authentication outcomes
- ✅ Navigation events

**File**: `lib/features/auth/presentation/pages/splash_page.dart`
Logs:
- ✅ Page initialization
- ✅ Auth status checks
- ✅ Navigation decisions
- ✅ Error handling

**File**: `lib/screens/home.dart`
Logs:
- ✅ Screen initialization
- ✅ Logout attempts
- ✅ Confetti button presses
- ✅ Auth state changes

## Log Examples

### Successful Login Flow
```
💡 INFO: App: Starting initialization
💡 INFO: ServiceLocator: Initializing dependencies
🐛 DEBUG: ServiceLocator: Initializing SharedPreferences
💡 INFO: ServiceLocator: All dependencies initialized successfully
💡 INFO: AuthBloc: Initialized
💡 INFO: SplashPage: Initialized, checking auth status
💡 INFO: AuthBloc: CheckAuthStatusEvent received
💡 INFO: LoginPage: Initialized
💡 INFO: LoginPage: Form validated, submitting login
💡 INFO: AuthBloc: LoginEvent received - Phone: +529991234567
💡 INFO: LoginUseCase: Executing login - Phone: +529991234567
💡 INFO: AuthRepository: Login request - Phone: +529991234567
💡 INFO: AuthRemoteDataSource: Login attempt - Phone: +529991234567
💡 INFO: AuthRemoteDataSource: Login successful - User ID: xxx
💡 INFO: AuthRepository: Login successful - User: +529991234567
💡 INFO: LoginUseCase: Login successful - User ID: xxx
💡 INFO: AuthBloc: Login successful - User: +529991234567
💡 INFO: LoginPage: Authentication successful, navigating to home
```

### Error Flow
```
⚠️ WARNING: AuthRemoteDataSource: Login failed - Empty credentials
❌ ERROR: AuthRepository: Server exception during login
⚠️ WARNING: AuthBloc: Login failed - Phone and password are required
⚠️ WARNING: LoginPage: Auth error - Phone and password are required
```

## Benefits

1. **Debugging**: Easy to trace execution flow and identify issues
2. **Monitoring**: Track user actions and system behavior
3. **Error Tracking**: Detailed error messages with stack traces
4. **Performance**: Identify slow operations
5. **Analytics**: Understand user flow and common paths
6. **Production**: Can be filtered by log level in production

## Log Level Guidelines

### Debug Level
- Cache operations
- Token retrieval
- Internal state checks
- Non-critical operations

### Info Level
- User actions (login, logout)
- Navigation events
- Successful operations
- Service initialization

### Warning Level
- Validation failures
- Expected errors
- Business logic failures
- Recoverable errors

### Error Level
- Unexpected exceptions
- Network failures
- Critical errors
- Stack trace required situations

## Configuration Options

To adjust logging in production, modify `app_logger.dart`:

```dart
// Disable emojis for production
printEmojis: false,

// Reduce method count for cleaner logs
methodCount: 0,

// Disable colors for log aggregation systems
colors: false,
```

## Integration with Monitoring

The logger can be extended to send logs to:
- Firebase Crashlytics
- Sentry
- Custom analytics platforms
- Remote logging services

## Best Practices Followed

✅ Consistent naming: All logs prefixed with component name
✅ Sensitive data protection: Passwords never logged
✅ Structured logging: Context always included
✅ Error context: Stack traces for unexpected errors
✅ User identification: Phone or ID logged for tracking
✅ Action tracking: All user actions logged
✅ State transitions: All BLoC state changes logged

## Files Modified
- Added logger package to `pubspec.yaml`
- Created `lib/core/utils/app_logger.dart`
- Updated 15+ feature files with logging

## Total Logging Points
- **50+ log statements** across all layers
- **All critical paths covered**
- **Complete trace from UI to data layer**
