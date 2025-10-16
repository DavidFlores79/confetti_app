# Theme and Settings Feature

## Overview
Comprehensive theme management system with light/dark mode support and a dedicated settings page for users to customize their app experience.

## Features

### ✨ Theme System
- **Light Theme** - Clean, bright interface
- **Dark Theme** - Eye-friendly dark interface  
- **System Theme** - Automatically follows device settings
- Smooth theme transitions
- Persistent theme preference

### 🎨 Color Palette
Complete color system with Material Design 3 support:

**Primary Colors:**
- Primary Green: `#008D34`
- Primary Light: `#B6E5C8`
- Primary Medium: `#006622`
- Green Dark: `#00461A`
- Green Light: `#E8F6EC`

**Custom Colors:**
- Custom Green: `#4CB00E`
- Custom Purple: `#B00EA8`
- Custom Orange: `#EC8702`

**Gray Scale:**
- 11 shades from gray50 to gray950
- Optimized for both light and dark themes

**Black & White:**
- Multiple variants for subtle variations
- Alpha transparency variants

### ⚙️ Settings Page
- Theme selection with radio buttons
- Quick theme toggle switch
- Visual icons for each theme mode
- Success notifications on theme change
- App information section

## Implementation

### Architecture

**State Management:**
- `ThemeCubit` - Manages theme state using Cubit pattern
- Persists theme preference to SharedPreferences
- Reactive UI updates on theme changes

**Theme Configuration:**
- `AppColors` - Centralized color definitions
- `AppTheme` - Complete light and dark theme configurations
- Material Design 3 theming

### File Structure

```
lib/
├── core/
│   └── theme/
│       ├── app_colors.dart          # Color definitions
│       └── app_theme.dart           # Theme configurations
├── features/
│   └── settings/
│       └── presentation/
│           ├── cubit/
│           │   ├── theme_cubit.dart  # Theme state management
│           │   └── theme_state.dart  # Theme states
│           └── pages/
│               └── settings_page.dart # Settings UI
└── config/
    └── service_locator.dart          # DI registration
```

## Usage

### Access Settings
From the home screen, tap the settings icon in the app bar to open the settings page.

### Change Theme

**Method 1: Settings Page**
1. Open Settings
2. Select your preferred theme:
   - **Light** - Always use light theme
   - **Dark** - Always use dark theme
   - **System** - Follow device theme

**Method 2: Quick Toggle**
Use the switch in the settings page to quickly toggle between light and dark themes.

## Theme Configuration

### Light Theme Features
- White/light gray backgrounds
- Green primary colors
- High contrast for readability
- Bright, clean appearance

### Dark Theme Features
- Dark backgrounds (#1C1B1F, #010101)
- Lighter green accents for visibility
- Reduced eye strain
- OLED-friendly pure blacks

### Theme Components

Both themes include complete styling for:
- ✅ App Bar
- ✅ Buttons (Elevated, Text, Icon)
- ✅ Input Fields
- ✅ Cards
- ✅ Dialogs
- ✅ Snackbars
- ✅ Icons
- ✅ Text Styles
- ✅ Dividers

## Code Examples

### Using Theme Colors in Code

```dart
// Access theme colors
final primaryColor = Theme.of(context).colorScheme.primary;
final surface = Theme.of(context).colorScheme.surface;

// Or use AppColors directly
Container(
  color: AppColors.primary,
  // ...
)
```

### Switching Themes Programmatically

```dart
// Get ThemeCubit
final themeCubit = context.read<ThemeCubit>();

// Set light theme
themeCubit.setLightTheme();

// Set dark theme
themeCubit.setDarkTheme();

// Set system theme
themeCubit.setSystemTheme();

// Quick toggle
themeCubit.toggleTheme();
```

### Check Current Theme

```dart
final themeCubit = context.read<ThemeCubit>();

if (themeCubit.isDarkMode) {
  // Dark theme is active
}

if (themeCubit.isLightMode) {
  // Light theme is active
}

if (themeCubit.isSystemMode) {
  // Following system theme
}
```

## Integration Details

### Service Locator
ThemeCubit is registered as a lazy singleton:

```dart
sl.registerLazySingleton(
  () => ThemeCubit(sharedPreferences: sl()),
);
```

### Main App
Theme is applied via MultiBlocProvider:

```dart
MultiBlocProvider(
  providers: [
    BlocProvider(create: (context) => sl<AuthBloc>()),
    BlocProvider(create: (context) => sl<ThemeCubit>()),
  ],
  child: BlocBuilder<ThemeCubit, ThemeState>(
    builder: (context, state) {
      final themeCubit = context.read<ThemeCubit>();
      
      return MaterialApp.router(
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeCubit.themeMode,
        // ...
      );
    },
  ),
)
```

### Router
Settings page added to routes:

```dart
GoRoute(
  path: '/settings',
  builder: (context, state) => const SettingsPage(),
),
```

## Logging

All theme changes are logged:

```
💡 INFO: ThemeCubit: Loading theme preference
💡 INFO: ThemeCubit: Dark theme loaded
💡 INFO: SettingsPage: User selected light theme
💡 INFO: ThemeCubit: Setting light theme
```

## Notifications

User-friendly snackbar notifications on theme changes:
- ✅ "Light theme activated"
- ✅ "Dark theme activated"  
- ℹ️ "System theme activated"

## Persistence

Theme preference is automatically saved and restored:
- Saved to SharedPreferences with key `THEME_MODE`
- Restored on app launch
- Survives app restarts

## Accessibility

Both themes are designed with accessibility in mind:
- High contrast ratios
- Clear text readability
- Appropriate color choices
- Material Design 3 standards

## Best Practices

### ✅ Do
- Use theme colors via `Theme.of(context).colorScheme`
- Let the theme system handle color selection
- Test UI in both light and dark themes
- Use semantic color names (primary, surface, etc.)

### ❌ Don't
- Hardcode colors in widgets
- Assume theme is always light or dark
- Use colors that don't work in both themes
- Override theme colors unnecessarily

## Future Enhancements

Possible improvements:
- [ ] Custom theme colors picker
- [ ] More theme variants
- [ ] Font size adjustment
- [ ] High contrast mode
- [ ] Custom accent colors
- [ ] Theme scheduling (auto-switch at sunset)
- [ ] Per-screen theme overrides

## Testing

### Manual Testing
1. ✅ Change theme from settings
2. ✅ Verify persistence after app restart
3. ✅ Test system theme following device settings
4. ✅ Check all screens in both themes
5. ✅ Verify snackbar notifications appear

### Theme Coverage
- ✅ Splash Page
- ✅ Login Page
- ✅ Home Screen
- ✅ Settings Page
- ✅ All dialogs and snackbars

## Statistics

- **2 complete themes** (light + dark)
- **50+ color definitions**
- **3 theme modes** (light, dark, system)
- **All Material components** styled
- **Persistent** theme storage
- **Zero analysis issues**

## Summary

The theme system provides a professional, user-friendly way to customize the app appearance with:
- ✅ Complete light and dark themes
- ✅ Persistent user preferences
- ✅ Easy-to-use settings interface
- ✅ Smooth transitions
- ✅ Comprehensive logging
- ✅ Material Design 3 compliance
- ✅ Accessible color choices

Users can now enjoy their preferred visual experience with just a tap!
