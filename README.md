# Confetti App

A Flutter application built with Clean Architecture, BLoC pattern, and modern development practices.

## Overview

Confetti App is a production-ready Flutter application featuring authentication, theme management, catalog services, and comprehensive logging. The project follows SOLID principles and Clean Architecture for maintainability and scalability.

## Key Features

- 🔐 **Phone-based Authentication** - Secure login and signup with OTP verification
- 🌍 **Catalog Services** - Countries, states, cities, and business catalogs
- 🎨 **Theme Management** - Light/dark mode with persistent settings
- 📱 **Responsive UI** - Beautiful, adaptive user interface
- 📊 **Comprehensive Logging** - Detailed application monitoring
- 🔔 **Smart Notifications** - Centralized snackbar service

## Tech Stack

- **Flutter** - UI framework
- **BLoC** - State management
- **GetIt** - Dependency injection
- **GoRouter** - Navigation
- **Dio** - HTTP client
- **Dartz** - Functional programming
- **SharedPreferences** - Local storage

## Project Structure

```
lib/
├── config/              # App configuration and service locator
├── core/                # Core utilities, theme, validators
│   ├── error/          # Error handling
│   ├── network/        # Network configuration
│   ├── services/       # Core services (snackbar, etc.)
│   ├── theme/          # Theme configuration
│   └── ui/             # Reusable UI components
├── features/           # Feature modules (Clean Architecture)
│   ├── auth/           # Authentication feature
│   ├── catalogs/       # Catalog services
│   └── settings/       # App settings
└── main.dart           # Application entry point
```

## Getting Started

### Prerequisites

- Flutter SDK (3.0.0 or higher)
- Dart SDK (3.0.0 or higher)
- iOS/Android development environment

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd confetti_app
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

## Configuration

### API Configuration

Update the base URL in `lib/core/network/api_config.dart`:
```dart
static const String baseUrl = 'your-api-url';
```

### Environment Setup

The app uses environment-based configuration. Check `lib/config/` for configuration files.

## Documentation

Comprehensive documentation is available in the `docs/` directory:

### Features
- [Authentication](docs/features/authentication.md) - Phone-based auth with OTP
- [Catalogs](docs/features/catalogs.md) - Geographic and business catalogs
- [Catalogs Quick Reference](docs/features/catalogs-quick-reference.md) - API endpoints
- [Theme & Settings](docs/features/theme-and-settings.md) - Theme management

### Architecture
- [Logging](docs/architecture/logging.md) - Logging implementation
- [Snackbar Service](docs/architecture/snackbar-service.md) - Notification system

### Development
- [Branching Strategy](docs/development/branching-strategy.md) - Git workflow
- [Changelog](docs/development/changelog.md) - Recent changes
- [API Changes](docs/development/catalogs-api-changes.md) - API updates

📚 **[View Full Documentation Index](docs/README.md)**

## Development Workflow

### Branching Strategy

- `main` - Production releases
- `develop` - Development integration
- `feature/*` - New features
- `bugfix/*` - Bug fixes
- `hotfix/*` - Production hotfixes

See [Branching Strategy](docs/development/branching-strategy.md) for details.

### Code Style

This project follows Flutter's official style guide and uses `flutter analyze` for linting.

```bash
# Run analyzer
flutter analyze

# Format code
flutter format lib/

# Run tests
flutter test
```

## Testing

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage
```

## Building

### Android
```bash
flutter build apk --release
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

## Contributing

1. Create a feature branch from `develop`
2. Make your changes following the project structure
3. Write/update tests
4. Run analyzer and tests
5. Create a pull request to `develop`

## Architecture

The project follows Clean Architecture principles with three main layers:

- **Presentation Layer** - UI and state management (BLoC)
- **Domain Layer** - Business logic and use cases
- **Data Layer** - Repository implementations and data sources

Each feature is self-contained with its own layers, promoting modularity and testability.

## License

[Add your license here]

## Contact

[Add contact information]

---

**Note**: This is an active development project. Check the [changelog](docs/development/changelog.md) for recent updates.
