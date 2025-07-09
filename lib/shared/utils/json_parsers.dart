/// Utility functions for parsing JSON values
// ignore_for_file: inference_failure_on_untyped_parameter

class JsonParsers {
  /// Private constructor to prevent instantiation
  JsonParsers._();

  /// Parses a value that could be a string, number or null into a double
  static double? parseDouble(value) {
    print('Parsing double from: ${value?.runtimeType}: $value');

    if (value == null) {
      print('Value is null, returning null');
      return null;
    }

    if (value is double) {
      print('Value is already double: $value');
      return value;
    }

    if (value is num) {
      print('Value is num, converting to double: ${value.toDouble()}');
      return value.toDouble();
    }

    if (value is String) {
      try {
        // Try to parse the string as a double, accounting for possible whitespace
        final trimmed = value.trim();
        if (trimmed.isEmpty) {
          print('String is empty after trimming, returning null');
          return null;
        }
        final parsed = double.tryParse(trimmed);
        print('Parsed string "$value" to double: $parsed');
        return parsed;
      } catch (e) {
        print('Error parsing double from string "$value": $e');
        return null;
      }
    }

    if (value is bool) {
      print('Value is bool: $value, converting to ${value ? 1.0 : 0.0}');
      return value ? 1.0 : 0.0;
    }

    try {
      final stringValue = value.toString();
      final parsed = double.tryParse(stringValue);
      print('Tried parsing "$stringValue" to double: $parsed');
      return parsed;
    } catch (e) {
      print('Error parsing unknown type ${value.runtimeType} as double: $e');
      return null;
    }
  }

  /// Safely converts any value to a list
  static List<T> parseList<T>(value, T Function(dynamic) itemConverter) {
    if (value == null) return [];
    if (value is! List) return [];

    try {
      return List<T>.from(value.map((e) => itemConverter(e)));
    } catch (e) {
      print('Error parsing list: $e');
      return [];
    }
  }

  /// Safely converts any value to a map
  static Map<String, dynamic> parseMap(value) {
    if (value == null) return {};
    if (value is Map<String, dynamic>) return value;

    try {
      if (value is Map) {
        return Map<String, dynamic>.from(value);
      }
      return {};
    } catch (e) {
      print('Error parsing map: $e');
      return {};
    }
  }

  /// Parses a value that could be a string, number or null into an integer
  static int? parseNumber(value) {
    print('Parsing number from: ${value.runtimeType}: $value');

    if (value == null) {
      print('Value is null, returning null');
      return null;
    }

    if (value is int) {
      print('Value is already int: $value');
      return value;
    }

    if (value is num) {
      print('Value is num, converting to int: ${value.toInt()}');
      return value.toInt();
    }

    if (value is String) {
      try {
        // Try to parse the string as an int, accounting for possible whitespace
        final trimmed = value.trim();
        if (trimmed.isEmpty) {
          print('String is empty after trimming, returning null');
          return null;
        }
        final parsed = int.tryParse(trimmed);
        print('Parsed string "$value" to int: $parsed');
        return parsed;
      } catch (e) {
        print('Error parsing number from string "$value": $e');
        return null;
      }
    }

    if (value is bool) {
      print('Value is bool: $value, converting to ${value ? 1 : 0}');
      return value ? 1 : 0;
    }

    try {
      final stringValue = value.toString();
      final parsed = int.tryParse(stringValue);
      print('Tried parsing "$stringValue" to int: $parsed');
      return parsed;
    } catch (e) {
      print('Error parsing unknown type ${value.runtimeType} as number: $e');
      return null;
    }
  }

  /// Safely converts any value to a string
  static String? parseString(value) {
    if (value == null) return null;
    try {
      return value.toString();
    } catch (e) {
      print('Error parsing to string: $e');
      return '';
    }
  }

  /// Safely converts any value to a non-nullable string with fallback
  static String parseStringNonNull(value, {String defaultValue = ''}) {
    if (value == null) return defaultValue;
    try {
      return value.toString();
    } catch (e) {
      print('Error parsing to non-null string: $e');
      return defaultValue;
    }
  }
}
