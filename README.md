<<<<<<< HEAD
# powergotha



## Getting started

To make it easy for you to get started with GitLab, here's a list of recommended next steps.

Already a pro? Just edit this README.md and make it your own. Want to make it easy? [Use the template at the bottom](#editing-this-readme)!

## Add your files

- [ ] [Create](https://docs.gitlab.com/ee/user/project/repository/web_editor.html#create-a-file) or [upload](https://docs.gitlab.com/ee/user/project/repository/web_editor.html#upload-a-file) files
- [ ] [Add files using the command line](https://docs.gitlab.com/topics/git/add_files/#add-files-to-a-git-repository) or push an existing Git repository with the following command:

```
cd existing_repo
git remote add origin https://gitlab.com/ahexmobileteam/powergotha.git
git branch -M main
git push -uf origin main
```

## Integrate with your tools

- [ ] [Set up project integrations](https://gitlab.com/ahexmobileteam/powergotha/-/settings/integrations)

## Collaborate with your team

- [ ] [Invite team members and collaborators](https://docs.gitlab.com/ee/user/project/members/)
- [ ] [Create a new merge request](https://docs.gitlab.com/ee/user/project/merge_requests/creating_merge_requests.html)
- [ ] [Automatically close issues from merge requests](https://docs.gitlab.com/ee/user/project/issues/managing_issues.html#closing-issues-automatically)
- [ ] [Enable merge request approvals](https://docs.gitlab.com/ee/user/project/merge_requests/approvals/)
- [ ] [Set auto-merge](https://docs.gitlab.com/user/project/merge_requests/auto_merge/)

## Test and Deploy

Use the built-in continuous integration in GitLab.

- [ ] [Get started with GitLab CI/CD](https://docs.gitlab.com/ee/ci/quick_start/)
- [ ] [Analyze your code for known vulnerabilities with Static Application Security Testing (SAST)](https://docs.gitlab.com/ee/user/application_security/sast/)
- [ ] [Deploy to Kubernetes, Amazon EC2, or Amazon ECS using Auto Deploy](https://docs.gitlab.com/ee/topics/autodevops/requirements.html)
- [ ] [Use pull-based deployments for improved Kubernetes management](https://docs.gitlab.com/ee/user/clusters/agent/)
- [ ] [Set up protected environments](https://docs.gitlab.com/ee/ci/environments/protected_environments.html)

***

# Editing this README

When you're ready to make this README your own, just edit this file and use the handy template below (or feel free to structure it however you want - this is just a starting point!). Thanks to [makeareadme.com](https://www.makeareadme.com/) for this template.

## Suggestions for a good README

Every project is different, so consider which of these sections apply to yours. The sections used in the template are suggestions for most open source projects. Also keep in mind that while a README can be too long and detailed, too long is better than too short. If you think your README is too long, consider utilizing another form of documentation rather than cutting out information.

## Name
Choose a self-explaining name for your project.

## Description
Let people know what your project can do specifically. Provide context and add a link to any reference visitors might be unfamiliar with. A list of Features or a Background subsection can also be added here. If there are alternatives to your project, this is a good place to list differentiating factors.

## Badges
On some READMEs, you may see small images that convey metadata, such as whether or not all the tests are passing for the project. You can use Shields to add some to your README. Many services also have instructions for adding a badge.

## Visuals
Depending on what you are making, it can be a good idea to include screenshots or even a video (you'll frequently see GIFs rather than actual videos). Tools like ttygif can help, but check out Asciinema for a more sophisticated method.

## Installation
Within a particular ecosystem, there may be a common way of installing things, such as using Yarn, NuGet, or Homebrew. However, consider the possibility that whoever is reading your README is a novice and would like more guidance. Listing specific steps helps remove ambiguity and gets people to using your project as quickly as possible. If it only runs in a specific context like a particular programming language version or operating system or has dependencies that have to be installed manually, also add a Requirements subsection.

## Usage
Use examples liberally, and show the expected output if you can. It's helpful to have inline the smallest example of usage that you can demonstrate, while providing links to more sophisticated examples if they are too long to reasonably include in the README.

## Support
Tell people where they can go to for help. It can be any combination of an issue tracker, a chat room, an email address, etc.

## Roadmap
If you have ideas for releases in the future, it is a good idea to list them in the README.

## Contributing
State if you are open to contributions and what your requirements are for accepting them.

For people who want to make changes to your project, it's helpful to have some documentation on how to get started. Perhaps there is a script that they should run or some environment variables that they need to set. Make these steps explicit. These instructions could also be useful to your future self.

You can also document commands to lint the code or run tests. These steps help to ensure high code quality and reduce the likelihood that the changes inadvertently break something. Having instructions for running tests is especially helpful if it requires external setup, such as starting a Selenium server for testing in a browser.

## Authors and acknowledgment
Show your appreciation to those who have contributed to the project.

## License
For open source projects, say how it is licensed.

## Project status
If you have run out of energy or time for your project, put a note at the top of the README saying that development has slowed down or stopped completely. Someone may choose to fork your project or volunteer to step in as a maintainer or owner, allowing your project to keep going. You can also make an explicit request for maintainers.
=======
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
>>>>>>> ded8568 (intial commit)
