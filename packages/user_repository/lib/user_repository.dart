/// User Repository Package
///
/// This library provides comprehensive user data management for the PowerGodha
/// application. It includes:
/// * [UserRepository] - Main repository for user data operations
/// * User model definitions and data structures
/// * User profile management functionality
/// * Data persistence and caching mechanisms
/// * User-related API integration
///
/// **Key Components:**
/// * Repository pattern implementation for clean architecture
/// * User model with comprehensive data fields
/// * Profile management operations (get, update, delete)
/// * Local caching for offline functionality
/// * Integration with authentication system
///
/// **Usage:**
/// ```dart
/// final userRepo = UserRepository();
///
/// // Get current user data
/// final user = await userRepo.getUser();
///
/// // Update user profile
/// await userRepo.updateUser(updatedUser);
///
/// // Handle user data operations
/// ```
///
/// **Integration:**
// ignore: comment_references
/// * Works seamlessly with [AuthenticationRepository]
/// * Provides user data for authenticated sessions
/// * Supports profile updates and user management
/// * Handles user data lifecycle throughout the app
///
/// This package follows clean architecture principles and is designed
/// for reusability across different Flutter applications.
library user_repository;

import 'package:user_repository/src/user_repository.dart' show UserRepository;
import 'package:user_repository/user_repository.dart' show UserRepository;

export 'src/models/models.dart';
export 'src/user_repository.dart';
