/// Simple About App Data Service
///
/// This service provides simple methods to fetch about app data content
/// without complex state management - perfect for static content pages.
library;

import 'package:powergodha/shared/api/api_models.dart';
import 'package:powergodha/shared/localization_service.dart';
import 'package:powergodha/shared/retrofit/retrofit_client.dart';

/// {@template about_app_data_service}
/// Simple service for fetching about app data content.
///
/// This service provides straightforward methods to fetch different types
/// of app content like about us, contact us, etc. It's designed to be used
/// with FutureBuilder for simple, stateless content display.
///
/// **Usage:**
/// ```dart
/// final service = AboutAppDataService();
/// final aboutUs = await service.getAboutUs();
/// ```
/// {@endtemplate}
class AboutAppDataService {
  /// {@macro about_app_data_service}
  AboutAppDataService({
    RetrofitClient? client,
  }) : _client = client ?? RetrofitClient();

  final RetrofitClient _client;

  /// Gets about app content using current language.
  Future<AboutAppData> getAboutApp() async {
    return getAboutAppData('about_app');
  }

  /// Gets about app data for a specific type using current language.
  ///
  /// **Parameters:**
  /// - [type]: The type of content (e.g., 'about_us', 'contact_us')
  ///
  /// **Returns:**
  /// A [AboutAppData] object containing the content.
  ///
  /// **Throws:**
  /// - [Exception] if the API call fails or returns an error.
  Future<AboutAppData> getAboutAppData(String type) async {
    try {
      // Get current language and convert to language ID
      final currentLanguage = await LocalizationService.getCurrentLanguage();
      final languageId = _getLanguageId(currentLanguage);

      final response = await _client.getAboutAppData(languageId, type);

      if (response.success && response.data != null) {
        final dataList = response.data as List<dynamic>;
        if (dataList.isNotEmpty) {
          final data = dataList.first as Map<String, dynamic>;
          return AboutAppData.fromJson(data);
        } else {
          throw Exception('No data found for type: $type');
        }
      } else {
        throw Exception('Failed to get about app data: ${response.message}');
      }
    } catch (e) {
      throw Exception('About app data API call failed: $e');
    }
  }

  /// Gets about us content using current language.
  Future<AboutAppData> getAboutUs() async {
    return getAboutAppData('about_us');
  }


  /// Gets privacy policy content using current language.
  Future<AboutAppData> getPrivacyPolicy() async {
    return getAboutAppData('privacy_policy');
  }

  /// Gets terms and conditions content using current language.
  Future<AboutAppData> getTermsAndConditions() async {
    return getAboutAppData('terms_and_conditions');
  }

  /// Helper method to get language ID from language code
  String _getLanguageId(String languageCode) {
    switch (languageCode) {
      case 'en':
        return '1';
      case 'hi':
        return '2';
      case 'te':
        return '3';
      case 'mr':
        return '4';
      default:
        return '2'; // Default to Hindi
    }
  }
}


/// {@template about_app_data}
/// Model for about app data response.
///
/// This model represents the structure of the about app data API response,
/// which includes various types of content like 'about_us', 'contact_us', etc.
/// {@endtemplate}
class AboutAppData {
  /// Creates an [AboutAppData] instance.
  const AboutAppData({required this.type, required this.languageId, required this.content});

  /// Factory constructor for JSON deserialization.
  factory AboutAppData.fromJson(Map<String, dynamic> json) {
    return AboutAppData(
      type: json['type'] as String? ?? '',
      languageId: json['language_id'] as int? ?? 0,
      content: json['content'] as String? ?? '',
    );
  }

  /// The type of content (e.g., 'about_us', 'contact_us').
  final String type;

  /// The language ID for the content.
  final int languageId;

  /// The HTML content.
  final String content;

  @override
  int get hashCode => type.hashCode ^ languageId.hashCode ^ content.hashCode;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AboutAppData &&
        other.type == type &&
        other.languageId == languageId &&
        other.content == content;
  }

  /// Converts the instance to JSON.
  Map<String, dynamic> toJson() {
    return {'type': type, 'language_id': languageId, 'content': content};
  }

  @override
  String toString() {
    return 'AboutAppData(type: $type, languageId: $languageId, content: ${content.substring(0, content.length > 50 ? 50 : content.length)}...)';
  }
}
