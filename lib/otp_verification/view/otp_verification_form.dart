import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:powergodha/l10n/app_localizations.dart';
import 'package:powergodha/otp_verification/bloc/otp_verification_bloc.dart';
import 'package:powergodha/otp_verification/models/otp.dart';
import 'package:powergodha/shared/theme.dart';

/// {@template otp_verification_form}
/// A form widget for OTP verification.
/// {@endtemplate}
class OtpVerificationForm extends StatelessWidget {
  /// {@macro otp_verification_form}
  const OtpVerificationForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<OtpVerificationBloc, OtpVerificationState>(
      listener: (context, state) {
        if (state.status.isFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(            content: Text(state.error.isNotEmpty
                ? state.error
                : 'Verification Failed'),
              ),
            );
        } else if (state.status.isSuccess) {
          // Show success message for OTP verification
          if (state.otpResponse != null) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.otpResponse!.message),
                  backgroundColor: Colors.green,
                ),
              );
          }
          // Close the OTP verification screen and return success
          Navigator.of(context).pop(true);
        }
      },
      child: Align(
        alignment: const Alignment(0, -1 / 3),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.phone_android,
                size: 80,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 24),
              Text(
                'Verify OTP',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Please enter the 6-digit OTP sent to your phone number',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              _OtpInput(),
              const SizedBox(height: 24),
              _VerifyButton(),
              const SizedBox(height: 16),
              _ResendOtpButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class _OtpInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return BlocBuilder<OtpVerificationBloc, OtpVerificationState>(
      buildWhen: (previous, current) => previous.otp != current.otp,
      builder: (context, state) {
        return TextField(
          key: const Key('otpVerificationForm_otpInput_textField'),
          onChanged: (otp) =>
              context.read<OtpVerificationBloc>().add(OtpChanged(otp)),
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          maxLength: 6,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(6),
          ],
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            letterSpacing: 8,
            fontWeight: FontWeight.bold,
          ),
          decoration: InputDecoration(
            labelText: localizations?.enterOtp ?? 'Enter OTP',
            hintText: '123456',
            counterText: '',
            prefixIcon: const Icon(Icons.security),
            errorText: state.otp.displayError != null
                ? state.otp.error == OtpValidationError.empty
                    ? 'OTP cannot be empty'
                    : state.otp.error == OtpValidationError.tooShort
                        ? 'OTP must be 6 digits'
                        : state.otp.error == OtpValidationError.tooLong
                            ? 'OTP must be 6 digits'
                            : 'Please enter a valid OTP'
                : null,
          ),
        );
      },
    );
  }
}

class _ResendOtpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      key: const Key('otpVerificationForm_resend_textButton'),
      onPressed: () =>
          context.read<OtpVerificationBloc>().add(const ResendOtpRequested()),
      child: Text(
        'Resend OTP',
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _VerifyButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OtpVerificationBloc, OtpVerificationState>(
      builder: (context, state) {
        return state.status.isInProgress
            ? const CircularProgressIndicator()
            : ElevatedButton(
                key: const Key('otpVerificationForm_verify_raisedButton'),
                style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
                  backgroundColor: WidgetStateProperty.all(Theme.of(context).colorScheme.primary),
                  foregroundColor: WidgetStateProperty.all(Colors.white),
                  minimumSize: const WidgetStatePropertyAll(Size(double.infinity, 56)),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppTypography.radiusMedium),
                    ),
                  ),
                ),
                onPressed: state.isValid
                    ? () => context.read<OtpVerificationBloc>().add(const OtpSubmitted())
                    : null,
                child: const Text('Verify'),
              );
      },
    );
  }
}
