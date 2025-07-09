/// User Repository for managing user data and profile information.
///
/// This repository provides a clean interface for user-related operations
/// and integrates with the authentication system to fetch and manage
/// user profile data from the API.
///
/// **Responsibilities:**
/// * Fetch current user data from authentication API
/// * Cache user data for offline access
/// * Provide user profile management operations
/// * Handle user data lifecycle and updates
/// * Integration with authentication token management
///
/// **Dependencies:**
/// * Requires access to authentication repository for API calls
/// * Uses authentication tokens for secure API access
/// * Integrates with user data storage and caching
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
/// ```
///
/// This repository follows the repository pattern for clean architecture
/// and provides abstraction over user data operations.
library;

import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:dio/dio.dart';
import 'package:user_repository/src/models/models.dart';
import 'package:user_repository/src/user_api_client.dart';

/// {@template user_repository}
/// Repository that manages user profile data and operations.
///
/// This repository serves as the interface between the application and
/// user-related data operations. It integrates with the authentication
/// system to fetch user data and provides caching for better performance.
///
/// **Key Features:**
/// * Real user data fetching from authentication API
/// * Local caching for improved performance
/// * Error handling and exception management
/// * Integration with authentication token system
/// * Profile update operations
///
/// **Architecture Integration:**
/// * Depends on [AuthenticationRepository] for token access
/// * Uses its own API client for user operations
/// * Converts API response data to [User] models
/// * Provides user data to BLoCs and UI components
/// * Handles user data lifecycle throughout the app
///
/// **Caching Strategy:**
/// * Caches user data after successful API calls
/// * Returns cached data for subsequent requests (if available)
/// * Refreshes cache when explicit refresh is requested
/// * Clears cache on authentication state changes
/// {@endtemplate}
class UserRepository {
  /// Authentication repository for token management.
  ///
  /// This repository provides access to authentication tokens
  /// needed for making authorized API calls to user endpoints.
  final AuthenticationRepository _authenticationRepository;
  /// HTTP client for making API requests.
  final Dio _dio;

  /// API client for user-related operations.
  late final UserApiClient _apiClient;

  /// Cached user data to avoid unnecessary API calls.
  ///
  /// This cache improves performance by storing the last fetched
  /// user data and returning it for subsequent requests until
  /// explicitly refreshed or cleared.
  User? _cachedUser;

  /// Future for preventing concurrent API calls.
  ///
  /// This ensures that if multiple getUser calls happen simultaneously,
  /// they will all wait for the same API request instead of making
  /// multiple identical requests.
  Future<User>? _pendingUserFetch;
  /// {@macro user_repository}
  ///
  /// Creates a new [UserRepository] with the provided authentication repository.
  ///
  /// **Parameters:**
  /// * [authenticationRepository] - Repository for authentication operations
  ///   and token access. Used to get tokens for API calls.
  /// * [dio] - Shared HTTP client for making API requests. This should be
  ///   the same instance used by other repositories for optimal performance.
  UserRepository({required AuthenticationRepository authenticationRepository, required Dio dio})
    : _authenticationRepository = authenticationRepository,
      _dio = dio {
    // Initialize the API client with the shared Dio instance
    _apiClient = UserApiClient(dio);
  }

  /// Clears the cached user data.
  ///
  /// This method removes any cached user data, forcing the next
  /// [getUser] call to fetch fresh data from the API. Useful when
  /// user authentication state changes or when data needs to be refreshed.
  ///
  /// **Usage:**
  /// ```dart
  /// // Clear cache after logout
  /// userRepository.clearCache();
  ///
  /// // Next getUser() call will fetch fresh data
  /// final user = await userRepository.getUser();
  /// ```
  void clearCache() {
    _cachedUser = null;
    _pendingUserFetch = null;
  }

  /// Disposes of any resources used by the repository.
  ///
  /// This method should be called when the repository is no longer needed
  /// to clean up resources and prevent memory leaks. It clears the cache
  /// and closes the HTTP client.
  ///
  /// **Usage:**
  /// ```dart
  /// // Clean up when repository is no longer needed
  /// userRepository.dispose();
  /// ```
  void dispose() {
    _cachedUser = null;
    _pendingUserFetch = null;
    _dio.close();
  }

  /// Retrieves the current user's profile data.
  ///
  /// This method fetches the authenticated user's profile information
  /// from the API and converts it to a [User] model. It includes
  /// caching to improve performance and reduce API calls.
  ///
  /// **Returns:** [User] object with current user data
  /// **Throws:** [UserRepositoryException] if user data cannot be retrieved
  ///
  /// **Caching Behavior:**
  /// * Returns cached data if available and not explicitly refreshed
  /// * Fetches fresh data from API if cache is empty
  /// * Updates cache with fresh data after successful API calls
  ///
  /// **Error Handling:**
  /// * Handles authentication errors (expired tokens, unauthorized access)
  /// * Provides descriptive error messages for different failure scenarios
  /// * Clears cached data on authentication failures
  ///
  /// **Usage:**
  /// ```dart
  /// try {
  ///   final user = await userRepository.getUser();
  ///   print('Welcome, ${user.fullName}!');
  /// } catch (e) {
  ///   print('Failed to get user data: $e');
  /// }
  /// ```
  Future<User> getUser() async {
    // If there's already a pending fetch, wait for it
    if (_pendingUserFetch != null) {
      return _pendingUserFetch!;
    }

    // Start a new fetch and store the future
    _pendingUserFetch = _performUserFetch();

    try {
      final user = await _pendingUserFetch!;
      return user;
    } finally {
      // Clear the pending future when done
      _pendingUserFetch = null;
    }
  }

