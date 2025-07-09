/// Language selection page for choosing app locale.
///
/// This page is displayed after the splash screen when the user hasn't
/// selected a language preference yet. It allows users to choose from
/// four supported languages: English, Hindi, Telugu, and Marathi.
///
/// **Features:**
/// * Beautiful grid layout with language cards
/// * Native language names display
/// * Smooth selection animation
/// * Automatic navigation after selection
/// * Saves language preference for future app launches
library;

import 'package:flutter/material.dart';
import 'package:powergodha/app/app.dart';
import 'package:powergodha/app/app_logger_config.dart';
import 'package:powergodha/app/app_routes.dart';
import 'package:powergodha/l10n/app_localizations.dart';
import 'package:powergodha/shared/app_strings.dart';
import 'package:powergodha/shared/auth_interceptor.dart';
import 'package:powergodha/shared/localization_service.dart';

/// {@template language_selection_page}
/// A page that allows users to select their preferred language.
///
/// This [StatefulWidget] displays a grid of language options with:
/// * Native language names for better recognition
/// * Card-based UI with selection states
/// * Continue button that becomes enabled after selection
/// * Automatic language saving and navigation
///
/// **Navigation Flow:**
/// 1. User sees language options in grid layout
/// 2. User taps on preferred language (card highlights)
/// 3. User taps continue button
/// 4. Language preference is saved to SharedPreferences
/// 5. App immediately restarts with the new locale
/// 6. All UI reflects the selected language
///
/// **Supported Languages:**
/// * English - "English"
/// * Hindi - "हिंदी"
/// * Telugu - "తెలుగు"
/// * Marathi - "मराठी"
///
/// The page uses [LocalizationService] to persist the language choice
/// and provides a smooth, intuitive selection experience.
/// {@endtemplate}
class LanguageSelectionPage extends StatefulWidget {
  /// {@macro language_selection_page}
  const LanguageSelectionPage({super.key});

  @override
  State<LanguageSelectionPage> createState() => _LanguageSelectionPageState();

  /// Route method for navigation integration.
  ///
  /// Creates a [MaterialPageRoute] for this page, compatible with
  /// the app's routing system.
  ///
  /// **Usage:**
  /// ```dart
  /// Navigator.push(context, LanguageSelectionPage.route());
  /// ```
  static Route<void> route() {
    return MaterialPageRoute<void>(
      builder: (_) => const LanguageSelectionPage(),
    );
  }
}

class _LanguageSelectionPageState extends State<LanguageSelectionPage>
    with SingleTickerProviderStateMixin {
  /// Currently selected language code
  String? _selectedLanguage;

  /// Animation controller for smooth transitions
  late AnimationController _animationController;

  /// Scale animation for the continue button
  late Animation<double> _buttonScaleAnimation;

  /// Language options with their codes and display names
  final List<Map<String, String>> _languages = [
    {'code': 'en', 'name': 'English', 'flag': '🇺🇸'},
    {'code': 'hi', 'name': 'हिंदी', 'flag': '🇮🇳'},
    {'code': 'te', 'name': 'తెలుగు', 'flag': '🇮🇳'},
    {'code': 'mr', 'name': 'मराठी', 'flag': '🇮🇳'},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Try to get localized strings, fallback to our custom strings
    final localizations = AppLocalizations.of(context);
    final currentLanguage = _selectedLanguage ?? 'en';
    final strings = AppStrings.getStrings(currentLanguage);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 60),

              // App logo or icon
              Icon(
                Icons.language,
                size: 80,
                color: theme.colorScheme.primary,
              ),

              const SizedBox(height: 32),

              // Title
              Text(
                localizations?.selectLanguage ?? strings['selectLanguage'] ?? 'Select Language',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 12),

              // Description
              Text(
                localizations?.selectLanguageDescription ??
                strings['selectLanguageDescription'] ??
                'Please select your preferred language to continue',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 48),

              // Language selection grid
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.2,
                  ),
                  itemCount: _languages.length,
                  itemBuilder: (context, index) {
                    final language = _languages[index];
                    final isSelected = _selectedLanguage == language['code'];

                    return _buildLanguageCard(
                      context,
                      language: language,
                      isSelected: isSelected,
                      onTap: () => _onLanguageSelected(language['code']!),
                    );
                  },
                ),
              ),

              const SizedBox(height: 32),

              // Continue button
              AnimatedBuilder(
                animation: _buttonScaleAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _buttonScaleAnimation.value,
                    child: child,
                  );
                },
                child: SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _selectedLanguage != null ? _onContinuePressed : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                      elevation: 8,
                      shadowColor: theme.colorScheme.primary.withOpacity(0.3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      localizations?.continueText ?? strings['continueText'] ?? 'Continue',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _buttonScaleAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
  }

  /// Builds a language selection card.
  Widget _buildLanguageCard(
    BuildContext context, {
    required Map<String, String> language,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: isSelected
            ? theme.colorScheme.primary.withOpacity(0.1)
            : theme.colorScheme.surface,
        border: Border.all(
          color: isSelected
              ? theme.colorScheme.primary
              : theme.colorScheme.outline.withOpacity(0.3),
          width: isSelected ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          if (isSelected)
            BoxShadow(
              color: theme.colorScheme.primary.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Flag emoji
                Text(
                  language['flag'] ?? '🌐',
                  style: const TextStyle(fontSize: 32),
                ),

                const SizedBox(height: 12),

                // Language name
                Text(
                  language['name'] ?? '',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 8),

                // Selection indicator
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: isSelected ? 24 : 0,
                  height: 3,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Handles continue button press.
  Future<void> _onContinuePressed() async {
    if (_selectedLanguage == null) return;

    try {
      // Save the selected language
      await LocalizationService.setLanguage(_selectedLanguage!);

      // Show loading indicator
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              // Use either localized string or fallback
              AppLocalizations.of(context)?.continueText ?? 'Applying language settings...',
            ),
            duration: const Duration(seconds: 1),
          ),
        );
      }

      if (mounted) {
        // Force rebuild the app with the new locale
        final newLocale = Locale(_selectedLanguage!);

        // Log that we're restarting due to a language change
        AppLogger.info('Language changed to: ${_selectedLanguage!}, restarting app...');

        // Check if we have tokens to determine where to navigate after restart
        final hasTokens = await AuthInterceptor.hasTokensInStorage();

        // ALWAYS go to Home if user has tokens, otherwise Login
        final initialRoute = hasTokens ? AppRoutes.home : AppRoutes.login;

        AppLogger.info(
          'Language selection: hasTokens=$hasTokens, navigating to $initialRoute after restart',
        );

        // Clean restart approach using proper app restart
        AppLogger.info(
          'Restarting app with new locale: ${newLocale.languageCode} and route: $initialRoute',
        );

        // Instead of creating a new widget tree, restart at the root level
        // This ensures complete cleanup of the previous widget tree
        final navigator = Navigator.of(context, rootNavigator: true);
        navigator.pushAndRemoveUntil(
          MaterialPageRoute<void>(
            builder: (context) => App(initialLocale: newLocale, initialRoute: initialRoute),
          ),
          (route) => false, // Remove ALL routes including the root
        );
      }
    } catch (e) {
      // Handle error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving language preference: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  /// Handles language selection.
  void _onLanguageSelected(String languageCode) {
    setState(() {
      _selectedLanguage = languageCode;
    });

    // Animate the continue button when language is selected
    if (_animationController.status == AnimationStatus.dismissed) {
      _animationController.forward();
    }
  }
}
