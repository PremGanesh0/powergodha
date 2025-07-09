import 'package:flutter/widgets.dart';
import 'package:powergodha/app/app.dart';
import 'package:powergodha/app/app_logger_config.dart';

/// The main entry point of the PowerGodha application.
///
/// This function initializes and runs the Flutter application by calling
/// [runApp] with the root [App] widget. The [App] widget is responsible for:
/// * Setting up dependency injection with repositories
/// * Initializing global BLoC providers
/// * Managing authentication state
/// * Handling application-wide navigation
///
/// This is the first function called when the app starts.
void main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the global logger
  await AppLogger.initialize();

  runApp(const App());
}
