import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:powergodha/app/app_routes.dart';
import 'package:powergodha/l10n/app_localizations.dart';
import 'package:powergodha/login/bloc/login_bloc.dart';
import 'package:powergodha/shared/theme.dart';

/// {@template login_form}
/// A form widget that handles user login input and submission.
///
/// This widget provides a complete login form interface including:
/// * Username input field with validation
/// * Password input field with validation
/// * Login button with loading state
/// * Error message display via SnackBar
///
/// The form uses [LoginBloc] for state management and validation.
/// It displays appropriate error messages and loading indicators
/// based on the current state of the login process.
///
/// The form layout is centered vertically with a -1/3 alignment from the top,
/// with consistent padding between elements.
/// {@endtemplate}
class LoginForm extends StatelessWidget {
  /// {@macro login_form}
  const LoginForm({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      // Listen for authentication failures and show error message
      listener: (context, state) {
        if (state.status.isFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(
                  state.error?.isNotEmpty ?? false
                      ? state.error!
                      : AppLocalizations.of(context)!.authenticationFailure,
                ),
              ),
            );
        }
      },
      child: Align(
        // Center the form vertically with a slight offset towards the top
        alignment: const Alignment(0, -1 / 3),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppTypography.space24),
            child: Column(
              // Use minimum vertical space
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title text for the login form
                Text(
                  AppLocalizations.of(context)!.login,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),

                const SizedBox(height: AppTypography.space32),
                // Username input field
                _PhoneNumberInput(),
                // Consistent spacing between form elements
                const SizedBox(height: AppTypography.space16),
                // Password input field
                _PasswordInput(),
                // Consistent spacing between form elements
                // const SizedBox(height: AppTypography.space24),
                // Forgot password button
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    key: const Key('loginForm_forgotPassword_textButton'),
                    onPressed: () => Navigator.pushNamed(context, AppRoutes.forgotPassword),
                    child: Text(AppLocalizations.of(context)!.forgotPassword),
                  ),
                ),
                // Login button with loading state
                _LoginButton(),
                // Action buttons with equal spacing
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(AppLocalizations.of(context)!.dontHaveAccount),
                    // Signup button
                    TextButton(
                      key: const Key('loginForm_createAccount_textButton'),
                      onPressed: () => Navigator.pushNamed(context, AppRoutes.signup),
                      child: Text(AppLocalizations.of(context)!.createAccount),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A private widget that handles the login button and its states.
///
/// This widget:
/// * Shows a loading indicator during login AND after success (until navigation)
/// * Enables/disables based on form validity
/// * Triggers login submission when pressed
/// * Uses a consistent key for testing
///
/// **Loading States:**
/// * `isInProgress` - Shows loading during API call
/// * `isSuccess` - Continues showing loading until navigation occurs
/// * This prevents users from seeing the button return to normal before navigation
///
/// **Important:** Shows loading during `isInProgress` OR `isSuccess` state.
/// This provides seamless visual feedback from login start to navigation completion.
class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Show loading during login attempt OR after success (until navigation)
    final status = context.select((LoginBloc bloc) => bloc.state.status);

    // Show loading indicator during progress or success (until navigation happens)
    if (status.isInProgress || status.isSuccess) {
      return const CircularProgressIndicator();
    }

    final isValid = context.select((LoginBloc bloc) => bloc.state.isValid);
    return ElevatedButton(
      key: const Key('loginForm_continue_raisedButton'),
      onPressed: isValid
          ? () {
              FocusScope.of(context).unfocus();
              context.read<LoginBloc>().add(const LoginSubmitted());
            }
          : null,
      style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
        backgroundColor: WidgetStateProperty.all(
          isValid ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurface,
        ),
        foregroundColor: WidgetStateProperty.all(Colors.white),
        minimumSize: const WidgetStatePropertyAll(Size(double.infinity, 56)),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTypography.radiusMedium)),
        ),
      ),

      child: Text(AppLocalizations.of(context)!.login),
    );
  }
}

/// A private widget that handles the password input field.
///
/// This widget:
/// * Listens to password validation errors from [LoginBloc]
/// * Updates the password in the [LoginBloc] state
/// * Shows validation error messages when appropriate
/// * Obscures the password text for security
class _PasswordInput extends StatefulWidget {
  @override
  State<_PasswordInput> createState() => _PasswordInputState();
}


/// A private state class for [_PasswordInput] that manages the obscure text state.
/// A private state class for [_PasswordInput] that manages the obscure text state.
class _PasswordInputState extends State<_PasswordInput> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final displayError = context.select((LoginBloc bloc) => bloc.state.password.displayError);
    return TextField(
      key: const Key('loginForm_passwordInput_textField'),
      onChanged: (password) {
        context.read<LoginBloc>().add(LoginPasswordChanged(password));
      },
      obscureText: _obscurePassword,
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp(r'\s')), // Prevent spaces in password
        LengthLimitingTextInputFormatter(20), // limit the length to 20 characters
      ],
      decoration: InputDecoration(
        // labelText: AppLocalizations.of(context)!.password,
        hintText: AppLocalizations.of(context)!.enterPassword,
        errorText: displayError != null ? AppLocalizations.of(context)!.invalidPassword : null,
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(_obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
          tooltip: _obscurePassword
              ? AppLocalizations.of(context)!.showPassword
              : AppLocalizations.of(context)!.hidePassword,
        ),
      ),
    );
  }
}

/// A private widget that handles the username input field.
///
/// This widget:
/// * Listens to username validation errors from [LoginBloc]
/// * Updates the username in the [LoginBloc] state
/// * Shows validation error messages when appropriate
class _PhoneNumberInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final displayError = context.select((LoginBloc bloc) => bloc.state.phoneNumber.displayError);
    return TextField(
      key: const Key('loginForm_phonenumberInput_textField'),
      onChanged: (phoneNumber) {
        context.read<LoginBloc>().add(LoginPhoneNumberChanged(phoneNumber));
      },
      keyboardType: TextInputType.number,
      maxLength: 10,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10),
        FilteringTextInputFormatter.allow(RegExp(r'^[6789]\d{0,9}$')),
      ],
      decoration: InputDecoration(
        // labelText: AppLocalizations.of(context)!.phoneNumber,
        hintText: AppLocalizations.of(context)!.enterPhoneNumber,
        errorText: displayError != null ? AppLocalizations.of(context)!.invalidPhoneNumber : null,
        prefixIcon: const Icon(Icons.phone_android_outlined),
        counterText: '',
      ),
    );
  }
}
