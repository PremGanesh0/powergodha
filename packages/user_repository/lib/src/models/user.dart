library;

/// User model representing user profile information.
///
/// This model contains user data retrieved from the authentication API
/// and provides a clean interface for user information throughout the app.
///
/// **Properties:**
/// * `id` - Unique user identifier
/// * `username` - User's login username
/// * `email` - User's email address
/// * `firstName` - User's first name
/// * `lastName` - User's last name
/// * `gender` - User's gender
/// * `image` - URL to user's profile image
///
/// **Usage:**
/// ```dart
/// final user = User(
///   id: '1',
///   username: 'johndoe',
///   email: 'john@example.com',
///   firstName: 'John',
///   lastName: 'Doe',
///   gender: 'male',
///   image: 'https://example.com/avatar.jpg',
/// );
/// ```
///
/// The model uses `Equatable` for value comparison and includes
/// an empty constant for representing unauthenticated state.

import 'package:equatable/equatable.dart';

/// {@template user}
/// A user profile model containing personal information and authentication data.
///
/// This model represents a user in the PowerGodha application and contains
/// all the essential user information retrieved from the authentication API.
/// It's used throughout the app to display user information and manage
/// user-related functionality.
///
/// **Equality:**
/// Two users are considered equal if all their properties match.
/// This is implemented using [Equatable] for efficient comparison.
///
/// **Empty State:**
/// The [empty] constant represents an unauthenticated or unknown user state
/// and is used as a default value in authentication flows.
/// {@endtemplate}
class User extends Equatable {
  /// Represents an empty or unauthenticated user state.
  ///
  /// This constant is used as a default value when no user is authenticated
  /// or when the user data is not available. All fields are set to default
  /// values that clearly indicate an empty state.
  ///
  /// **Usage:**
  /// ```dart
  /// User currentUser = User.empty; // Default unauthenticated state
  ///
  /// if (currentUser == User.empty) {
  ///   // Handle unauthenticated state
  /// }
  /// ```
  static const empty = User(
    id: '',
    username: '',
    email: '',
    firstName: '',
    lastName: '',
    gender: '',
    image: '',
    farmName: '',
  );

  /// Unique identifier for the user.
  ///
  /// This ID is typically assigned by the authentication server
  /// and is used to uniquely identify the user across the system.
  final String id;

  /// User's login username.
  ///
  /// This is the username used for authentication and is typically
  /// unique across the system.
  final String username;

  /// User's email address.
  ///
  /// Used for communication and as an alternative login method.
  /// Should be a valid email format.
  final String email;

  /// User's first name.
  ///
  /// Used for personalization and display purposes throughout the app.
  final String firstName;

  /// User's last name.
  ///
  /// Used for personalization and display purposes throughout the app.
  final String lastName;

  /// User's gender.
  ///
  /// Used for personalization and demographic purposes.
  /// Common values include 'male', 'female', or other gender identities.
  final String gender;

  /// URL to the user's profile image.
  ///
  /// This can be used to display the user's avatar or profile picture
  /// throughout the application. May be empty if no image is set.
  final String image;

  /// User's farm name.
  ///
  /// Used for displaying the farm name associated with the user.
  /// May be empty if no farm name is set.
  final String farmName;

  /// {@macro user}
  ///
  /// Creates a new [User] instance with the provided information.
  ///
  /// **Parameters:**
  /// * [id] - Unique identifier for the user
  /// * [username] - User's login username
  /// * [email] - User's email address
  /// * [firstName] - User's first name
  /// * [lastName] - User's last name
  /// * [gender] - User's gender
  /// * [image] - URL to user's profile image
  /// * [farmName] - User's farm name
  const User({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.image,
    required this.farmName,
  });

