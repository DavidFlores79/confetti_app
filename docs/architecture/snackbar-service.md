# SnackbarService Implementation

## Overview
A centralized SnackbarService has been implemented to provide consistent, user-friendly notifications throughout the app. This replaces direct ScaffoldMessenger calls and provides better UX with styled, icon-based notifications.

## Features

### ✅ Centralized Notification System
- Single source of truth for all app notifications
- Consistent styling across the entire app
- Global access without BuildContext

### ✅ Multiple Notification Types
1. **Success** - Green background with check icon
2. **Error** - Red background with error icon
3. **Warning** - Orange background with warning icon
4. **Info** - Blue background with info icon

### ✅ Enhanced UX
- Floating snackbars with rounded corners
- Icons for visual clarity
- Configurable duration (default 3 seconds)
- Dismissible notifications

## Implementation

### Service Location
`lib/core/services/snackbar_service.dart`

### Global Key Setup
The service uses a global `ScaffoldMessengerKey` that must be registered in the MaterialApp:

```dart
MaterialApp.router(
  scaffoldMessengerKey: SnackbarService.scaffoldMessengerKey,
  // ... other properties
)
```

## Usage

### Show Success Message
```dart
SnackbarService.showSuccess('Login successful!');
```

### Show Error Message
```dart
SnackbarService.showError('Invalid credentials');
```

### Show Warning Message
```dart
SnackbarService.showWarning('Session about to expire');
```

### Show Info Message
```dart
SnackbarService.showInfo('You have been logged out');
```

### Hide Current Snackbar
```dart
SnackbarService.hide();
```

## Error Handling Enhancement

### API Error Message Parsing
The remote datasource now intelligently parses error messages from API responses, supporting both single string messages and arrays of validation errors.

**API Error Response Formats:**

**Format 1: Single Message (e.g., 401 Unauthorized)**
```json
{
    "statusCode": 401,
    "message": "Unauthorized"
}
```

**Format 2: Multiple Validation Errors (e.g., 400 Bad Request)**
```json
{
    "statusCode": 400,
    "message": [
        "phone should not be empty",
        "phone must be a valid phone number",
        "password should not be empty",
        "password is not strong enough",
        "confirmPassword should not be empty"
    ],
    "error": "Bad Request"
}
```

**Before:**
- Showed: "Login failed with status: 401"
- User-unfriendly technical message
- No support for multiple validation errors

**After:**
- Single error: Shows "Unauthorized"
- Multiple errors: Shows all validation messages on separate lines
- Clean, user-friendly messages from the API

### Implementation in Remote DataSource

The `_parseErrorMessage` helper method intelligently handles different error formats:

```dart
String _parseErrorMessage(Map<String, dynamic> errorResponse, String fallbackMessage) {
  try {
    final message = errorResponse['message'];
    
    // If message is a List (validation errors)
    if (message is List) {
      if (message.isEmpty) {
        return fallbackMessage;
      }
      // Join multiple error messages with line breaks
      return message.map((e) => e.toString()).join('\n');
    }
    
    // If message is a String
    if (message is String) {
      return message;
    }
    
    // Fallback to error field if message is not available
    if (errorResponse['error'] is String) {
      return errorResponse['error'];
    }
    
    return fallbackMessage;
  } catch (e) {
    return fallbackMessage;
  }
}
```

### Multi-Line Message Support

The SnackbarService has been enhanced to display multi-line messages:

- **Duration**: Extended to 4 seconds (from 3) for multi-line messages
- **Max Lines**: Up to 5 lines with ellipsis overflow
- **Alignment**: Cross-axis start alignment for better readability
- **Icon Position**: Top-aligned with text

**Example Display:**
```
❌ phone should not be empty
   phone must be a valid phone number
   password should not be empty
   password is not strong enough
   confirmPassword should not be empty
```

## Files Modified

### Created
- `lib/core/services/snackbar_service.dart` - New service

### Updated
1. **main.dart** - Added scaffoldMessengerKey
2. **auth_remote_datasource.dart** - Parse API error messages
3. **login_page.dart** - Use SnackbarService for errors and success
4. **splash_page.dart** - Use SnackbarService for errors
5. **home.dart** - Use SnackbarService for logout and errors

## Integration Examples

