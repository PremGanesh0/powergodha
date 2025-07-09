import 'package:json_annotation/json_annotation.dart';
import 'package:powergodha/shared/utils/json_parsers.dart';

part 'animal_info_response.g.dart';

/// {@template animal_info_response}
/// Response model for animal information from API endpoints.
///
/// This model represents the structure returned by the `/animal_info/{id}` endpoint.
/// It contains detailed information about a specific animal type.
/// {@endtemplate}
@JsonSerializable()
class AnimalInfoResponse {
  /// Creates an animal info response instance.
  const AnimalInfoResponse({
    required this.data,
    required this.message,
    required this.status,
  });

  /// Creates an [AnimalInfoResponse] from JSON data.
  factory AnimalInfoResponse.fromJson(Map<String, dynamic> json) {
    try {
      return _$AnimalInfoResponseFromJson(json);
    } catch (e) {
      print('Error parsing AnimalInfoResponse: $e');
      return AnimalInfoResponse(
        data: [],
        message: json['message']?.toString() ?? '',
        status: _parseStatus(json['status']),
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
  
  /// Parse status from various formats
  static int _parseStatus(value) {
    return JsonParsers.parseNumber(value) ?? 0;
  }
}

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
      return AnimalInfoData(
        cow: _parseAnimalCount(json['Cow']),
        buffalo: _parseAnimalCount(json['Buffalo']),
        goat: _parseAnimalCount(json['Goat']),
        hen: _parseAnimalCount(json['Hen']),
        male: _parseAnimalCount(json['male']),
        female: _parseAnimalCount(json['female']),
        heifer: _parseAnimalCount(json['heifer']),
        bull: _parseAnimalCount(json['bull']),
        calf: _parseAnimalCount(json['calf']),
      );
    } catch (e) {
      print('Error parsing AnimalInfoData: $e');
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
  
  /// Parse animal count from various formats (could be string, int or null)
  static int? _parseAnimalCount(value) {
    return JsonParsers.parseNumber(value);
  }

  /// Converts this data to JSON.
  Map<String, dynamic> toJson() => _$AnimalInfoDataToJson(this);

  /// Gets the count value for this data entry.
  int get count => cow ?? buffalo ?? goat ?? hen ?? male ?? female ?? heifer ?? bull ?? calf ?? 0;

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
}
