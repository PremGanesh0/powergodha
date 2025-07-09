import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:powergodha/shared/theme_extensions.dart';

class AppTheme {
  /// Private constructor to prevent instantiation
  const AppTheme._();

  /// Primary brand color for the application

  /// Light theme color scheme based on Material Design 3
  static const ColorScheme _lightColorScheme = ColorScheme.light(
    primary: Color(0xFF4CAF50),
    primaryContainer: Color(0xFFB2DFDB),
    onPrimary: Color(0xFF000000),
    secondary: Color(0xFF4CAF50),
    secondaryContainer: Color(0xFFC8E6C9),
    tertiary: Color(0xFF4CAF50),
    tertiaryContainer: Color(0xFFC8E6C9),
    onTertiary: Color(0xFF000000),
  );

  /// Custom color extensions for additional colors not in Material Design 3
  static const MaterialColor warningColor = MaterialColor(0xFFFF9800, <int, Color>{
    50: Color(0xFFFFF8E1),
    100: Color(0xFFFFECB3),
    200: Color(0xFFFFE082),
    300: Color(0xFFFFD54F),
    400: Color(0xFFFFCA28),
    500: Color(0xFFFF9800),
    600: Color(0xFFFF8F00),
    700: Color(0xFFFF6F00),
    800: Color(0xFFE65100),
    900: Color(0xFFBF360C),
  });

  static const MaterialColor successColor = MaterialColor(0xFF4CAF50, <int, Color>{
    50: Color(0xFFE8F5E8),
    100: Color(0xFFC8E6C9),
    200: Color(0xFFA5D6A7),
    300: Color(0xFF81C784),
    400: Color(0xFF66BB6A),
    500: Color(0xFF4CAF50),
    600: Color(0xFF43A047),
    700: Color(0xFF388E3C),
    800: Color(0xFF2E7D32),
    900: Color(0xFF1B5E20),
  });

  /// Light theme configuration
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: _lightColorScheme,
      textTheme: _textTheme,
      extensions: const [AppColors.light],
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: _lightColorScheme.surface,
        foregroundColor: _lightColorScheme.onSurface,
        titleTextStyle: _textTheme.titleLarge?.copyWith(
          color: _lightColorScheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(AppTheme.successColor[600]),
          elevation: WidgetStateProperty.all(2),
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          textStyle: WidgetStateProperty.all(
            _textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: _textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w500),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(),
      cardTheme: CardThemeData(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: _lightColorScheme.surface,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: _lightColorScheme.inverseSurface,
        contentTextStyle: _textTheme.bodyMedium?.copyWith(
          color: _lightColorScheme.onInverseSurface,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        behavior: SnackBarBehavior.floating,
      ),
      dividerTheme: DividerThemeData(
        color: _lightColorScheme.outline.withOpacity(0.2),
        thickness: 1,
      ),
    );
  }

  /// Base text theme using Inter font family
  static TextTheme get _textTheme {
    try {
      return GoogleFonts.interTextTheme();
    } catch (e) {
      // Fallback to default text theme if Google Fonts fails
      return ThemeData.light().textTheme;
    }
  }
}

/// Typography scale constants for consistent spacing
class AppTypography {
  const AppTypography._();

  /// Spacing constants based on 8dp grid system
  /// Use with .r, .w, or .h from ScreenUtil for responsive sizing
  /// Example: AppTypography.space24.r for responsive in both dimensions
  /// Example: AppTypography.space24.h for responsive height only
  static const double space4 = 4;
  static const double space8 = 8;
  static const double space12 = 12;
  static const double space16 = 16;
  static const double space20 = 20;
  static const double space24 = 24;
  static const double space32 = 32;
  static const double space40 = 40;
  static const double space48 = 48;
  static const double space56 = 56;
  static const double space64 = 64;

  /// Border radius constants
  /// Use with .r for responsive border radius
  /// Example: BorderRadius.circular(AppTypography.radiusMedium.r)
  static const double radiusSmall = 8;
  static const double radiusMedium = 12;
  static const double radiusLarge = 16;
  static const double radiusXLarge = 24;
}

/// Extension methods for accessing custom theme colors
extension ThemeExtension on ThemeData {
  /// Get info color for the current theme
  Color get infoColor => appColors.info;

  /// Get success color for the current theme
  Color get successColor => appColors.success;

  /// Get warning color for the current theme
  Color get warningColor => appColors.warning;
}