### Login Page
```dart
BlocConsumer<AuthBloc, AuthState>(
  listener: (context, state) {
    if (state is AuthError) {
      SnackbarService.showError(state.message);
    } else if (state is Authenticated) {
      SnackbarService.showSuccess('Welcome back!');
      context.go('/home');
    }
  },
  // ... builder
)
```

### Home Screen
```dart
BlocListener<AuthBloc, AuthState>(
  listener: (context, state) {
    if (state is Unauthenticated) {
      SnackbarService.showInfo('You have been logged out');
      context.go('/login');
    } else if (state is AuthError) {
      SnackbarService.showError(state.message);
    }
  },
  // ... child
)
```

## Notification Styles

### Visual Design
- **Behavior**: Floating at bottom of screen
- **Shape**: Rounded corners (10px radius)
- **Margin**: 16px from edges
- **Layout**: Icon + Message in row
- **Icon Size**: Standard Material icon size
- **Icon Color**: White
- **Text Color**: White

### Colors
- **Success**: `Colors.green`
- **Error**: `Colors.red`
- **Warning**: `Colors.orange`
- **Info**: `Colors.blue`

## Benefits

### 1. Consistency
All notifications look and behave the same throughout the app.

### 2. Maintainability
Change notification styling in one place, applies everywhere.

### 3. User Experience
- Clear visual indicators (icons + colors)
- User-friendly error messages from API
- Professional appearance

### 4. Developer Experience
- Simple API: `SnackbarService.showError(message)`
- No BuildContext needed
- Type-safe notification types

### 5. Error Clarity
Users see meaningful messages like "Unauthorized" instead of "Login failed with status: 401"

## Testing

### Test Error Messages
1. Invalid credentials → Shows "Unauthorized"
2. Network error → Shows connection error
3. Validation error → Shows validation message
4. Success login → Shows "Welcome back!"
5. Logout → Shows "You have been logged out"

## Future Enhancements

Possible improvements:
- [ ] Custom duration per notification type
- [ ] Action buttons in snackbar
- [ ] Queue system for multiple notifications
- [ ] Persistent notifications (don't auto-dismiss)
- [ ] Custom styling per notification
- [ ] Sound/vibration feedback
- [ ] Analytics tracking for notification events

## Best Practices

### ✅ Do
- Use appropriate notification types (error for errors, success for success)
- Keep messages short and clear
- Parse API error messages
- Log errors before showing to users
- Use SnackbarService for all user-facing notifications

### ❌ Don't
- Show technical error details to users
- Use ScaffoldMessenger directly
- Show multiple notifications simultaneously
- Display sensitive information in notifications
- Use overly long messages

## Migration from Old System

**Before:**
```dart
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text(state.message),
    backgroundColor: Colors.red,
  ),
);
```

**After:**
```dart
SnackbarService.showError(state.message);
```

## Summary

The SnackbarService provides a robust, user-friendly notification system with:
- ✅ Centralized management
- ✅ Multiple notification types with icons
- ✅ API error message parsing
- ✅ Consistent styling
- ✅ Global accessibility
- ✅ Enhanced UX
- ✅ Better error messages

All user-facing notifications now show clean, understandable messages instead of technical error codes, significantly improving the user experience.

## Error Message Examples

### Single Error Message
When the API returns a single error message:

**API Response:**
```json
{
    "statusCode": 401,
    "message": "Unauthorized"
}
```

**Displayed:**
```
❌ Unauthorized
```

### Multiple Validation Errors
When the API returns an array of validation errors:

**API Response:**
```json
{
    "statusCode": 400,
    "message": [
        "phone should not be empty",
        "phone must be a valid phone number",
        "password should not be empty",
        "password is not strong enough",
        "confirmPassword should not be empty"
    ],
    "error": "Bad Request"
}
```

**Displayed:**
```
❌ phone should not be empty
   phone must be a valid phone number
   password should not be empty
   password is not strong enough
   confirmPassword should not be empty
```

### Error Type Comparison

| Status | API Response Type | Displayed Message |
|--------|------------------|-------------------|
| 401 | Single string | Unauthorized |
| 403 | Single string | Forbidden |
| 400 | Array of strings | All validation errors (multi-line) |
| 422 | Array of strings | All validation errors (multi-line) |
| 500 | Single string | Internal Server Error |
| Network | Exception | Connection error message |

