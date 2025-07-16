/// Retrofit-style API Client
///
/// This file provides a Retrofit-style API client using the retrofit package
/// for type-safe API calls with automatic JSON serialization/deserialization.
library;

import 'package:dio/dio.dart';
import 'package:powergodha/shared/api/api_client.dart';
import 'package:powergodha/shared/api/api_endpoints.dart';
import 'package:powergodha/shared/api/api_models.dart';
import 'package:retrofit/retrofit.dart';

part 'retrofit_client.g.dart';

/// {@template retrofit_client}
/// Type-safe API client using Retrofit annotations.
///
/// This client provides a clean, type-safe interface for making API calls
/// with automatic JSON serialization and deserialization. It builds on top
/// of the shared [ApiClient] instance for consistency.
///
/// **Features:**
/// * Type-safe API method definitions
/// * Automatic JSON serialization/deserialization
/// * Integration with existing [ApiClient] configuration
/// * Consistent error handling and logging
/// {@endtemplate}
@RestApi()
abstract class RetrofitClient {
  /// Factory constructor that creates the client with the shared Dio instance.
  factory RetrofitClient({Dio? dio}) {
    return _RetrofitClient(dio ?? ApiClient.instance);
  }

  /// Change user password.
  @POST(ApiEndpoints.changePassword)
  Future<ApiResponse> changePassword(@Body() Map<String, String> passwordData,
  );

  /// Create a new animal.
  @POST(ApiEndpoints.createAnimal)
  Future<ApiResponse> createAnimal(@Body() Map<String, dynamic> animalData,
  );

  /// Create a new farm.
  @POST(ApiEndpoints.createFarm)
  Future<ApiResponse> createFarm(@Body() Map<String, dynamic> farmData,
  );

  /// Create a new record.
  @POST(ApiEndpoints.createRecord)
  Future<ApiResponse> createRecord(@Body() Map<String, dynamic> recordData,
  );

  /// Delete user account.
  @DELETE(ApiEndpoints.deleteAccount)
  Future<ApiResponse> deleteAccount();

  /// Delete an animal.
  @DELETE(ApiEndpoints.deleteAnimal)
  Future<ApiResponse> deleteAnimal(@Path('id') String animalId,
  );

  /// Delete a farm.
  @DELETE(ApiEndpoints.deleteFarm)
  Future<ApiResponse> deleteFarm(@Path('id') String farmId,
  );

  /// Delete a record.
  @DELETE(ApiEndpoints.deleteRecord)
  Future<ApiResponse> deleteRecord(@Path('id') String recordId,
  );

  // User profile endpoints

  /// Request password reset.
  @POST(ApiEndpoints.forgotPassword)
  Future<ApiResponse> forgotPassword(@Body() Map<String, String> emailData);

  /// Get about app data by language ID and type.
  @GET(ApiEndpoints.aboutAppData)
  Future<ApiResponse> getAboutAppData(
    @Path('language_id') String languageId,
    @Path('type') String type,
  );

  /// Get a specific animal by ID.
  @GET(ApiEndpoints.getAnimal)
  Future<ApiResponse> getAnimalById(@Path('id') String animalId,
  );


  /// Get detailed animal data based on animal type.
  @POST(ApiEndpoints.animalDetailsByType)
  Future<ApiResponse> getAnimalDetailsByType(@Body() Map<String, dynamic> requestData);

  /// Get detailed information about a specific animal type.
  @GET(ApiEndpoints.animalInfo)
  Future<ApiResponse> getAnimalInfo(@Path('animalId') int animalId,
  );

  /// Get dashboard data.
  @GET(ApiEndpoints.dashboard)
  Future<ApiResponse> getDashboard();

  // Farm management endpoints



  /// Get dashboard analytics.
  @GET(ApiEndpoints.dashboardAnalytics)
  Future<ApiResponse> getDashboardAnalytics(
    @Query('period') String? period,
    @Query('farm_id') String? farmId,
  );

  /// Get dashboard statistics.
  @GET(ApiEndpoints.dashboardStats)
  Future<ApiResponse> getDashboardStats();

