import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:powergodha/otp_verification/bloc/otp_verification_bloc.dart';
import 'package:powergodha/otp_verification/view/otp_verification_form.dart';

/// {@template otp_verification_page}
/// A page that displays the OTP verification form.
/// {@endtemplate}
class OtpVerificationPage extends StatelessWidget {
  /// {@macro otp_verification_page}
  const OtpVerificationPage({
    required this.phoneNumber,
    required this.userId,
    required this.otp,
    super.key,
  });

  /// The phone number that was used for registration.
  final String phoneNumber;

  /// The user ID returned from registration.
  final int userId;

  /// The OTP sent to the user's phone.
  final String otp;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify OTP'),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: BlocProvider(
          create: (context) => OtpVerificationBloc(
            authenticationRepository: context.read<AuthenticationRepository>(),
            phoneNumber: phoneNumber,
            userId: userId,
            otp: otp,
          ),
          child: const OtpVerificationForm(),
        ),
      ),
    );
  }

  /// Creates a route for the OTP verification page.
  static Route<bool?> route({
    required String phoneNumber,
    required int userId,
    required String otp,
  }) {
    return MaterialPageRoute<bool?>(
      builder: (_) => OtpVerificationPage(
        phoneNumber: phoneNumber,
        userId: userId,
        otp: otp,
      ),
    );
  }
}
