/// User response model for API communication.
///
/// This model represents the user data structure returned by the API
/// and is used for serialization/deserialization of user information
/// from authentication and user management endpoints.
library;

import 'package:json_annotation/json_annotation.dart';

part 'user_response.g.dart';

/// {@template user_response}
/// Response model for user details from API endpoints.
///
/// This model represents the raw user data structure returned by various
/// API endpoints including `/get_user_by_id/{userId}` and user management endpoints.
/// It contains all user profile information and location data.
///
/// **Usage:**
/// ```dart
/// final userResponse = UserResponse.fromJson(apiResponseJson);
/// final user = User.fromUserResponse(userResponse);
/// ```
///
/// This model is primarily used for API communication and should be
/// converted to the domain [User] model for use throughout the application.
/// {@endtemplate}
@JsonSerializable()
class UserResponse {
  /// User's unique identifier.
  @JsonKey(name: 'user_id')
  final int id;

  /// User's name.
  final String name;

  /// User's email address.
  final String email;

  /// User's phone number.
  @JsonKey(name: 'phone_number')
  final String phoneNumber;

  /// User's farm name.
  @JsonKey(name: 'farm_name')
  final String farmName;

  /// User's address.
  final String address;

  /// User's postal code.
  final String pincode;

  /// User's taluka.
  final String taluka;

  /// User's district.
  final String district;

  /// User's state.
  final String state;

  /// User's country.
  final String country;

  /// User's village.
  final String village;

  /// Creates a new user response instance.
  const UserResponse({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.farmName,
    required this.address,
    required this.pincode,
    required this.taluka,
    required this.district,
    required this.state,
    required this.country,
    required this.village,
  });

  /// Creates a [UserResponse] from JSON data.
  factory UserResponse.fromJson(Map<String, dynamic> json) => _$UserResponseFromJson(json);
  String get firstName => name;
  String? get gender => null;
  String? get image => null;
  String get lastName => '';
  String get phone => phoneNumber;

  // Getters for backward compatibility with existing User model
  String get username => phoneNumber;

  /// Converts this user response to JSON.
  Map<String, dynamic> toJson() => _$UserResponseToJson(this);
}
