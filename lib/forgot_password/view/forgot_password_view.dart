import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:powergodha/l10n/app_localizations.dart';
import 'package:powergodha/shared/theme.dart';

import '../../authentication/authentication.dart';
import '../bloc/forgot_password_bloc.dart';

class ForgotPasswordForm extends StatelessWidget {
  const ForgotPasswordForm({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
      listener: (context, state) {
        if (state.status.isSuccess) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(
                  localizations?.resetPasswordSuccess ?? 'Password reset email sent successfully!',
                ),
              ),
            );
          Navigator.of(context).pop();
        }
        if (state.status.isFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(
                  state.errorMessage ??
                      localizations?.resetPasswordFailure ??
                      'Password reset failed',
                ),
              ),
            );
        }
      },
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                localizations?.forgotPassword ?? 'Forgot Password',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(
                localizations?.resetPasswordDescription ??
                    "Enter your email address and we'll send you instructions to reset your password.",
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              _EmailInput(),
              const SizedBox(height: 16),
              _ResetPasswordButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class ForgotPasswordView extends StatelessWidget {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(localizations?.resetPassword ?? 'Reset Password')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocProvider(
          create: (context) => ForgotPasswordBloc(
            authenticationBloc: context.read<AuthenticationBloc>(),
          ),
          child: const ForgotPasswordForm(),
        ),
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextField(
          key: const Key('forgotPasswordForm_emailInput_textField'),
          onChanged: (email) =>
              context.read<ForgotPasswordBloc>().add(ForgotPasswordEmailChanged(email)),
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: localizations?.email ?? 'Email',
            errorText: state.email.displayError != null ? 'Invalid email' : null,
          ),
        );
      },
    );
  }
}

class _ResetPasswordButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final isValid = context.select((ForgotPasswordBloc bloc) => bloc.state.isValid);
    return BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
      builder: (context, state) {
        return state.status.isInProgress
            ? const CircularProgressIndicator()
            : ElevatedButton(
                key: const Key('forgotPasswordForm_submit_button'),
        style:      Theme.of(context).elevatedButtonTheme.style?.copyWith(
                  backgroundColor: WidgetStateProperty.all(
                    isValid
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.onSurface,
                  ),
                  foregroundColor: WidgetStateProperty.all(Colors.white),
                  minimumSize: const WidgetStatePropertyAll(Size(double.infinity, 56)),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppTypography.radiusMedium),
                    ),
                  ),
                ),
                onPressed: state.isValid
                    ? () => context
                        .read<ForgotPasswordBloc>()
                        .add(const ForgotPasswordSubmitted())
                    : null,
                child: Text(localizations?.resetPassword ?? 'Reset Password'),
              );
      },
    );
  }
}
