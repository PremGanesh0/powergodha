import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import 'models/auth_models.dart';

part 'auth_api_client.g.dart';

/// Client for interacting with authentication API endpoints.
///
/// This client handles all authentication-related operations including
/// login, signup, token refresh, and password reset. It uses the
/// centralized API configuration for consistent base URL and endpoints.
@RestApi()
abstract class AuthApiClient {
  /// Creates an instance of [AuthApiClient] using the provided [Dio] client.
  ///
  /// The base URL is configured through the [Dio] client's [BaseOptions],
  /// which should be set to use the centralized API configuration.
  factory AuthApiClient(Dio dio, {String baseUrl}) = _AuthApiClient;

  /// Attempts to log in with the provided credentials.
  ///
  /// **Endpoint:** POST /login
  @POST('/login')
  Future<LoginApiResponse> login(@Body() LoginRequest request);

  /// Refreshes an expired access token using a refresh token.
  ///
  /// **Endpoint:** POST /auth/refresh
  @POST('/auth/refresh')
  Future<AuthResponse> refreshToken(@Body() RefreshTokenRequest request);

  /// Request a password reset for the given email address.
  ///
  /// **Endpoint:** POST /auth/forgot-password
  @POST('/auth/forgot-password')
  @FormUrlEncoded()
  Future<void> requestPasswordReset(@Field('email') String email);

  /// Register a new user.
  ///
  /// **Endpoint:** POST /user_registration
  @POST('/user_registration')
  Future<RegistrationApiResponse> signup(@Body() SignupRequest request);

  /// Verify OTP for user registration.
  ///
  /// **Endpoint:** POST /verify_otp
  /// **Content-Type:** application/x-www-form-urlencoded
  @POST('/verify_otp')
  @FormUrlEncoded()
  Future<OtpVerificationResponse> verifyOtp(
    @Field('user_id') String userId,
    @Field('otp') String otp,
  );
}
