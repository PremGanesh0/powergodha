import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:powergodha/l10n/app_localizations.dart';
import 'package:powergodha/login/models/password.dart';
import 'package:powergodha/shared/theme.dart';
import 'package:powergodha/signup/bloc/signup_bloc.dart';
import 'package:powergodha/signup/models/name.dart';
import 'package:powergodha/signup/models/phone_number.dart';

class SignupForm extends StatelessWidget {
  const SignupForm({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return BlocListener<SignupBloc, SignupState>(
      listener: (context, state) {
        if (state.status.isFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.error.isNotEmpty
                    ? state.error
                      : localizations?.authenticationFailure ?? 'Authentication Failure',
                ),
              ),
            );
        } else if (state.status.isSuccess) {
          // Show success message and navigate to OTP verification
          if (state.registrationResponse != null) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(
                  content: Text(
                    'Success. Please verify the OTP sent to your registered phone number',
                  ),
                  backgroundColor: Colors.green,
                ),
              );

            // Navigate to OTP verification screen
            Navigator.of(context)
                .pushNamed(
                  '/otp-verification',
                  arguments: {
                    'phoneNumber': state.phoneNumber.value,
                    'userId': state.registrationResponse!.userId,
                    'otp': state.registrationResponse!.otp,
                  },
                )
                .then((success) {
                  if (success == true) {
                    // OTP verification successful, show success message and navigate to login
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Registration completed successfully! Please log in with your credentials.',
                          ),
                          backgroundColor: Colors.green,
                        ),
                      );
                    // Navigate to login screen
                    Navigator.of(context).pushReplacementNamed('/login');
                  }
                });
          } else {
            Navigator.of(context).pop(); // Return to previous screen after success
          }
        }
      },
      child: Align(
        alignment: const Alignment(0, -1 / 3),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _NameInput(),
              const Padding(padding: EdgeInsets.all(12)),
              _PhoneNumberInput(),
              const Padding(padding: EdgeInsets.all(12)),
              _PasswordInput(),
              const Padding(padding: EdgeInsets.all(12)),
              _SignupButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class _NameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return BlocBuilder<SignupBloc, SignupState>(
      buildWhen: (previous, current) => previous.name != current.name,
      builder: (context, state) {
        return TextField(
          key: const Key('signupForm_nameInput_textField'),
          onChanged: (name) =>
              context.read<SignupBloc>().add(SignupNameChanged(name)),
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
            labelText: localizations?.fullName ?? 'Full Name',
            hintText: localizations?.enterFullName ?? 'Enter your full name',
            prefixIcon: const Icon(Icons.person),
            errorText: state.name.displayError != null
                ? state.name.error == NameValidationError.empty
                      ? localizations?.nameCannotBeEmpty ?? 'Name cannot be empty'
                      : localizations?.nameTooShort ?? 'Name must be at least 2 characters'
                : null,
          ),
        );
      },
    );
  }
}

class _PasswordInput extends StatefulWidget {
  @override
  State<_PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<_PasswordInput> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return BlocBuilder<SignupBloc, SignupState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextField(
          key: const Key('signupForm_passwordInput_textField'),
          onChanged: (password) =>
              context.read<SignupBloc>().add(SignupPasswordChanged(password)),
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            labelText: localizations?.password ?? 'Password',
            hintText: localizations?.enterPassword ?? 'Enter your password',
            prefixIcon: const Icon(Icons.lock),
            errorText: state.password.displayError != null
                ? state.password.error == PasswordValidationError.empty
                    ? 'Password cannot be empty'
                    : 'Password must be at least 8 characters'
                : null,
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off : Icons.visibility,
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
              tooltip: _obscurePassword
                  ? localizations?.showPassword ?? 'Show password'
                  : localizations?.hidePassword ?? 'Hide password',
            ),
          ),
        );
      },
    );
  }
}

class _PhoneNumberInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return BlocBuilder<SignupBloc, SignupState>(
      buildWhen: (previous, current) => previous.phoneNumber != current.phoneNumber,
      builder: (context, state) {
        return TextField(
          key: const Key('signupForm_phoneNumberInput_textField'),
          onChanged: (phoneNumber) =>
              context.read<SignupBloc>().add(SignupPhoneNumberChanged(phoneNumber)),
          keyboardType: TextInputType.phone,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ],
          decoration: InputDecoration(
            labelText: localizations?.phoneNumber ?? 'Phone Number',
            hintText: localizations?.enterPhoneNumber ?? 'Enter your phone number',
            prefixIcon: const Icon(Icons.phone),
            prefixText: '+91 ',
            errorText: state.phoneNumber.displayError != null
                ? state.phoneNumber.error == PhoneNumberValidationError.empty
                      ? 'Phone number cannot be empty'
                      : state.phoneNumber.error == PhoneNumberValidationError.tooShort
                      ? 'Phone number must be 10 digits'
                      : state.phoneNumber.error == PhoneNumberValidationError.tooLong
                      ? 'Phone number must be 10 digits'
                      : localizations?.invalidPhoneNumber ?? 'Please enter a valid phone number'
                : null,
          ),
        );
      },
    );
  }
}

class _SignupButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return BlocBuilder<SignupBloc, SignupState>(
      builder: (context, state) {
        return state.status.isInProgress
            ? const CircularProgressIndicator()
            : ElevatedButton(
                key: const Key('signupForm_continue_raisedButton'),
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
                    ? () =>
                        context.read<SignupBloc>().add(const SignupSubmitted())
                    : null,
                child: Text(localizations?.signup ?? 'Sign Up'),
              );
      },
    );
  }
}
