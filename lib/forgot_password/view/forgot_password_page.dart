import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:powergodha/l10n/app_localizations.dart';

import '../../authentication/authentication.dart';
import '../bloc/forgot_password_bloc.dart';
import 'forgot_password_view.dart';

/// {@template forgot_password_page}
/// Page that provides the forgot password feature.
/// Allows users to request a password reset using their email.
/// {@endtemplate}
class ForgotPasswordPage extends StatelessWidget {
  /// {@macro forgot_password_page}
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(localizations?.forgotPassword ?? 'Reset Password')),
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

  /// Route for navigating to this page.
  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const ForgotPasswordPage());
  }
}
