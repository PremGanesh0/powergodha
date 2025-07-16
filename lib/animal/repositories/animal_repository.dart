import 'package:authentication_repository/authentication_repository.dart';
import 'package:dio/dio.dart';
import 'package:powergodha/animal/models/animal_basic_details_data.dart';
import 'package:powergodha/animal/models/animal_count_response.dart';
import 'package:powergodha/animal/models/animal_details_response.dart';
import 'package:powergodha/animal/models/animal_info_response.dart';
import 'package:powergodha/app/app_logger_config.dart';
import 'package:powergodha/shared/api/api_models.dart';
import 'package:powergodha/shared/retrofit/retrofit_client.dart';

/// Repository for managing animal-related data operations.
///
/// This repository handles animal count data and other animal-related
/// operations by integrating with the animal API endpoints.
class AnimalRepository {
  /// Creates an [AnimalRepository] instance.
  ///
  /// **Parameters:**
  /// * [authenticationRepository] - Repository for authentication operations
  /// * [dio] - HTTP client for making API requests
  AnimalRepository({required AuthenticationRepository authenticationRepository, required Dio dio})
    : _authenticationRepository = authenticationRepository,
      _apiClient = RetrofitClient(dio: dio);

  final AuthenticationRepository _authenticationRepository;
  final RetrofitClient _apiClient;

