/// User Language Service
///
/// This service provides methods for managing user language preferences
/// with the server API.
library;

import 'package:powergodha/shared/api/api_models.dart';
import 'package:powergodha/shared/retrofit_client.dart';

/// {@template user_language_service}
/// Service for managing user language preferences with the server.
///
/// This service provides methods to:
/// * Update user language preference on the server
/// * Handle API responses and errors
/// * Provide a clean interface for language operations
/// {@endtemplate}
class UserLanguageService {
  /// {@macro user_language_service}
  UserLanguageService({
    RetrofitClient? apiClient,
  }) : _apiClient = apiClient ?? RetrofitClient();

  final RetrofitClient _apiClient;

  /// Updates the user's language preference on the server.
  ///
  /// **Parameters:**
  /// * [languageId] - The language ID to set (e.g., "1" for English, "2" for Hindi)
  ///
  /// **Returns:**
  /// * [Future<bool>] - true if the update was successful, false otherwise
  ///
  /// **Throws:**
  /// * [Exception] - if the API call fails or returns an error
  ///
  /// **Example:**
  /// ```dart
  /// final service = UserLanguageService();
  /// final success = await service.updateLanguage("2"); // Hindi
  /// if (success) {
  ///   print("Language updated successfully");
  /// }
  /// ```
  Future<bool> updateLanguage(String languageId) async {
    try {
      final request = UserLanguageUpdateRequest(languageId: languageId);
      final response = await _apiClient.updateUserLanguage(request.toJson());

      if (response.success) {
        return true;
      } else {
        throw Exception('Failed to update language: ${response.message}');
      }
    } catch (e) {
      throw Exception('Language update failed: $e');
    }
  }

  /// Updates the user's language preference on the server with detailed response.
  ///
  /// **Parameters:**
  /// * [languageId] - The language ID to set (e.g., "1" for English, "2" for Hindi)
  ///
  /// **Returns:**
  /// * [Future<ApiResponse>] - The complete API response
  ///
  /// **Example:**
  /// ```dart
  /// final service = UserLanguageService();
  /// final response = await service.updateLanguageWithResponse("2");
  /// if (response.success) {
  ///   print("Language updated: ${response.message}");
  /// }
  /// ```
  Future<ApiResponse> updateLanguageWithResponse(String languageId) async {
    final request = UserLanguageUpdateRequest(languageId: languageId);
    return _apiClient.updateUserLanguage(request.toJson());
  }

  /// Static method to quickly update language without creating an instance.
  ///
  /// **Parameters:**
  /// * [languageId] - The language ID to set
  ///
  /// **Returns:**
  /// * [Future<bool>] - true if successful, false otherwise
  ///
  /// **Example:**
  /// ```dart
  /// final success = await UserLanguageService.quickUpdateLanguage("2");
  /// ```
  static Future<bool> quickUpdateLanguage(String languageId) async {
    final service = UserLanguageService();
    return service.updateLanguage(languageId);
  }
}