  /// Creates a [User] instance from an authentication response.
  ///
  /// This factory constructor converts data from the authentication API
  /// into a [User] model. It's typically used when converting authentication
  /// response data to the user model format.
  ///
  /// **Parameters:**
  /// * [id] - User ID (converted from int to string)
  /// * [username] - Username from authentication response
  /// * [email] - Email from authentication response
  /// * [firstName] - First name from authentication response
  /// * [lastName] - Last name from authentication response
  /// * [gender] - Gender from authentication response
  /// * [image] - Profile image URL from authentication response
  ///
  /// **Usage:**
  /// ```dart
  /// final user = User.fromAuthResponse(
  ///   id: authResponse.id,
  ///   username: authResponse.username,
  ///   email: authResponse.email,
  ///   firstName: authResponse.firstName,
  ///   lastName: authResponse.lastName,  ///   gender: authResponse.gender,
  ///   image: authResponse.image,
  /// );
  /// ```
  factory User.fromAuthResponse({
    required int id,
    required String username,
    required String email,
    required String firstName,
    required String lastName,
    required String? gender,
    required String? image,
  }) {
    return User(
      id: id.toString(),
      username: username,
      email: email,
      firstName: firstName,
      lastName: lastName,
      gender: gender ?? '',
      image: image ?? '',
      farmName: '', // Default to empty string for auth response
    );
  }

  /// Creates a [User] instance from a user response (from /auth/me endpoint).
  ///
  /// This factory constructor converts data from the user details API
  /// into a [User] model. It's used when fetching current user data.
  ///
  /// **Parameters:**
  /// * [id] - User ID (converted from int to string)
  /// * [username] - Username from user response
  /// * [email] - Email from user response
  /// * [firstName] - First name from user response
  /// * [lastName] - Last name from user response
  /// * [gender] - Gender from user response (nullable)
  /// * [image] - Profile image URL from user response (nullable)
  /// * [farmName] - Farm name from user response
  ///
  /// **Usage:**
  /// ```dart
  /// final user = User.fromUserResponse(
  ///   id: userResponse.id,
  ///   username: userResponse.username,
  ///   email: userResponse.email,
  ///   firstName: userResponse.firstName,
  ///   lastName: userResponse.lastName,
  ///   gender: userResponse.gender,
  ///   image: userResponse.image,
  ///   farmName: userResponse.farmName,
  /// );
  /// ```
  factory User.fromUserResponse({
    required int id,
    required String username,
    required String email,
    required String firstName,
    required String lastName,
    required String? gender,
    required String? image,
    required String farmName,
  }) {
    return User(
      id: id.toString(),
      username: username,
      email: email,
      firstName: firstName,
      lastName: lastName,
      gender: gender ?? '',
      image: image ?? '',
      farmName: farmName,
    );
  }

  /// Full display name combining first and last name.
  ///
  /// Provides a convenient way to get the user's full name for display
  /// purposes without concatenating first and last name manually.
  ///
  /// **Returns:** "[firstName] [lastName]"
  String get fullName => '$firstName $lastName';

  /// Whether the user has a profile image.
  ///
  /// Useful for determining whether to show a default avatar or
  /// the user's actual profile image.
  ///
  /// **Returns:** `true` if [image] is not empty, `false` otherwise
  bool get hasProfileImage => image.isNotEmpty;

  /// Properties used for equality comparison by [Equatable].
  ///
  /// This ensures that two [User] instances are considered equal
  /// if all their properties match, enabling efficient comparison
  /// and rebuilding optimization in Flutter widgets.
  @override
  List<Object> get props => [id, username, email, firstName, lastName, gender, image, farmName];

  /// Creates a copy of this user with optionally updated properties.
  ///
  /// This method allows creating a new [User] instance with some properties
  /// updated while keeping the rest unchanged. Useful for updating user
  /// profile information.
  ///
  /// **Parameters:** All parameters are optional and default to current values
  ///
  /// **Usage:**
  /// ```dart
  /// final updatedUser = currentUser.copyWith(
  ///   firstName: 'NewFirstName',
  ///   lastName: 'NewLastName',
  /// );
  /// ```
  User copyWith({
    String? id,
    String? username,
    String? email,
    String? firstName,
    String? lastName,
    String? gender,
    String? image,
    String? farmName,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      gender: gender ?? this.gender,
      image: image ?? this.image,
      farmName: farmName ?? this.farmName,
    );
  }
}
