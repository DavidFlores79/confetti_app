# Documentation Index

Welcome to the Confetti App documentation. This guide provides comprehensive information about the application's features, architecture, and development practices.

## 📚 Documentation Structure

### Features

Detailed documentation for each major feature of the application:

- **[Authentication](features/authentication.md)** - Phone-based authentication system with OTP verification
  - Login/Signup flows
  - OTP verification
  - Session management
  - BLoC state management

- **[Catalogs](features/catalogs.md)** - Complete catalog service integration
  - Countries, states, cities
  - Economic activities
  - Purposes and settlements
  - Usage examples

- **[Catalogs Quick Reference](features/catalogs-quick-reference.md)** - Quick API reference
  - All endpoints at a glance
  - Request/response formats
  - Common use cases

- **[Theme & Settings](features/theme-and-settings.md)** - Theme and user preferences
  - Light/dark mode
  - Settings page
  - Persistent preferences
  - Theme customization

### Architecture

Core architectural patterns and services:

- **[Logging](architecture/logging.md)** - Application logging system
  - Logger setup
  - Log levels
  - Usage patterns
  - Best practices

- **[Snackbar Service](architecture/snackbar-service.md)** - Notification system
  - Success/error notifications
  - Custom styling
  - Service implementation
  - Usage examples

### Development

Development guidelines and processes:

- **[Branching Strategy](development/branching-strategy.md)** - Git workflow
  - Branch naming conventions
  - Merge strategies
  - Release process
  - Hotfix procedures

- **[Changelog](development/changelog.md)** - Recent changes and updates
  - Feature additions
  - Bug fixes
  - Breaking changes
  - Migration guides

- **[API Changes](development/catalogs-api-changes.md)** - Catalog API updates
  - Endpoint changes
  - Response format updates
  - Migration notes

## 🚀 Quick Links

### Getting Started
- [Main README](../README.md) - Project overview and setup
- [Authentication](features/authentication.md) - Start with auth
- [Catalogs Quick Reference](features/catalogs-quick-reference.md) - API reference

### For Developers
- [Branching Strategy](development/branching-strategy.md) - Git workflow
- [Logging](architecture/logging.md) - How to log
- [Changelog](development/changelog.md) - What's new

### For Architects
- [Authentication Architecture](features/authentication.md#architecture) - Auth design
- [Clean Architecture Pattern](features/catalogs.md#architecture) - Project structure
- [Service Layer](architecture/snackbar-service.md) - Service patterns

## 📋 Documentation Standards

When adding new documentation:

1. **Placement**:
   - Feature docs → `features/`
   - Architecture docs → `architecture/`
   - Development docs → `development/`

2. **Format**:
   - Use clear, descriptive titles
   - Include code examples
   - Add diagrams where helpful
   - Keep language concise

3. **Structure**:
   - Start with overview
   - Provide usage examples
   - Document edge cases
   - Include troubleshooting

4. **Maintenance**:
   - Update docs with code changes
   - Mark deprecated features
   - Version major changes
   - Link related documents

## 🔍 Finding Information

### By Topic

**Authentication & Security**
- [Authentication Feature](features/authentication.md)
- Login, signup, OTP flows

**Data & APIs**
- [Catalogs](features/catalogs.md)
- [API Changes](development/catalogs-api-changes.md)
- [Quick Reference](features/catalogs-quick-reference.md)

**UI & UX**
- [Theme & Settings](features/theme-and-settings.md)
- [Snackbar Service](architecture/snackbar-service.md)

**Development**
- [Branching Strategy](development/branching-strategy.md)
- [Changelog](development/changelog.md)
- [Logging](architecture/logging.md)

### By Role

**Frontend Developers**
1. [Authentication](features/authentication.md) - Auth UI flows
2. [Theme & Settings](features/theme-and-settings.md) - Theming
3. [Snackbar Service](architecture/snackbar-service.md) - Notifications

**Backend Integration**
1. [Catalogs](features/catalogs.md) - API integration
2. [API Changes](development/catalogs-api-changes.md) - API updates
3. [Catalogs Quick Reference](features/catalogs-quick-reference.md) - Endpoints

**Team Leads**
1. [Branching Strategy](development/branching-strategy.md) - Workflow
2. [Changelog](development/changelog.md) - Progress tracking
3. [Logging](architecture/logging.md) - Monitoring

## 📝 Contributing to Documentation

To add or update documentation:

1. Create/edit the appropriate `.md` file
2. Follow the existing structure and format
3. Update this index if adding new docs
4. Test all code examples
5. Submit PR with documentation changes

## 🆘 Need Help?

- Check [Main README](../README.md) for project setup
- Review feature-specific docs for usage
- See [Changelog](development/changelog.md) for recent updates
- Contact the development team

---

**Last Updated**: 2025-10-15

**Documentation Version**: 1.0.0
