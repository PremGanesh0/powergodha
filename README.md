# PowerGodha Mobile Application

A Flutter application implementing authentication flow with clean architecture principles using BLoC pattern for state management.

## Project Overview

This project demonstrates a complete authentication system with:

- User login and logout functionality
- Authentication state management
- Repository pattern for data access
- Clean navigation flow
- BLoC pattern for state management
- Modular architecture for maintainability

## Architecture

### Clean Architecture Layers

```
┌─────────────────────────────────────────┐
│                   UI Layer              │
│  ┌─────────────┐ ┌─────────────────────┐ │
│  │   Pages     │ │      Widgets        │ │
│  │  (Views)    │ │    (Components)     │ │
│  └─────────────┘ └─────────────────────┘ │
└─────────────────────────────────────────┘
┌─────────────────────────────────────────┐
│              Business Logic             │
│  ┌─────────────┐ ┌─────────────────────┐ │
│  │    BLoC     │ │      Events &       │ │
│  │ (State Mgmt)│ │      States         │ │
│  └─────────────┘ └─────────────────────┘ │
└─────────────────────────────────────────┘
┌─────────────────────────────────────────┐
│                Data Layer               │
│  ┌─────────────┐ ┌─────────────────────┐ │
│  │ Repositories│ │      Models         │ │
│  │(Data Access)│ │   (Data Structures) │ │
│  └─────────────┘ └─────────────────────┘ │
└─────────────────────────────────────────┘
```

### Key Design Patterns

- **BLoC Pattern**: State management and business logic separation
- **Repository Pattern**: Data access abstraction
- **Dependency Injection**: Clean dependency management
- **Single Responsibility**: Each class has one clear purpose
- **Separation of Concerns**: UI, business logic, and data are separated

## API Configuration

The application now uses a centralized API configuration system for better maintainability and environment management.

### Key Features

- **Single Source of Truth**: All API URLs managed in `lib/shared/api_config.dart`
- **Environment Support**: Easy switching between development, staging, and production
- **Shared HTTP Client**: Optimized Dio instance with connection pooling and interceptors
- **Type-Safe Configuration**: Compile-time constants for endpoints and timeouts

### Usage

```dart
import 'package:powergodha/shared/shared.dart';

// Get current environment's base URL
final baseUrl = ApiConfig.baseUrl;

// Get full URL for an endpoint
final loginUrl = ApiConfig.getFullUrl(ApiConfig.loginEndpoint);

// Switch environments (change in ApiConfig.currentEnvironment)
final prodUrl = ApiConfig.forEnvironment(Environment.production);
```




For detailed information, see [API Configuration Documentation](docs/API_CONFIGURATION.md).

## Project Structure

```
lib/
├── main.dart                          # App entry point
├── app/                              # App configuration
│   ├── app.dart                      # Root app widget with DI setup
│   └── app_view.dart                 # Navigation and routing logic
├── authentication/                   # Global auth state management
│   ├── authentication.dart           # Barrel export
│   └── bloc/                        # Authentication BLoC
│       ├── authentication_bloc.dart  # Main authentication logic
│       ├── authentication_event.dart # Authentication events
│       └── authentication_state.dart # Authentication states
├── login/                           # Login feature module
│   ├── login.dart                   # Barrel export
│   ├── bloc/                        # Login form state management
│   ├── models/                      # Login-specific models
│   └── view/                        # Login UI components
│       ├── login_page.dart          # Login page container
│       └── login_form.dart          # Login form widget
├── home/                           # Authenticated user home
│   ├── home.dart                   # Barrel export
│   └── view/                       # Home UI components
│       └── home_page.dart          # Main home page
├── splash/                         # App startup screen
│   ├── splash.dart                 # Barrel export
│   └── view/                       # Splash UI components
│       └── splash_page.dart        # Initial loading screen
├── shared/                         # Shared utilities and configuration
│   ├── shared.dart                 # Barrel export for shared utilities
│   ├── api_config.dart            # Centralized API configuration
│   └── http_client.dart           # HTTP client utilities (future)
├── signup/                         # User registration (future)
├── forgot_password/               # Password recovery (future)
└── packages/                      # Local packages
    ├── authentication_repository/ # Authentication data access
    └── user_repository/          # User data management
```

## Features

### Recent Updates

- ✅ **Centralized API Configuration**: Single source of truth for base URLs and API settings
- ✅ **Environment Management**: Easy switching between development, staging, and production
- ✅ **Shared HTTP Client**: Optimized network performance with connection pooling
- ✅ **Code Generation Scripts**: Automated build scripts for API client regeneration
- ✅ **Clean Architecture**: Separation of concerns with repository pattern

### Implemented Features

- ✅ **App Initialization**: Proper startup with splash screen
- ✅ **Authentication Flow**: Complete login/logout cycle
- ✅ **State Management**: Global authentication state with BLoC
- ✅ **Navigation**: Authentication-based routing
- ✅ **Repository Pattern**: Clean data access layer
- ✅ **Dependency Injection**: Proper service setup
- ✅ **Error Handling**: Authentication error management
- ✅ **Clean Architecture**: Separation of concerns

### Future Features

- 🔄 **User Registration**: Sign up functionality
- 🔄 **Password Recovery**: Forgot password flow
- 🔄 **User Profile**: Profile management and updates
- 🔄 **Token Refresh**: Automatic token renewal
- 🔄 **Biometric Auth**: Fingerprint/Face ID login
- 🔄 **Social Login**: Google/Facebook authentication
- 🔄 **Offline Support**: Local data caching

