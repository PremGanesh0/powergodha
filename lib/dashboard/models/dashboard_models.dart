import 'package:flutter/material.dart';

/// Data model for animal card information
class AnimalCardData {
  /// Creates an animal card data model
  const AnimalCardData({
    required this.title,
    required this.icon,
    required this.color,
    required this.count,
    required this.onTap,
  });

  /// The title of the animal type
  final String title;

  /// The icon asset path for the animal
  final String icon;

  /// The background color of the card
  final Color color;

  /// The count to display
  final String count;

  /// Callback when the card is tapped
  final VoidCallback onTap;
}

/// Data model for action card information
class ActionCardData {
  /// Creates an action card data model
  const ActionCardData({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  /// The title of the action
  final String title;

  /// The icon for the action
  final IconData icon;

  /// Callback when the card is tapped
  final VoidCallback onTap;
}

/// Constants for dashboard styling
abstract class DashboardConstants {
  /// Default card border radius
  static const double cardBorderRadius = 12.0;

  /// Default card elevation
  static const double cardElevation = 4.0;

  /// Default icon size for action cards
  static const double actionIconSize = 48.0;

  /// Default grid spacing
  static const double gridSpacing = 16.0;

  /// Default card aspect ratio
  static const double cardAspectRatio = 1.1;

  /// Default header bottom radius
  static const double headerBottomRadius = 20.0;

  /// Animal type colors
  static const Color cowColor = Color(0xFFE91E63); // Pink
  static const Color buffaloColor = Color(0xFF4CAF50); // Green
  static const Color goatColor = Color(0xFF4CAF50); // Green
  static const Color henColor = Color(0xFF2196F3); // Blue
}
