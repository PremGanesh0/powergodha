import 'dart:ui';

import 'package:powergodha/shared/enums.dart';

/// Utility class for working with AnimalType enum
class AnimalTypeUtils {
  /// Gets all available animal types
  static List<AnimalType> getAllAnimalTypes() {
    return [
      AnimalType.cow,
      AnimalType.buffalo,
      AnimalType.goat,
      AnimalType.hen,
    ];
  }

  /// Maps AnimalType enum to API ID
  static int getAnimalId(AnimalType animalType) {
    switch (animalType) {
      case AnimalType.cow:
        return 1;
      case AnimalType.buffalo:
        return 2;
      case AnimalType.goat:
        return 3;
      case AnimalType.hen:
        return 4;
    }
  }

  /// Maps API ID to AnimalType enum
  static AnimalType? getAnimalTypeFromId(int animalId) {
    switch (animalId) {
      case 1:
        return AnimalType.cow;
      case 2:
        return AnimalType.buffalo;
      case 3:
        return AnimalType.goat;
      case 4:
        return AnimalType.hen;
      default:
        return null;
    }
  }

  /// Maps string to AnimalType enum (case insensitive)
  static AnimalType? getAnimalTypeFromString(String value) {
    switch (value.toLowerCase()) {
      case 'cow':
      case 'cows':
        return AnimalType.cow;
      case 'buffalo':
      case 'buffalos':
      case 'buffaloes':
        return AnimalType.buffalo;
      case 'goat':
      case 'goats':
        return AnimalType.goat;
      case 'hen':
      case 'hens':
      case 'chicken':
      case 'chickens':
        return AnimalType.hen;
      default:
        return null;
    }
  }

  /// Gets API string representation for AnimalType
  static String getApiString(AnimalType animalType) {
    switch (animalType) {
      case AnimalType.cow:
        return 'cows';
      case AnimalType.buffalo:
        return 'buffaloes';
      case AnimalType.goat:
        return 'goat';
      case AnimalType.hen:
        return 'hen';
    }
  }

  /// Creates a human-readable description of animal count
  static String getCountDescription(AnimalType animalType, int count) {
    final name = count == 1 ? getSingularDisplayName(animalType) : getDisplayName(animalType);
    return '$count $name';
  }

  /// Gets display name for AnimalType
  static String getDisplayName(AnimalType animalType) {
    switch (animalType) {
      case AnimalType.cow:
        return 'Cows';
      case AnimalType.buffalo:
        return 'Buffalo';
      case AnimalType.goat:
        return 'Goats';
      case AnimalType.hen:
        return 'Hens';
    }
  }

  /// Gets icon path for the animal type
  static String getIconPath(AnimalType animalType) {
    switch (animalType) {
      case AnimalType.cow:
        return 'assets/icons/cows.png';
      case AnimalType.buffalo:
        return 'assets/icons/buffalos.png';
      case AnimalType.goat:
        return 'assets/icons/goats.png';
      case AnimalType.hen:
        return 'assets/icons/hens.png';
    }
  }

  /// Gets singular display name for AnimalType
  static String getSingularDisplayName(AnimalType animalType) {
    switch (animalType) {
      case AnimalType.cow:
        return 'Cow';
      case AnimalType.buffalo:
        return 'Buffalo';
      case AnimalType.goat:
        return 'Goat';
      case AnimalType.hen:
        return 'Hen';
    }
  }

  // Gets the color associated with the animal type
  static Color getColor(AnimalType animalType) {
    switch (animalType) {
      case AnimalType.cow:
        return const Color(0xFFB2DFDB); // Light green for cows
      case AnimalType.buffalo:
        return const Color(0xFF80CBC4); // Teal for buffalo
      case AnimalType.goat:
        return const Color(0xFFFFF9C4); // Light yellow for goats
      case AnimalType.hen:
        return const Color(0xFFFFCDD2); // Light red for hens
    }
  }
}




/// Extension methods for AnimalType enum
extension AnimalTypeExtension on AnimalType {
  /// Gets the API ID for this animal type
  int get apiId => AnimalTypeUtils.getAnimalId(this);

  /// Gets the API string representation for this animal type
  String get apiString => AnimalTypeUtils.getApiString(this);

  /// Gets the display name for this animal type
  String get displayName => AnimalTypeUtils.getDisplayName(this);

  /// Gets the icon path for this animal type
  String get iconPath => AnimalTypeUtils.getIconPath(this);

  /// Gets the singular display name for this animal type
  String get singularDisplayName => AnimalTypeUtils.getSingularDisplayName(this);
}
