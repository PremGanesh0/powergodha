// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthResponse _$AuthResponseFromJson(Map<String, dynamic> json) => AuthResponse(
      id: (json['user_id'] as num).toInt(),
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      farmName: json['farm_name'] as String,
      paymentStatus: json['payment_status'] as String,
      otpStatus: json['otp_status'] as bool,
      token: json['token'] as String,
      planExpiresOn: json['plan_expires_on'] as String?,
    );

Map<String, dynamic> _$AuthResponseToJson(AuthResponse instance) =>
    <String, dynamic>{
      'user_id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
      'farm_name': instance.farmName,
      'payment_status': instance.paymentStatus,
      'plan_expires_on': instance.planExpiresOn,
      'otp_status': instance.otpStatus,
      'token': instance.token,
    };

LoginRequest _$LoginRequestFromJson(Map<String, dynamic> json) => LoginRequest(
      phoneNumber: json['phone_number'] as String,
      password: json['password'] as String,
      expiresInMins: (json['expiresInMins'] as num?)?.toInt(),
    );

Map<String, dynamic> _$LoginRequestToJson(LoginRequest instance) =>
    <String, dynamic>{
      'phone_number': instance.phoneNumber,
      'password': instance.password,
      'expiresInMins': instance.expiresInMins,
    };

OtpVerificationRequest _$OtpVerificationRequestFromJson(
        Map<String, dynamic> json) =>
    OtpVerificationRequest(
      phoneNumber: json['phone_number'] as String,
      otp: json['otp'] as String,
      userId: (json['user_id'] as num).toInt(),
    );

Map<String, dynamic> _$OtpVerificationRequestToJson(
        OtpVerificationRequest instance) =>
    <String, dynamic>{
      'phone_number': instance.phoneNumber,
      'otp': instance.otp,
      'user_id': instance.userId,
    };

OtpVerificationResponse _$OtpVerificationResponseFromJson(
        Map<String, dynamic> json) =>
    OtpVerificationResponse(
      data: json['data'] as List<dynamic>,
      message: json['message'] as String,
      status: (json['status'] as num).toInt(),
    );

Map<String, dynamic> _$OtpVerificationResponseToJson(
        OtpVerificationResponse instance) =>
    <String, dynamic>{
      'data': instance.data,
      'message': instance.message,
      'status': instance.status,
    };

RefreshTokenRequest _$RefreshTokenRequestFromJson(Map<String, dynamic> json) =>
    RefreshTokenRequest(
      refreshToken: json['refreshToken'] as String,
    );

Map<String, dynamic> _$RefreshTokenRequestToJson(
        RefreshTokenRequest instance) =>
    <String, dynamic>{
      'refreshToken': instance.refreshToken,
    };

RegistrationApiResponse _$RegistrationApiResponseFromJson(
        Map<String, dynamic> json) =>
    RegistrationApiResponse(
      data: RegistrationResponse.fromJson(json['data'] as Map<String, dynamic>),
      message: json['message'] as String,
      status: (json['status'] as num).toInt(),
    );

Map<String, dynamic> _$RegistrationApiResponseToJson(
        RegistrationApiResponse instance) =>
    <String, dynamic>{
      'data': instance.data,
      'message': instance.message,
      'status': instance.status,
    };

RegistrationResponse _$RegistrationResponseFromJson(
        Map<String, dynamic> json) =>
    RegistrationResponse(
      otp: json['otp'] as String,
      userId: (json['user_id'] as num).toInt(),
      smsResponse: json['sms_response'] as String,
      phoneNumber: json['phone_number'] as String,
    );

Map<String, dynamic> _$RegistrationResponseToJson(
        RegistrationResponse instance) =>
    <String, dynamic>{
      'otp': instance.otp,
      'user_id': instance.userId,
      'sms_response': instance.smsResponse,
      'phone_number': instance.phoneNumber,
    };

SignupRequest _$SignupRequestFromJson(Map<String, dynamic> json) =>
    SignupRequest(
      name: json['name'] as String,
      password: json['password'] as String,
      phoneNumber: json['phone_number'] as String,
    );

Map<String, dynamic> _$SignupRequestToJson(SignupRequest instance) =>
    <String, dynamic>{
      'name': instance.name,
      'password': instance.password,
      'phone_number': instance.phoneNumber,
    };

LoginApiResponse _$LoginApiResponseFromJson(Map<String, dynamic> json) =>
    LoginApiResponse(
      data: AuthResponse.fromJson(json['data'] as Map<String, dynamic>),
      message: json['message'] as String,
      status: (json['status'] as num).toInt(),
    );

Map<String, dynamic> _$LoginApiResponseToJson(LoginApiResponse instance) =>
    <String, dynamic>{
      'data': instance.data,
      'message': instance.message,
      'status': instance.status,
    };
