/// Localization service for managing user language preferences.
///
/// This service handles:
/// * Storing and retrieving the user's selected language
/// * Providing default language fallback
/// * Managing SharedPreferences for persistence
/// * Supported locales configuration
library;

import 'dart:ui' as ui;

import 'package:shared_preferences/shared_preferences.dart';

/// {@template localization_service}
/// Service for managing user language preferences and locale settings.
///
/// This service provides:
/// * Language preference persistence using SharedPreferences
/// * Supported locale definitions
/// * Default language fallback logic
/// * Utility methods for language selection
///
/// **Supported Languages:**
/// * English (en)
/// * Hindi (hi)
/// * Telugu (te)
/// * Marathi (mr)
///
/// **Usage:**
/// ```dart
/// // Get current language
/// final locale = await LocalizationService.getCurrentLocale();
///
/// // Set new language
/// await LocalizationService.setLanguage('hi');
///
/// // Check if language is selected
/// final isSelected = await LocalizationService.isLanguageSelected();
/// ```
/// {@endtemplate}
class LocalizationService {
  /// Key for storing language preference in SharedPreferences
  static const String _languageKey = 'selected_language';

  /// List of supported locale codes
  static const List<String> supportedLanguages = ['en', 'hi', 'te', 'mr'];

  /// List of supported locales
  static const List<ui.Locale> supportedLocales = [
    ui.Locale('en', ''), // English
    ui.Locale('hi', ''), // Hindi
    ui.Locale('te', ''), // Telugu
    ui.Locale('mr', ''), // Marathi
  ];

  /// Default language code (English)
  static const String defaultLanguage = 'en';

  /// Clears the saved language preference.
  ///
  /// This will reset the language selection, causing the app to use
  /// the default language and show the language selection screen again.
  ///
  /// **Usage:**
  /// ```dart
  /// await LocalizationService.clearLanguage();
  /// // User will see language selection screen on next app start
  /// ```
  static Future<void> clearLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_languageKey);
  }

  /// Gets the current saved language preference.
  ///
  /// Returns the saved language code or [defaultLanguage] if none is saved.
  /// This method always returns a valid language code from [supportedLanguages].
  ///
  /// **Returns:**
  /// * String - The language code (e.g., 'en', 'hi', 'te', 'mr')
  /// * Always returns [defaultLanguage] if no preference is saved
  /// * Validates that the saved language is in [supportedLanguages]
  static Future<String> getCurrentLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLanguage = prefs.getString(_languageKey);

    // Return saved language if it's supported, otherwise return default
    if (savedLanguage != null && supportedLanguages.contains(savedLanguage)) {
      return savedLanguage;
    }
    return defaultLanguage;
  }

  /// Gets the current locale based on saved language preference.
  ///
  /// Returns a [ui.Locale] object for the current language setting.
  /// This is the primary method used by the app for localization.
  ///
  /// **Returns:**
  /// * [ui.Locale] - The locale object for the current language
  /// * Defaults to English locale if no preference is saved
  ///
  /// **Usage:**
  /// ```dart
  /// final locale = await LocalizationService.getCurrentLocale();
  /// // Use locale with MaterialApp or other localization widgets
  /// ```
  static Future<ui.Locale> getCurrentLocale() async {
    final languageCode = await getCurrentLanguage();
    return ui.Locale(languageCode, '');
  }

  /// Gets the display name for a language code.
  ///
  /// Returns the native name for each supported language.
  ///
  /// **Parameters:**
  /// * [languageCode] - The language code to get the display name for
  ///
  /// **Returns:**
  /// * [String] - The native display name for the language
  /// * Returns the language code itself if not recognized
  ///
  /// **Supported Mappings:**
  /// * 'en' → 'English'
  /// * 'hi' → 'हिंदी'
  /// * 'te' → 'తెలుగు'
  /// * 'mr' → 'मराठी'
  static String getLanguageDisplayName(String languageCode) {
    switch (languageCode) {
      case 'en':
        return 'English';
      case 'hi':
        return 'हिंदी';
      case 'te':
        return 'తెలుగు';
      case 'mr':
        return 'मराठी';
      default:
        return languageCode;
    }
  }

  /// Checks if the user has previously selected a language.
  ///
  /// This is useful for determining whether to show the language selection
  /// screen on app startup.
  ///
  /// **Returns:**
  /// * [bool] - true if a language preference exists, false otherwise
  ///
  /// **Usage:**
  /// ```dart
  /// if (await LocalizationService.isLanguageSelected()) {
  ///   // Skip language selection screen
  /// } else {
  ///   // Show language selection screen
  /// }
  /// ```
  static Future<bool> isLanguageSelected() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_languageKey);
  }

  /// Sets the user's language preference.
  ///
  /// Saves the selected language to SharedPreferences for persistence.
  /// Only accepts language codes that are in [supportedLanguages].
  ///
  /// **Parameters:**
  /// * [languageCode] - Must be one of: 'en', 'hi', 'te', 'mr'
  ///
  /// **Throws:**
  /// * [ArgumentError] if the language code is not supported
  ///
  /// **Usage:**
  /// ```dart
  /// await LocalizationService.setLanguage('hi'); // Set to Hindi
  /// ```
  static Future<void> setLanguage(String languageCode) async {
    if (!supportedLanguages.contains(languageCode)) {
      throw ArgumentError(
        'Unsupported language: $languageCode. '
        'Supported languages: $supportedLanguages',
      );
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, languageCode);
  }
}