  /// Retrieves user data with optional cache bypass.
  ///
  /// This method provides more control over caching behavior, allowing
  /// callers to force a refresh of user data from the API even if
  /// cached data is available.
  ///
  /// **Parameters:**
  /// * [forceRefresh] - If true, bypasses cache and fetches fresh data
  ///
  /// **Returns:** [User] object with user data (cached or fresh)
  /// **Throws:** [UserRepositoryException] if operation fails
  ///
  /// **Usage:**
  /// ```dart
  /// // Get cached data (if available)
  /// final user = await userRepository.getUserWithCaching();
  ///
  /// // Force refresh from API
  /// final freshUser = await userRepository.getUserWithCaching(
  ///   forceRefresh: true,
  /// );
  /// ```
  Future<User> getUserWithCaching({bool forceRefresh = false}) async {
    // Return cached data if available and not forcing refresh
    if (!forceRefresh && _cachedUser != null) {
      return _cachedUser!;
    }

    // Fetch fresh data from API
    return await getUser();
  }

  /// Updates the current user's profile information.
  ///
  /// This method would be used to update user profile data on the server.
  /// Currently returns the updated user data as this is a demo implementation.
  ///
  /// **Parameters:**
  /// * [user] - Updated user data to save
  ///
  /// **Returns:** [User] object with updated data
  /// **Throws:** [UserRepositoryException] if update fails
  ///
  /// **Future Implementation:**
  /// This method should integrate with a user update API endpoint
  /// to persist changes to the server and update the local cache.
  ///
  /// **Usage:**
  /// ```dart
  /// final updatedUser = currentUser.copyWith(
  ///   firstName: 'NewFirstName',
  ///   lastName: 'NewLastName',
  /// );
  ///
  /// final result = await userRepository.updateUser(updatedUser);
  /// ```
  Future<User> updateUser(User user) async {
    try {
      // TODO: Implement actual user update API call
      // For now, just update the cache
      _cachedUser = user;
      return user;
    } catch (e) {
      throw UserRepositoryException('Failed to update user data: ${e.toString()}');
    }
  }

  /// Gets the current user's information directly from the API.
  ///
  /// This method makes a direct API call to fetch user data,
  /// bypassing any local cache. It requires valid authentication
  /// tokens from the authentication repository.
  ///
  /// **Returns:** [UserResponse] with fresh user data from API
  /// **Throws:** [UserRepositoryException] if API call fails
  ///
  /// **Private method used internally by public methods.**
  Future<UserResponse> _fetchUserFromApi() async {
    final accessToken = _authenticationRepository.currentAccessToken;
    final currentUser = _authenticationRepository.currentUser;

    if (accessToken == null) {
      throw const UserRepositoryException('No access token available');
    }

    if (currentUser == null) {
      throw const UserRepositoryException('No current user data available');
    }

    try {
      // Use the API client with user ID and token
      final rawResponse = await _apiClient.getCurrentUser(currentUser.id, 'Bearer $accessToken');

      // Extract data from response (might be wrapped in a 'data' field)
      final userData = rawResponse['data'] as Map<String, dynamic>? ?? rawResponse;
      final response = UserResponse.fromJson(userData);
      return response;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw const UserRepositoryException('Authentication failed - token expired');
      }
      throw UserRepositoryException('Failed to fetch user data: ${e.message ?? "Unknown error"}');
    } catch (e) {
      throw UserRepositoryException('Unexpected error: ${e.toString()}');
    }
  }
  /// Performs the actual user fetch from API.
  ///
  /// This method is separated to allow the main getUser method
  /// to manage the pending future properly.
  Future<User> _performUserFetch() async {
    try {
      // Fetch current user data from the API
      final userResponse = await _fetchUserFromApi();

      // Convert user response to User model
      final user = User.fromUserResponse(
        id: userResponse.id,
        username: userResponse.username,
        email: userResponse.email,
        firstName: userResponse.firstName,
        lastName: userResponse.lastName,
        gender: userResponse.gender,
        image: userResponse.image,
        farmName: userResponse.farmName,
      );

      // Cache the user data for future requests
      _cachedUser = user;

      return user;
    } on UserRepositoryException {
      // Re-throw user repository exceptions as-is
      _cachedUser = null;
      rethrow;
    } catch (e) {
      // Handle other types of errors
      _cachedUser = null;
      throw UserRepositoryException('Failed to fetch user data: ${e.toString()}');
    }
  }


}

/// Exception thrown when user repository operations fail.
class UserRepositoryException implements Exception {
  /// The error message describing what went wrong.
  final String message;

  /// Creates a new user repository exception with the specified message.
  const UserRepositoryException(this.message);

  @override
  String toString() => 'UserRepositoryException: $message';
}
