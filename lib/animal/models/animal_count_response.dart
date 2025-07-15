// ignore_for_file: inference_failure_on_untyped_parameter

import 'package:json_annotation/json_annotation.dart';
import 'package:powergodha/app/app_logger_config.dart';

part 'animal_count_response.g.dart';

/// {@template animal_count_data}
/// Individual animal count data model.
///
/// This model represents each animal type and its count in the response.
/// {@endtemplate}
@JsonSerializable()
class AnimalCountData {
  /// Creates an animal count data instance.
  const AnimalCountData({required this.animalId, this.cow, this.buffalo, this.goat, this.hen});

  /// Creates an [AnimalCountData] from JSON data.
  factory AnimalCountData.fromJson(Map<String, dynamic> json) {
    try {
      return _$AnimalCountDataFromJson(json);
    } catch (e) {
      AppLogger.error('Error parsing AnimalCountData: $e');
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
  const AnimalCountResponse({required this.data, required this.message, required this.status});

  /// Creates an [AnimalCountResponse] from JSON data.
  factory AnimalCountResponse.fromJson(Map<String, dynamic> json) {
    try {
      return _$AnimalCountResponseFromJson(json);
    } catch (e) {
      AppLogger.error('Error parsing AnimalCountResponse: $e');
      return AnimalCountResponse(
        data: [],
        message: json['message']?.toString() ?? '',
        status: json['status'] is int ? (json['status'] as int) : 500,
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
}
