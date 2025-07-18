import 'package:json_annotation/json_annotation.dart';
import 'package:powergodha/app/app_logger_config.dart';
import 'package:powergodha/shared/enums.dart';

part 'animal_info_response.g.dart';

/// {@template animal_info_data}
/// Individual animal info data model.
///
/// This model represents each category of animal information in the response.
/// {@endtemplate}
@JsonSerializable()
class AnimalInfoData {
  /// Creates an animal info data instance.
  const AnimalInfoData({
    this.cow,
    this.buffalo,
    this.goat,
    this.hen,
    this.male,
    this.female,
    this.heifer,
    this.bull,
    this.calf,
  });

  /// Creates an [AnimalInfoData] from JSON data.
  factory AnimalInfoData.fromJson(Map<String, dynamic> json) {
    try {
      return _$AnimalInfoDataFromJson(json);
    } catch (e) {
      AppLogger.error('Error parsing AnimalInfoData: $e');
      return const AnimalInfoData();
    }
  }

  /// Total count of this animal type.
  @JsonKey(name: 'Cow')
  final int? cow;

  /// Total count of buffalo.
  @JsonKey(name: 'Buffalo')
  final int? buffalo;

  /// Total count of goats.
  @JsonKey(name: 'Goat')
  final int? goat;

  /// Total count of hens.
  @JsonKey(name: 'Hen')
  final int? hen;

  /// Number of male animals.
  final int? male;

  /// Number of female animals.
  final int? female;

  /// Number of heifers.
  final int? heifer;

  /// Number of bulls.
  final int? bull;

  /// Number of calves.
  final int? calf;

  /// Gets the AnimalType for this data entry if it represents a specific animal type.
  AnimalType? get animalType {
    if (cow != null) return AnimalType.cow;
    if (buffalo != null) return AnimalType.buffalo;
    if (goat != null) return AnimalType.goat;
    if (hen != null) return AnimalType.hen;
    return null;
  }

  /// Gets the category name for this data entry.
  String get category {
    if (cow != null) return 'Total Cows';
    if (buffalo != null) return 'Total Buffalo';
    if (goat != null) return 'Total Goats';
    if (hen != null) return 'Total Hens';
    if (male != null) return 'Male';
    if (female != null) return 'Female';
    if (heifer != null) return 'Heifer';
    if (bull != null) return 'Bull';
    if (calf != null) return 'Calf';
    return 'Unknown';
  }

  /// Gets the count value for this data entry.
  int get count => cow ?? buffalo ?? goat ?? hen ?? male ?? female ?? heifer ?? bull ?? calf ?? 0;

  /// Converts this data to JSON.
  Map<String, dynamic> toJson() => _$AnimalInfoDataToJson(this);
}

/// {@template animal_info_response}
/// Response model for animal information from API endpoints.
///
/// This model represents the structure returned by the `/animal_info/{id}` endpoint.
/// It contains detailed information about a specific animal type.
/// {@endtemplate}
@JsonSerializable()
class AnimalInfoResponse {
  /// Creates an animal info response instance.
  const AnimalInfoResponse({required this.data, required this.message, required this.status});

  /// Creates an [AnimalInfoResponse] from JSON data.
  factory AnimalInfoResponse.fromJson(Map<String, dynamic> json) {
    try {
      return _$AnimalInfoResponseFromJson(json);
    } catch (e) {
      AppLogger.error('Error parsing AnimalInfoResponse: $e');
      return AnimalInfoResponse(
        data: [],
        message: json['message']?.toString() ?? '',
        status: json['status'] is int ? (json['status'] as int) : 500,
      );
    }
  }

  /// List of animal info data with different categories.
  final List<AnimalInfoData> data;

  /// Response message.
  final String message;

  /// HTTP status code.
  final int status;

  /// Converts this response to JSON.
  Map<String, dynamic> toJson() => _$AnimalInfoResponseToJson(this);
}
