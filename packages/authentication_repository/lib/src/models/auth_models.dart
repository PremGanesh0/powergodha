import 'package:json_annotation/json_annotation.dart';

part 'auth_models.g.dart';

@JsonSerializable()
class AuthResponse {
  @JsonKey(name: 'user_id')
  final int id;
  final String name;
  final String email;
  final String phone;
  @JsonKey(name: 'farm_name')
  final String farmName;
  @JsonKey(name: 'payment_status')
  final String paymentStatus;
  @JsonKey(name: 'plan_expires_on')
  final String? planExpiresOn;
  @JsonKey(name: 'otp_status')
  final bool otpStatus;
  final String token;

  const AuthResponse({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.farmName,
    required this.paymentStatus,
    required this.otpStatus,
    required this.token,
    this.planExpiresOn,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);
  String get accessToken => token;
  String get firstName => name;
  String get gender => '';
  String get image => '';
  String get lastName => '';
  String get refreshToken => token; // Using same token for both

  // Getters for backward compatibility
  String get username => phone;

  Map<String, dynamic> toJson() => _$AuthResponseToJson(this);
}

/// Complete API response wrapper for login
@JsonSerializable()
class LoginApiResponse {
  final AuthResponse data;
  final String message;
  final int status;

  const LoginApiResponse({required this.data, required this.message, required this.status});

  factory LoginApiResponse.fromJson(Map<String, dynamic> json) => _$LoginApiResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginApiResponseToJson(this);
}

@JsonSerializable()
class LoginRequest {
  @JsonKey(name: 'phone_number')
  final String phoneNumber;
  final String password;
  final int? expiresInMins;

  const LoginRequest({
    required this.phoneNumber,
    required this.password,
    this.expiresInMins,
  });

  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}

/// OTP verification request
@JsonSerializable()
class OtpVerificationRequest {
  @JsonKey(name: 'phone_number')
  final String phoneNumber;
  final String otp;
  @JsonKey(name: 'user_id')
  final int userId;

  const OtpVerificationRequest({
    required this.phoneNumber,
    required this.otp,
    required this.userId,
  });

  Map<String, dynamic> toJson() => _$OtpVerificationRequestToJson(this);
}

/// OTP verification response
@JsonSerializable()
class OtpVerificationResponse {
  final List<dynamic> data;
  final String message;
  final int status;

  const OtpVerificationResponse({required this.data, required this.message, required this.status});

  factory OtpVerificationResponse.fromJson(Map<String, dynamic> json) =>
      _$OtpVerificationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OtpVerificationResponseToJson(this);
}

@JsonSerializable()
class RefreshTokenRequest {
  final String refreshToken;

  const RefreshTokenRequest({required this.refreshToken});

  Map<String, dynamic> toJson() => _$RefreshTokenRequestToJson(this);
}

/// Complete API response wrapper for registration
@JsonSerializable()
class RegistrationApiResponse {
  final RegistrationResponse data;
  final String message;
  final int status;

  const RegistrationApiResponse({required this.data, required this.message, required this.status});

  factory RegistrationApiResponse.fromJson(Map<String, dynamic> json) =>
      _$RegistrationApiResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RegistrationApiResponseToJson(this);
}

/// Response from user registration API
@JsonSerializable()
class RegistrationResponse {
  final String otp;
  @JsonKey(name: 'user_id')
  final int userId;
  @JsonKey(name: 'sms_response')
  final String smsResponse;
  @JsonKey(name: 'phone_number')
  final String phoneNumber;

  const RegistrationResponse({
    required this.otp,
    required this.userId,
    required this.smsResponse,
    required this.phoneNumber,
  });

  factory RegistrationResponse.fromJson(Map<String, dynamic> json) =>
      _$RegistrationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RegistrationResponseToJson(this);
}

@JsonSerializable()
class SignupRequest {
  final String name;
  final String password;
  @JsonKey(name: 'phone_number')
  final String phoneNumber;

  const SignupRequest({
    required this.name,
    required this.password,
    required this.phoneNumber,
  });

  Map<String, dynamic> toJson() => _$SignupRequestToJson(this);
}

