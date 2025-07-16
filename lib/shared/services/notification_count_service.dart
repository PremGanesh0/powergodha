/// Notification Count Service
///
/// This service provides methods for managing notification count from the API.
library;

import 'package:powergodha/shared/api/api_models.dart';
import 'package:powergodha/shared/retrofit/retrofit_client.dart';

/// {@template notification_count_service}
/// Service for managing notification count from the API.
///
/// This service provides methods to:
/// * Fetch notification count by language ID
/// * Handle API responses and errors
/// * Provide a clean interface for notification operations
/// {@endtemplate}
class NotificationCountService {
  /// {@macro notification_count_service}
  NotificationCountService({
    RetrofitClient? apiClient,
  }) : _apiClient = apiClient ?? RetrofitClient();

  final RetrofitClient _apiClient;

  /// Fetches notification count for a specific language.
  ///
  /// **Parameters:**
  /// * [languageId] - The language ID to fetch count for (e.g., "1" for English, "2" for Hindi)
  ///
  /// **Returns:**
  /// * [Future<NotificationCount>] - Notification count object
  ///
  /// **Throws:**
  /// * [Exception] - if the API call fails or returns an error
  ///
  /// **Example:**
  /// ```dart
  /// final service = NotificationCountService();
  /// final notificationCount = await service.getNotificationCount("2"); // Hindi
  /// print('Unread notifications: ${notificationCount.count}');
  /// ```
  Future<NotificationCount> getNotificationCount(String languageId) async {
    try {
      final response = await _apiClient.getNotificationCount(languageId);

      if (response.success && response.data != null) {
        final countData = response.data as Map<String, dynamic>;
        return NotificationCount.fromJson(countData);
      } else {
        throw Exception('Failed to fetch notification count: ${response.message}');
      }
    } catch (e) {
      throw Exception('Notification count fetch failed: $e');
    }
  }

  /// Fetches notification count with the full API response.
  ///
  /// **Parameters:**
  /// * [languageId] - The language ID to fetch count for
  ///
  /// **Returns:**
  /// * [Future<ApiResponse>] - The complete API response
  ///
  /// **Example:**
  /// ```dart
  /// final service = NotificationCountService();
  /// final response = await service.getNotificationCountWithResponse("2");
  /// if (response.success) {
  ///   final countData = response.data;
  /// }
  /// ```
  Future<ApiResponse> getNotificationCountWithResponse(String languageId) async {
    return _apiClient.getNotificationCount(languageId);
  }

  /// Gets just the count value as an integer.
  ///
  /// **Parameters:**
  /// * [languageId] - The language ID to fetch count for
  ///
  /// **Returns:**
  /// * [Future<int>] - The notification count as an integer
  ///
  /// **Example:**
  /// ```dart
  /// final service = NotificationCountService();
  /// final count = await service.getCountValue("2");
  /// if (count > 0) {
  ///   // Show notification badge
  /// }
  /// ```
  Future<int> getCountValue(String languageId) async {
    try {
      final notificationCount = await getNotificationCount(languageId);
      return notificationCount.count;
    } catch (e) {
      // Return 0 on error to avoid breaking UI
      print('Error fetching notification count: $e');
      return 0;
    }
  }

  /// Static method to quickly fetch notification count without creating an instance.
  ///
  /// **Parameters:**
  /// * [languageId] - The language ID to fetch count for
  ///
  /// **Returns:**
  /// * [Future<NotificationCount>] - Notification count object
  ///
  /// **Example:**
  /// ```dart
  /// final count = await NotificationCountService.quickFetch("2");
  /// ```
  static Future<NotificationCount> quickFetch(String languageId) async {
    final service = NotificationCountService();
    return service.getNotificationCount(languageId);
  }

  /// Static method to quickly get just the count value.
  ///
  /// **Parameters:**
  /// * [languageId] - The language ID to fetch count for
  ///
  /// **Returns:**
  /// * [Future<int>] - The notification count as an integer
  ///
  /// **Example:**
  /// ```dart
  /// final count = await NotificationCountService.quickCount("2");
  /// ```
  static Future<int> quickCount(String languageId) async {
    final service = NotificationCountService();
    return service.getCountValue(languageId);
  }
}
