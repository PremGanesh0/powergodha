/// OTP verification functionality for user registration.
///
/// This module provides OTP verification capabilities for the PowerGodha
/// application. It includes:
/// * OTP input validation and formatting
/// * OTP verification BLoC for state management
/// * OTP verification page and form widgets
/// * Integration with authentication repository
///
/// **Usage:**
/// ```dart
/// // Navigate to OTP verification
/// Navigator.of(context).pushNamed(
///   '/otp-verification',
///   arguments: {
///     'phoneNumber': phoneNumber,
///     'userId': userId,
///     'otp': otp,
///   },
/// );
/// ```
library;

export 'bloc/otp_verification_bloc.dart';
export 'models/otp.dart';
export 'view/otp_verification_form.dart';
export 'view/otp_verification_page.dart';
