// ignore_for_file: inference_failure_on_untyped_parameter

import 'package:json_annotation/json_annotation.dart';
import 'package:powergodha/shared/utils/json_parsers.dart';

part 'animal_count_response.g.dart';

/// {@template animal_count_data}
/// Individual animal count data model.
///
/// This model represents each animal type and its count in the response.
/// {@endtemplate}
@JsonSerializable()
class AnimalCountData {
  /// Creates an animal count data instance.
  const AnimalCountData({
    required this.animalId,
    this.cow,
    this.buffalo,
    this.goat,
    this.hen,
  });

  /// Creates an [AnimalCountData] from JSON data.
  factory AnimalCountData.fromJson(Map<String, dynamic> json) {
    try {
      final animalId = _parseAnimalId(json['animal_id']);
      final cow = _parseAnimalCount(json['Cow']);
      final buffalo = _parseAnimalCount(json['Buffalo']);
      final goat = _parseAnimalCount(json['Goat']);
      final hen = _parseAnimalCount(json['Hen']);

      return AnimalCountData(
        animalId: animalId,
        cow: cow,
        buffalo: buffalo,
        goat: goat,
        hen: hen,
      );
    } catch (e) {
      print('Error parsing AnimalCountData: $e');
      return const AnimalCountData(animalId: 0);
    }
  }

  /// Animal identifier.
  @JsonKey(name: 'animal_id')
  final int animalId;

  /// Number of cows (nullable as each object contains only one animal type).
  @JsonKey(name: 'Cow')
  final int? cow;

  /// Number of buffalo (nullable as each object contains only one animal type).
  @JsonKey(name: 'Buffalo')
  final int? buffalo;

  /// Number of goats (nullable as each object contains only one animal type).
  @JsonKey(name: 'Goat')
  final int? goat;

  /// Number of hens (nullable as each object contains only one animal type).
  @JsonKey(name: 'Hen')
  final int? hen;

  /// Gets the animal type name.
  String get animalType {
    if (cow != null) return 'Cow';
    if (buffalo != null) return 'Buffalo';
    if (goat != null) return 'Goat';
    if (hen != null) return 'Hen';
    return 'Unknown';
  }

  /// Gets the count value for this animal type.
  int get count => cow ?? buffalo ?? goat ?? hen ?? 0;

  /// Converts this data to JSON.
  Map<String, dynamic> toJson() => _$AnimalCountDataToJson(this);

  /// Parse animal count from various formats (could be string, int or null)
  static int? _parseAnimalCount(value) {
    return JsonParsers.parseNumber(value);
  }

  /// Parse animal ID from various formats
  static int _parseAnimalId(value) {
    return JsonParsers.parseNumber(value) ?? 0;
  }
}

/// {@template animal_count_response}
/// Response model for user animal count from API endpoints.
///
/// This model represents the structure returned by the `/user_animal_count` endpoint.
/// It contains the count of different animals owned by the user.
/// {@endtemplate}
@JsonSerializable()
class AnimalCountResponse {
  /// Creates an animal count response instance.
  const AnimalCountResponse({
    required this.data,
    required this.message,
    required this.status,
  });

  /// Creates an [AnimalCountResponse] from JSON data.
  factory AnimalCountResponse.fromJson(Map<String, dynamic> json) {
    try {
      return _$AnimalCountResponseFromJson(json);
    } catch (e) {
      print('Error parsing AnimalCountResponse: $e');
      return AnimalCountResponse(
        data: [],
        message: json['message']?.toString() ?? '',
        status: _parseStatus(json['status']),
      );
    }
  }

  /// List of animal count data.
  final List<AnimalCountData> data;

  /// Response message.
  final String message;

  /// HTTP status code.
  final int status;

  /// Converts this response to JSON.
  Map<String, dynamic> toJson() => _$AnimalCountResponseToJson(this);

  /// Parse status from various formats
  static int _parseStatus(value) {
    return JsonParsers.parseNumber(value) ?? 0;
  }
}
