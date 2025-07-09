import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'user_api_client.g.dart';

/// Client for interacting with user-related API endpoints.
///
/// This API client handles all user data operations including
/// fetching user profiles, updating user information, and
/// managing user-related data. It uses the centralized API
/// configuration for consistent base URL and endpoints.
@RestApi()
abstract class UserApiClient {
  /// Creates an instance of [UserApiClient] using the provided [Dio] client.
  ///
  /// The base URL is configured through the [Dio] client's [BaseOptions],
  /// which should be set to use the centralized API configuration.
  factory UserApiClient(Dio dio, {String baseUrl}) = _UserApiClient;

  /// Gets the current user's information by user ID.
  ///
  /// Requires a valid authentication token in the format "Bearer <token>".
  ///
  /// **Endpoint:** GET /get_user_by_id/{userId}
  /// **Parameters:**
  /// * [userId] - The user's ID
  /// * [token] - The authorization header with Bearer token
  ///
  /// **Returns:**
  /// A raw Map response containing the user's profile information.
  ///
  /// **Throws:**
  /// * [DioException] if the request fails or token is invalid
  @GET('/get_user_by_id/{userId}')
  Future<Map<String, dynamic>> getCurrentUser(
    @Path('userId') int userId,
    @Header('Authorization') String token,
  );
}
