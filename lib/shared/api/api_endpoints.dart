/// API Endpoints Configuration
///
/// This file contains all the API endpoint constants used throughout the application.
/// Centralizing endpoints here makes it easier to maintain and update API paths.
///
/// **Benefits:**
/// * Single source of truth for all API endpoints
/// * Easy to maintain and update
/// * Eliminates hardcoded paths in API clients
/// * Type-safe endpoint access
///
/// **Usage:**
/// ```dart
/// // Access endpoints
/// final loginEndpoint = ApiEndpoints.login;
/// final signupEndpoint = ApiEndpoints.signup;
/// ```
library;

/// {@template api_endpoints}
/// Centralized API endpoints configuration.
///
/// This class contains all the API endpoint paths as constants.
/// All endpoints are defined as static constants to ensure
/// compile-time safety and easy maintenance.
/// {@endtemplate}
class ApiEndpoints {
  /// Private constructor to prevent instantiation.
  const ApiEndpoints._();
  /// Gets animal basic details question answer for a user/animal
  static const String userAnimalBasicDetailsQuestionAnswer =
      '/user_animal_basic_details_question_answer/{animal_id}/{animal_type_id}/{animal_number}';

  // Authentication endpoints
  static const String login = '/auth/login';
  static const String signup = '/auth/register';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String verifyOtp = '/auth/verify-otp';
  static const String resendOtp = '/auth/resend-otp';

  // User profile endpoints
  static const String profile = '/user/profile';
  static const String updateProfile = '/user/profile';
  static const String changePassword = '/user/change-password';
  static const String deleteAccount = '/user/delete-account';
  static const String updateUserLanguage = '/user_language';

  // Farm management endpoints
  static const String farms = '/farms';
  static const String createFarm = '/farms';
  static const String getFarm = '/farms/{id}';
  static const String updateFarm = '/farms/{id}';
  static const String deleteFarm = '/farms/{id}';

  // Animal management endpoints
  static const String animals = '/animals';
  static const String createAnimal = '/animals';
  static const String getAnimal = '/animals/{id}';
  static const String updateAnimal = '/animals/{id}';
  static const String deleteAnimal = '/animals/{id}';
  static const String userAnimalCount = '/user_animal_count';
  static const String animalInfo = '/animal_info/{animalId}';
  static const String animalDetailsByType = '/animal_details_based_on_animal_type';

  // Records and reports endpoints
  static const String records = '/records';
  static const String createRecord = '/records';
  static const String getRecord = '/records/{id}';
  static const String updateRecord = '/records/{id}';
  static const String deleteRecord = '/records/{id}';
  static const String reports = '/reports';
  static const String getReport = '/reports/{id}';
  static const String lossReport = '/latest_profit_loss_report';

  // Dashboard endpoints
  static const String dashboard = '/dashboard';
  static const String dashboardStats = '/dashboard/stats';
  static const String dashboardAnalytics = '/dashboard/analytics';

  // Content endpoints
  static const String sliderArticles = '/slider_article/{language_id}';
  static const String notificationCount = '/notification_count/{language_id}';
  static const String aboutAppData = '/about_app_data/{language_id}/{type}';

  // Animal question answer endpoint
  static const String animalQuestionAnswer = '/animal_question_answer';
  //Bottom Navigation Buttons endpoints
  static const String profitableDiaryFarming = '/profitable_farming_article/1/2';

  // Utility methods for dynamic endpoints

  /// Builds an about app data endpoint with the language ID and type.
  static String getAboutAppDataEndpoint(String languageId, String type) =>
      aboutAppData.replaceAll('{language_id}', languageId).replaceAll('{type}', type);

  /// Builds an animal-specific endpoint with the animal ID.
  static String getAnimalEndpoint(String animalId) => getAnimal.replaceAll('{id}', animalId);

  /// Builds an animal info endpoint with the animal ID.
  static String getAnimalInfoEndpoint(String animalId) => animalInfo.replaceAll('{animalId}', animalId);

  /// Builds a farm-specific endpoint with the farm ID.
  static String getFarmEndpoint(String farmId) => getFarm.replaceAll('{id}', farmId);

  /// Builds a notification count endpoint with the language ID.
  static String getNotificationCountEndpoint(String languageId) =>
      notificationCount.replaceAll('{language_id}', languageId);

  /// Builds a record-specific endpoint with the record ID.
  static String getRecordEndpoint(String recordId) => getRecord.replaceAll('{id}', recordId);

  /// Builds a report-specific endpoint with the report ID.
  static String getReportEndpoint(String reportId) => getReport.replaceAll('{id}', reportId);

  /// Builds a slider articles endpoint with the language ID.
  static String getSliderArticlesEndpoint(String languageId) =>
      sliderArticles.replaceAll('{language_id}', languageId);
}