  /// Get a specific farm by ID.
  @GET(ApiEndpoints.getFarm)
  Future<ApiResponse> getFarmById(
    @Path('id') String farmId,
  );

  /// get latest profit and loss report
  @GET(ApiEndpoints.lossReport)
  Future<ApiResponse> getLatestProfitLossReport();

  // Animal management endpoints

  /// Get notification count by language ID.
  @GET(ApiEndpoints.notificationCount)
  Future<ApiResponse> getNotificationCount(@Path('language_id') String languageId,
  );

  /// Get user profile information.
  @GET(ApiEndpoints.profile)
  Future<ApiResponse> getProfile();

  @GET(ApiEndpoints.profitableDiaryFarming)
  Future<ApiResponse> getProfitableDairyFarmingData();

  /// Get a specific record by ID.
  @GET(ApiEndpoints.getRecord)
  Future<ApiResponse> getRecordById(@Path('id') String recordId,
  );

  /// Get slider articles by language ID.
  @GET(ApiEndpoints.sliderArticles)
  Future<ApiResponse> getSliderArticles(@Path('language_id') String languageId);

  /// Get animal basic details question answer for a user/animal
  @GET(ApiEndpoints.userAnimalBasicDetailsQuestionAnswer)
  Future<ApiResponse> getUserAnimalBasicDetailsQuestionAnswer(
    @Path('animal_id') int animalId,
    @Path('animal_type_id') int animalTypeId,
    @Path('animal_number') String animalNumber,
  );

  /// Get user animal count information.
  @GET(ApiEndpoints.userAnimalCount)
  Future<ApiResponse> getUserAnimalCount();

  /// Authenticate user with email and password.
  @POST(ApiEndpoints.login)
  Future<ApiResponse> login(@Body() Map<String, dynamic> credentials,
  );

  // Records and reports endpoints

  /// Log out the current user.
  @POST(ApiEndpoints.logout)
  Future<ApiResponse> logout();

  /// Refresh the authentication token.
  @POST(ApiEndpoints.refreshToken)
  Future<ApiResponse> refreshToken(@Body() Map<String, String> refreshData,
  );

  /// Resend OTP code.
  @POST(ApiEndpoints.resendOtp)
  Future<ApiResponse> resendOtp(@Body() Map<String, String> phoneData,
  );

  /// Reset password with token.
  @POST(ApiEndpoints.resetPassword)
  Future<ApiResponse> resetPassword(@Body() Map<String, dynamic> resetData);

  // Dashboard endpoints

  /// Register a new user account.
  @POST(ApiEndpoints.signup)
  Future<ApiResponse> signup(@Body() Map<String, dynamic> userData,
  );

  // Authentication endpoints

  /// Submit animal question answers.
  @POST(ApiEndpoints.animalQuestionAnswer)
  Future<ApiResponse> submitAnimalQuestionAnswers(@Body() Map<String, dynamic> questionAnswerData);

  /// Update an animal.
  @PUT(ApiEndpoints.updateAnimal)
  Future<ApiResponse> updateAnimal(
    @Path('id') String animalId,
    @Body() Map<String, dynamic> animalData,
  );

  /// Update a farm.
  @PUT(ApiEndpoints.updateFarm)
  Future<ApiResponse> updateFarm(@Path('id') String farmId, @Body() Map<String, dynamic> farmData,
  );

  /// Update user profile.
  @PUT(ApiEndpoints.updateProfile)
  Future<ApiResponse> updateProfile(@Body() Map<String, dynamic> profileData,
  );

  /// Update a record.
  @PUT(ApiEndpoints.updateRecord)
  Future<ApiResponse> updateRecord(
    @Path('id') String recordId,
    @Body() Map<String, dynamic> recordData,
  );

/// Update user language preference.
  @PUT(ApiEndpoints.updateUserLanguage)
  Future<ApiResponse> updateUserLanguage(@Body() Map<String, dynamic> languageData,
  );

  /// Verify OTP code.
  @POST(ApiEndpoints.verifyOtp)
  Future<ApiResponse> verifyOtp(@Body() Map<String, dynamic> otpData,
  );

}
