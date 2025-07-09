/// Theme extensions for app-specific styling.
///
/// This file contains theme extensions that provide additional styling
/// capabilities beyond the base Material Design 3 theme. These extensions
/// add app-specific colors, gradients, and style variations.
library;

import 'package:flutter/material.dart';

/// Theme extension for app-specific colors
@immutable
class AppColors extends ThemeExtension<AppColors> {
  /// Creates an instance of AppColors
  const AppColors({
    required this.success,
    required this.warning,
    required this.info,
    required this.gradient,
  });

  /// Success color for positive feedback
  final Color success;

  /// Warning color for caution states
  final Color warning;

  /// Info color for informational messages
  final Color info;

  /// Primary gradient for backgrounds and accents
  final LinearGradient gradient;

  /// Light theme instance
  static const AppColors light = AppColors(
    success: Color(0xFF10B981),
    warning: Color(0xFFF59E0B),
    info: Color(0xFF3B82F6),
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFF1976D2),
        Color(0xFF1565C0),
      ],
    ),
  );

  /// Dark theme instance
  static const AppColors dark = AppColors(
    success: Color(0xFF34D399),
    warning: Color(0xFFFBBF24),
    info: Color(0xFF60A5FA),
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFF42A5F5),
        Color(0xFF2196F3),
      ],
    ),
  );

  @override
  ThemeExtension<AppColors> copyWith({
    Color? success,
    Color? warning,
    Color? info,
    LinearGradient? gradient,
  }) {
    return AppColors(
      success: success ?? this.success,
      warning: warning ?? this.warning,
      info: info ?? this.info,
      gradient: gradient ?? this.gradient,
    );
  }

  @override
  ThemeExtension<AppColors> lerp(
    covariant ThemeExtension<AppColors>? other,
    double t,
  ) {
    if (other is! AppColors) {
      return this;
    }
    return AppColors(
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      info: Color.lerp(info, other.info, t)!,
      gradient: LinearGradient.lerp(gradient, other.gradient, t)!,
    );
  }
}

/// Extension methods for easy access to app colors
extension AppColorsExtension on ThemeData {
  /// Get app-specific colors
  AppColors get appColors => extension<AppColors>() ?? AppColors.light;
}

/// Common app styles that can be reused throughout the app
class AppStyles {
  const AppStyles._();

  /// Card style with subtle elevation
  static const BoxDecoration cardDecoration = BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(16)),
    boxShadow: [
      BoxShadow(
        color: Color(0x0A000000),
        blurRadius: 8,
        offset: Offset(0, 2),
      ),
    ],
  );

  /// Input field style
  static const OutlineInputBorder inputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(12)),
    borderSide: BorderSide(color: Color(0xFFE5E7EB)),
  );

  /// Focused input field style
  static const OutlineInputBorder focusedInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(12)),
    borderSide: BorderSide(color: Color(0xFF1976D2), width: 2),
  );

  /// Error input field style
  static const OutlineInputBorder errorInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(12)),
    borderSide: BorderSide(color: Color(0xFFDC2626)),
  );
}

/// App-specific text styles
class AppTextStyles {
  const AppTextStyles._();

  /// Button text style
  static const TextStyle buttonText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );

  /// Card title text style
  static const TextStyle cardTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
  );

  /// Caption text style
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
  );

  /// Error text style
  static const TextStyle error = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: Color(0xFFDC2626),
  );
}