  /// Gets detailed animal data based on animal type.
  ///
  /// This method fetches detailed information about animals of a specific type
  /// from the API endpoint `/animal_details_based_on_animal_type`.
  ///
  /// **Authentication Required:** Yes
  ///
  /// **Parameters:**
  /// * [animalId] - The ID of the animal type (1=Cow, 2=Buffalo, 3=Goat, 4=Hen)
  /// * [animalType] - The type of animal (e.g., "cow", "buffalo", "goat", "hen")
  ///
  /// **Returns:**
  /// A [AnimalDetailsResponse] containing detailed animal information.
  ///
  /// **Throws:**
  /// * [AnimalRepositoryException] if the request fails or user is not authenticated
  Future<AnimalDetailsResponse> getAnimalDetailsByType({
    required int animalId,
    required String animalType,
  }) async {
    try {
      final accessToken = _authenticationRepository.currentAccessToken;

      if (accessToken == null) {
        throw const AnimalRepositoryException('No access token available');
      }

      // Call the API to get animal details
      final requestData = {'animal_id': animalId.toString(), 'type': animalType.toLowerCase()};

      final apiResponse = await _apiClient.getAnimalDetailsByType(requestData);

      // Log response for debugging
      AppLogger.info('Animal Details API Response Data Type: ${apiResponse.data.runtimeType}');
      AppLogger.info('Animal Details API Response Data: ${apiResponse.data}');

      // Parse the response - handle different response structures
      if (apiResponse.data == null) {
        // Handle null response - return empty response
        return AnimalDetailsResponse(
          data: AnimalDetailsData(
            animalName: animalType,
            pregnantAnimal: 0,
            nonPregnantAnimal: 0,
            lactating: 0,
            nonLactating: 0,
            animalData: [],
          ),
          message: apiResponse.message.isEmpty ? 'No data available' : apiResponse.message,
          status: apiResponse.status,
        );
      } else if (apiResponse.data is Map<String, dynamic>) {
        final dataMap = apiResponse.data as Map<String, dynamic>;

        try {
          // Check if this is the direct response with animal_data
          if (dataMap.containsKey('animal_data') && dataMap['animal_data'] is List) {
            final animalDataList = dataMap['animal_data'] as List<dynamic>;
            final individualAnimals = animalDataList
                .map((item) => IndividualAnimalData.fromJson(item as Map<String, dynamic>))
                .toList();

            // Calculate summary statistics from the individual animals
            var pregnantCount = 0;
            var lactatingCount = 0;

            for (final animal in individualAnimals) {
              if (animal.pregnancyStatus != null && animal.pregnancyStatus!.isNotEmpty) {
                pregnantCount++;
              }
              if (animal.lactationStatus != null && animal.lactationStatus!.isNotEmpty) {
                lactatingCount++;
              }
            }

            final animalDetailsData = AnimalDetailsData(
              animalName: animalType,
              pregnantAnimal: pregnantCount,
              nonPregnantAnimal: individualAnimals.length - pregnantCount,
              lactating: lactatingCount,
              nonLactating: individualAnimals.length - lactatingCount,
              animalData: individualAnimals,
            );

            return AnimalDetailsResponse(
              data: animalDetailsData,
              message: apiResponse.message,
              status: apiResponse.status,
            );
          }

          // Check if this is the full response structure
          if (dataMap.containsKey('data') &&
              dataMap.containsKey('message') &&
              dataMap.containsKey('status')) {
            // This is the full response structure
            final animalDetailsResponse = AnimalDetailsResponse.fromJson(dataMap);
            return animalDetailsResponse;
          } else {
            // This might be just the data part, wrap it in the expected structure
            final animalDetailsResponse = AnimalDetailsResponse(
              data: AnimalDetailsData.fromJson(dataMap),
              message: apiResponse.message,
              status: apiResponse.status,
            );
            return animalDetailsResponse;
          }
        } catch (jsonError) {
          // If JSON parsing fails, log the error and return empty response
          AppLogger.error('Failed to parse animal details JSON: $jsonError');
          AppLogger.error('Raw response data: $dataMap');
          return AnimalDetailsResponse(
            data: AnimalDetailsData(
              animalName: animalType,
              pregnantAnimal: 0,
              nonPregnantAnimal: 0,
              lactating: 0,
              nonLactating: 0,
              animalData: [],
            ),
            message: 'Failed to parse response data',
            status: apiResponse.status,
          );
        }
      } else {
        AppLogger.error(
          'Unexpected response format: ${apiResponse.data.runtimeType}, data: ${apiResponse.data}',
        );
        return AnimalDetailsResponse(
          data: AnimalDetailsData(
            animalName: animalType,
            pregnantAnimal: 0,
            nonPregnantAnimal: 0,
            lactating: 0,
            nonLactating: 0,
            animalData: [],
          ),
          message: 'Unexpected response format',
          status: apiResponse.status,
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw const AnimalRepositoryException('Authentication failed - token expired');
      }
      throw AnimalRepositoryException(
        'Failed to fetch animal details: ${e.message ?? "Unknown error"}',
      );
    } catch (e) {
      throw AnimalRepositoryException('Failed to fetch animal details: $e');
    }
  }

  /// Gets detailed information about a specific animal type.
  ///
  /// This method fetches detailed information about a specific animal type
  /// from the API endpoint `/animal_info/{animalId}`.
  ///
  /// **Authentication Required:** Yes
  ///
  /// **Parameters:**
  /// * [animalId] - The ID of the animal type (1=Cow, 2=Buffalo, 3=Goat, 4=Hen)
  ///
  /// **Returns:**
  /// A [AnimalInfoResponse] containing detailed animal information.
  ///
  /// **Throws:**
  /// * [AnimalRepositoryException] if the request fails or user is not authenticated
  Future<AnimalInfoResponse> getAnimalInfo(int animalId) async {
    try {
      final accessToken = _authenticationRepository.currentAccessToken;

      if (accessToken == null) {
        throw const AnimalRepositoryException('No access token available');
      }

      // Call the API to get animal info
      final apiResponse = await _apiClient.getAnimalInfo(animalId);

      // Parse the response - handle different response structures
      if (apiResponse.data is Map<String, dynamic>) {
        final dataMap = apiResponse.data as Map<String, dynamic>;
        if (dataMap.containsKey('data') && dataMap['data'] is List) {
          // The API returns a structure like: {data: [...], message: "Success", status: 200}
          final animalInfoData = (dataMap['data'] as List<dynamic>)
              .map((item) => AnimalInfoData.fromJson(item as Map<String, dynamic>))
              .toList();

          final animalInfoResponse = AnimalInfoResponse(
            data: animalInfoData,
            message: dataMap['message'] as String? ?? apiResponse.message,
            status: dataMap['status'] as int? ?? apiResponse.status,
          );

          return animalInfoResponse;
        } else {
          // Direct object response - try to parse as AnimalInfoResponse
          final animalInfoResponse = AnimalInfoResponse.fromJson(dataMap);
          return animalInfoResponse;
        }
      } else if (apiResponse.data is List) {
        // Direct list response
        final animalInfoData = (apiResponse.data as List<dynamic>)
            .map((item) => AnimalInfoData.fromJson(item as Map<String, dynamic>))
            .toList();

        final animalInfoResponse = AnimalInfoResponse(
          data: animalInfoData,
          message: apiResponse.message,
          status: apiResponse.status,
        );

        return animalInfoResponse;
      } else {
        throw AnimalRepositoryException(
          'Unexpected response format: ${apiResponse.data.runtimeType}',
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw const AnimalRepositoryException('Authentication failed - token expired');
      }
      throw AnimalRepositoryException(
        'Failed to fetch animal info: ${e.message ?? "Unknown error"}',
      );
    } catch (e) {
      throw AnimalRepositoryException('Failed to fetch animal info: $e');
    }
  }

  /// Gets animal basic details question answer for a user/animal.
  ///
  /// [animalId] - The animal's ID
  /// [animalTypeId] - The animal type ID
  /// [animalNumber] - The animal number
  Future<AnimalBasicDetailsData> getUserAnimalBasicDetailsQuestionAnswer({
    required int animalId,
    required int languageId,
    required String animalNumber,
  }) async {
    try {
      final accessToken = _authenticationRepository.currentAccessToken;
      if (accessToken == null) {
        throw const AnimalRepositoryException('No access token available');
      }

      final response = await _apiClient.getUserAnimalBasicDetailsQuestionAnswer(
        animalId,
        languageId,
        animalNumber,
      );
      AppLogger.info('Animal basic details Q&A response: ${response.data}');
      try {
        final sectionKey = response.data.keys.first;
print('Section key: $sectionKey');
        return AnimalBasicDetailsData.fromJson(response.data[sectionKey] as Map<String, dynamic>);
      } catch (e) {
        try {
          return AnimalBasicDetailsData.fromJson(
            response.data['मूल विवरण'] as Map<String, dynamic>,
          );
        } catch (e) {
          AppLogger.error('Failed to parse animal basic details Q&A: $e');
          throw AnimalRepositoryException('Failed to parse animal basic details Q&A: $e');
        }
      }

    } on DioException catch (e) {
      AppLogger.error('Failed to fetch animal basic details Q&A: ${e.message}');
      throw AnimalRepositoryException(
        'Failed to fetch animal basic details Q&A: ${e.message ?? "Unknown error"}',
      );
    } catch (e) {
      AppLogger.error('Unexpected error in getUserAnimalBasicDetailsQuestionAnswer: $e');
      throw AnimalRepositoryException('Failed to fetch animal basic details Q&A: $e');
    }
  }

  /// Gets the current user's animal count information.
  ///
  /// This method fetches the count of different animals owned by the user
  /// from the API endpoint `/user_animal_count`.
  ///
  /// **Authentication Required:** Yes
  ///
  /// **Returns:**
  /// A [AnimalCountResponse] containing the list of animal counts.
  ///
  /// **Throws:**
  /// * [AnimalRepositoryException] if the request fails or user is not authenticated
  Future<AnimalCountResponse> getUserAnimalCount() async {
    try {
      final accessToken = _authenticationRepository.currentAccessToken;

      if (accessToken == null) {
        throw const AnimalRepositoryException('No access token available');
      }

      // Call the API to get user animal count
      final apiResponse = await _apiClient.getUserAnimalCount();

      // Parse the response - the API returns a list of animal count objects
      List<AnimalCountData> animalCountData;

      if (apiResponse.data is List) {
        // Direct list response
        animalCountData = (apiResponse.data as List<dynamic>)
            .map((item) => AnimalCountData.fromJson(item as Map<String, dynamic>))
            .toList();
      } else if (apiResponse.data is Map<String, dynamic>) {
        final dataMap = apiResponse.data as Map<String, dynamic>;
        if (dataMap.containsKey('data') && dataMap['data'] is List) {
          // Nested data structure
          animalCountData = (dataMap['data'] as List<dynamic>)
              .map((item) => AnimalCountData.fromJson(item as Map<String, dynamic>))
              .toList();
        } else {
          // Single object response - try to parse as AnimalCountResponse
          final response = AnimalCountResponse.fromJson(dataMap);
          return response;
        }
      } else {
        throw AnimalRepositoryException(
          'Unexpected response format: ${apiResponse.data.runtimeType}',
        );
      }

      // Create the response object
      final animalCountResponse = AnimalCountResponse(
        data: animalCountData,
        message: apiResponse.message,
        status: apiResponse.status,
      );

      return animalCountResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw const AnimalRepositoryException('Authentication failed - token expired');
      }
      throw AnimalRepositoryException(
        'Failed to fetch animal count: ${e.message ?? "Unknown error"}',
      );
    } catch (e) {
      throw AnimalRepositoryException('Failed to fetch animal count: $e');
    }
  }

  /// Submits animal question answers to the API.
  ///
  /// **Parameters:**
  /// * [questionAnswerData] - The payload containing animal_id, animal_number, and answers array
  ///
  /// **Returns:**
  /// An [ApiResponse] containing the server response.
  Future<ApiResponse> submitAnimalQuestionAnswers(Map<String, dynamic> questionAnswerData) async {
    try {
      final accessToken = _authenticationRepository.currentAccessToken;
      if (accessToken == null) {
        throw const AnimalRepositoryException('No access token available');
      }

      // Convert any AnimalType enums to their API representation
      final sanitizedData = Map<String, dynamic>.from(questionAnswerData);





      // Log the sanitized request payload for debugging
      AppLogger.info('Submitting animal question answers with data: $sanitizedData');

      final response = await _apiClient.submitAnimalQuestionAnswers(sanitizedData);

      // Log the response for debugging
      AppLogger.info('Animal question answers response: ${response.data}');

      if (!response.success) {
        throw AnimalRepositoryException('Server returned error: ${response.message}');
      }

      return response;
    } on DioException catch (e) {
      AppLogger.error(
        'Failed to submit animal answers - DioError: ${e.message}\n'
        'Status code: ${e.response?.statusCode}\n'
        'Response data: ${e.response?.data}',
      );

      if (e.response?.statusCode == 401) {
        throw const AnimalRepositoryException('Authentication failed - token expired');
      }

      var errorMessage = 'Network error';
      if (e.response?.data != null && e.response?.data is Map) {
        errorMessage =
            (e.response?.data as Map)['message']?.toString() ?? e.message ?? 'Unknown error';
      }

      throw AnimalRepositoryException('Failed to submit animal question answers: $errorMessage');
    } catch (e) {
      AppLogger.error('Unexpected error in submitAnimalQuestionAnswers: $e');
      throw AnimalRepositoryException('Failed to submit animal question answers: $e');
    }
  }
}

/// Exception thrown when animal repository operations fail.
class AnimalRepositoryException implements Exception {
  /// Creates a new animal repository exception with the specified message.
  const AnimalRepositoryException(this.message);

  /// The error message describing what went wrong.
  final String message;

  @override
  String toString() => 'AnimalRepositoryException: $message';
}