## Getting Started

### Prerequisites

- Flutter SDK (latest stable version)
- Dart SDK (comes with Flutter)
- Android Studio or VS Code with Flutter plugins
- iOS Simulator (Mac) or Android Emulator

### Installation

1. **Clone the repository**

   ```bash
   git clone <repository-url>
   cd pg-mobile
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Run the application**

   ```bash
   flutter run
   ```

### Development Setup

1. **IDE Extensions**
   - Flutter extension for VS Code
   - Dart extension for VS Code
   - Bloc extension for enhanced BLoC support

2. **Code Generation** (if needed)

   ```bash
   flutter packages pub run build_runner build
   ```

3. **Testing**

   ```bash
   flutter test
   ```

## Authentication Flow

### User Journey

1. **App Launch**
   - Display splash screen
   - Initialize authentication system
   - Check existing authentication status

2. **Unauthenticated Flow**
   - Navigate to login page
   - User enters credentials
   - Validate and submit login form
   - Handle authentication response

3. **Authenticated Flow**
   - Navigate to home page
   - Display user information
   - Provide logout functionality
   - Maintain authentication state

4. **Logout Flow**
   - Clear authentication tokens
   - Update authentication state
   - Navigate back to login page

### State Management

```dart
// Authentication States
sealed class AuthenticationState {
  unknown()           // Initial/loading state
  authenticated(user) // User is logged in
  unauthenticated()   // User is not logged in
  error(message)      // Authentication error
  passwordResetSent() // Password reset email sent
}

// Authentication Events
sealed class AuthenticationEvent {
  subscriptionRequested()     // Start auth monitoring
  logoutPressed()            // User logout action
  forgotPasswordRequested()  // Password reset request
}
```

## Code Organization

### Module Structure

Each feature module follows a consistent structure:

```
feature_name/
├── feature_name.dart          # Barrel export file
├── bloc/                      # State management
│   ├── feature_bloc.dart      # Main BLoC logic
│   ├── feature_event.dart     # Feature events
│   └── feature_state.dart     # Feature states
├── models/                    # Feature-specific models
│   └── models.dart           # Model exports
└── view/                     # UI components
    ├── view.dart             # View exports
    ├── feature_page.dart     # Main page widget
    └── feature_form.dart     # Form components
```

### Naming Conventions

- **Files**: `snake_case.dart`
- **Classes**: `PascalCase`
- **Variables**: `camelCase`
- **Constants**: `UPPER_SNAKE_CASE`
- **Private members**: `_privateVariable`

### Import Organization

```dart
// 1. Dart imports
import 'dart:async';

// 2. Flutter imports
import 'package:flutter/material.dart';

// 3. Package imports
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

// 4. Local imports
import 'package:powergodha/authentication/authentication.dart';
```

## Testing Strategy

### Test Types

1. **Unit Tests**: Business logic and models
2. **Widget Tests**: UI components and interactions
3. **Integration Tests**: Complete user flows
4. **Golden Tests**: UI consistency verification

### Test Structure

```
test/
├── authentication/           # Authentication tests
├── login/                   # Login feature tests
├── home/                    # Home feature tests
├── helpers/                 # Test utilities
└── test_app.dart           # Test app setup
```

## Contributing

### Development Guidelines

1. **Code Style**: Follow Effective Dart guidelines
2. **Documentation**: Document all public APIs
3. **Testing**: Write tests for new features
4. **Git Commits**: Use conventional commit messages
5. **Code Review**: All changes require review

### Commit Message Format

```
type(scope): description

Examples:
feat(auth): add password reset functionality
fix(login): resolve form validation issue
docs(readme): update installation instructions
test(auth): add authentication bloc tests
```

## Dependencies

### Main Dependencies

- `flutter`: UI framework
- `flutter_bloc`: State management
- `equatable`: Value equality comparison
- `authentication_repository`: Local authentication package
- `user_repository`: Local user data package

### Development Dependencies

- `flutter_test`: Testing framework
- `bloc_test`: BLoC testing utilities
- `mocktail`: Mocking for tests

## Performance Considerations

### Optimization Strategies

1. **State Management**: Efficient BLoC usage with selective rebuilds
2. **Navigation**: Proper route management and stack cleanup
3. **Memory**: Dispose patterns for resources
4. **Build Methods**: Minimal and focused widget builds

### Best Practices Implemented

- Use `const` constructors where possible
- Implement proper disposal for streams and controllers
- Use `context.select` for specific state selections
- Avoid expensive operations in build methods

## Troubleshooting

### Common Issues

1. **Build Errors**: Run `flutter clean && flutter pub get`
2. **State Issues**: Check BLoC event/state mapping
3. **Navigation Issues**: Verify route configurations
4. **Dependency Issues**: Update pubspec.yaml versions

### Debug Tips

- Use Flutter Inspector for widget tree analysis
- Enable BLoC observer for state transition logging
- Use breakpoints in key authentication flow points
- Check authentication repository status streams

## Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [BLoC Library Documentation](https://bloclibrary.dev/)
- [Effective Dart](https://dart.dev/guides/language/effective-dart)
- [Flutter Architecture Samples](https://github.com/brianegan/flutter_architecture_samples)

## License

[Add your license information here]

---

This project serves as a foundation for Flutter applications requiring authentication and demonstrates clean architecture principles with the BLoC pattern for maintainable and scalable mobile applications.
