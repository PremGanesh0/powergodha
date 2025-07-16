/// Slider Articles Service
///
/// This service provides methods for managing slider articles from the API.
library;

import 'package:powergodha/shared/api/api_models.dart';
import 'package:powergodha/shared/retrofit/retrofit_client.dart';

/// {@template slider_articles_service}
/// Service for managing slider articles from the API.
///
/// This service provides methods to:
/// * Fetch slider articles by language ID
/// * Handle API responses and errors
/// * Provide a clean interface for slider operations
/// {@endtemplate}
class SliderArticlesService {
  /// {@macro slider_articles_service}
  SliderArticlesService({
    RetrofitClient? apiClient,
  }) : _apiClient = apiClient ?? RetrofitClient();

  final RetrofitClient _apiClient;

  /// Fetches slider articles for a specific language.
  ///
  /// **Parameters:**
  /// * [languageId] - The language ID to fetch articles for (e.g., "1" for English, "2" for Hindi)
  ///
  /// **Returns:**
  /// * [Future<List<SliderArticle>>] - List of slider articles
  ///
  /// **Throws:**
  /// * [Exception] - if the API call fails or returns an error
  ///
  /// **Example:**
  /// ```dart
  /// final service = SliderArticlesService();
  /// final articles = await service.getSliderArticles("2"); // Hindi articles
  /// ```
  Future<List<SliderArticle>> getSliderArticles(String languageId) async {
    try {
      final response = await _apiClient.getSliderArticles(languageId);

      if (response.success && response.data != null) {
        final articlesData = response.data as List<dynamic>;
        return articlesData
            .map((json) => SliderArticle.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to fetch slider articles: ${response.message}');
      }
    } catch (e) {
      throw Exception('Slider articles fetch failed: $e');
    }
  }

  /// Fetches slider articles with the full API response.
  ///
  /// **Parameters:**
  /// * [languageId] - The language ID to fetch articles for
  ///
  /// **Returns:**
  /// * [Future<ApiResponse>] - The complete API response
  ///
  /// **Example:**
  /// ```dart
  /// final service = SliderArticlesService();
  /// final response = await service.getSliderArticlesWithResponse("2");
  /// if (response.success) {
  ///   final articles = response.data;
  /// }
  /// ```
  Future<ApiResponse> getSliderArticlesWithResponse(String languageId) async {
    return _apiClient.getSliderArticles(languageId);
  }

  /// Static method to quickly fetch slider articles without creating an instance.
  ///
  /// **Parameters:**
  /// * [languageId] - The language ID to fetch articles for
  ///
  /// **Returns:**
  /// * [Future<List<SliderArticle>>] - List of slider articles
  ///
  /// **Example:**
  /// ```dart
  /// final articles = await SliderArticlesService.quickFetch("2");
  /// ```
  static Future<List<SliderArticle>> quickFetch(String languageId) async {
    final service = SliderArticlesService();
    return service.getSliderArticles(languageId);
  }
}
