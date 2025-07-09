/// Authentication Repository Package
///
/// This library provides a comprehensive authentication system for the PowerGodha
/// application. It includes:
/// * [AuthenticationRepository] - Main repository for authentication operations
/// * Authentication models and data structures
/// * API client for authentication endpoints
/// * Token management and storage
/// * Authentication status management
///
/// **Key Components:**
/// * Repository pattern implementation for clean architecture
/// * Stream-based authentication status monitoring
/// * Secure token storage and management
/// * API integration for login, logout, and password reset
/// * Error handling and recovery mechanisms
///
/// **Usage:**
/// ```dart
/// final authRepo = AuthenticationRepository();
///
/// // Listen to authentication status changes
/// authRepo.status.listen((status) {
///   // Handle authentication state changes
/// });
///
/// // Perform login
/// await authRepo.logIn(email: 'user@example.com', password: 'password');
///
/// // Logout
/// authRepo.logOut();
/// ```
///
/// This package is designed to be reusable across different Flutter applications
/// and follows clean architecture principles for maintainability and testability.
library authentication_repository;

import 'package:authentication_repository/authentication_repository.dart'
    show AuthenticationRepository;
import 'package:authentication_repository/src/authentication_repository.dart'
    show AuthenticationRepository;

export 'src/authentication_repository.dart';
export 'src/models/auth_models.dart';
