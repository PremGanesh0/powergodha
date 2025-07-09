import 'package:json_annotation/json_annotation.dart';
import 'package:powergodha/shared/utils/json_parsers.dart';

part 'animal_details_response.g.dart';

/// {@template animal_details_data}
/// Animal details data model.
///
/// This model represents the detailed information about animals of a specific type.
/// {@endtemplate}
@JsonSerializable()
class AnimalDetailsData {
  /// Creates an animal details data instance.
  AnimalDetailsData({
    this.animalName,
    this.pregnantAnimal,
    this.nonPregnantAnimal,
    this.lactating,
    this.nonLactating,
    this.animalData,
  }) {
    print('AnimalDetailsData constructor called with:');
    print('animalName: $animalName');
    print('pregnantAnimal: $pregnantAnimal');
    print('nonPregnantAnimal: $nonPregnantAnimal');
    print('lactating: $lactating');
    print('nonLactating: $nonLactating');
    print('animalData: ${animalData?.length} items');
  }

  /// Creates an [AnimalDetailsData] from JSON data.
  factory AnimalDetailsData.fromJson(Map<String, dynamic> json) {
    try {
      final animalData = <IndividualAnimalData>[];

      final rawAnimalData = json['animal_data'];
      if (rawAnimalData is List) {
        for (final item in rawAnimalData) {
          try {
            if (item is Map) {
              animalData.add(IndividualAnimalData.fromJson(Map<String, dynamic>.from(item)));
            }
          } catch (e) {
            print('Error parsing IndividualAnimalData item: $e');
          }
        }
      }

      return AnimalDetailsData(
        animalName: JsonParsers.parseString(json['animal_name']),
        pregnantAnimal: JsonParsers.parseNumber(json['pregnant_animal']),
        nonPregnantAnimal: JsonParsers.parseNumber(json['non_pregnant_animal']),
        lactating: JsonParsers.parseNumber(json['lactating']),
        nonLactating: JsonParsers.parseNumber(json['nonLactating']),
        animalData: animalData,
      );
    } catch (e) {
      print('Error parsing AnimalDetailsData: $e');
      return AnimalDetailsData(
        animalName: json['animal_name']?.toString(),
        animalData: [],
      );
    }
  }

  /// Name of the animal type.
  @JsonKey(name: 'animal_name')
  final String? animalName;

  /// Number of pregnant animals.
  @JsonKey(name: 'pregnant_animal')
  final int? pregnantAnimal;

  /// Number of non-pregnant animals.
  @JsonKey(name: 'non_pregnant_animal')
  final int? nonPregnantAnimal;

  /// Number of lactating animals.
  final int? lactating;

  /// Number of non-lactating animals.
  @JsonKey(name: 'nonLactating')
  final int? nonLactating;

  /// List of individual animal data.
  @JsonKey(name: 'animal_data')
  final List<IndividualAnimalData>? animalData;

  /// Converts this data to JSON.
  Map<String, dynamic> toJson() => _$AnimalDetailsDataToJson(this);
}

/// {@template animal_details_response}
/// Response model for animal details based on animal type from API endpoints.
///
/// This model represents the structure returned by the `/animal_details_based_on_animal_type` endpoint.
/// It contains detailed information about animals of a specific type.
/// {@endtemplate}
@JsonSerializable()
class AnimalDetailsResponse {
  /// Creates an animal details response instance.
  const AnimalDetailsResponse({this.data, this.message, this.status});

  /// Creates an [AnimalDetailsResponse] from JSON data.
  factory AnimalDetailsResponse.fromJson(Map<String, dynamic> json) {
    try {
      return AnimalDetailsResponse(
        data: json['data'] == null
            ? null
            : AnimalDetailsData.fromJson(JsonParsers.parseMap(json['data'])),
        message: JsonParsers.parseString(json['message']),
        status: JsonParsers.parseNumber(json['status']),
      );
    } catch (e) {
      print('Error parsing AnimalDetailsResponse: $e');
      return AnimalDetailsResponse(
        message: json['message']?.toString(),
        status: JsonParsers.parseNumber(json['status']),
      );
    }
  }

  /// Animal details data.
  final AnimalDetailsData? data;

  /// Response message.
  final String? message;

  /// HTTP status code.
  final int? status;

  /// Converts this response to JSON.
  Map<String, dynamic> toJson() => _$AnimalDetailsResponseToJson(this);
}

/// {@template individual_animal_data}
/// Individual animal data model.
///
/// This model represents detailed information about a single animal.
/// {@endtemplate}
@JsonSerializable()
class IndividualAnimalData {
  /// Creates an individual animal data instance.
  IndividualAnimalData({
    this.id,
    this.animalNumber,
    this.dateOfBirth,
    this.weight,
    this.breed,
    this.gender,
    this.status,
    this.pregnancyStatus,
    this.lactationStatus,
    this.healthStatus,
  }) {
    print('IndividualAnimalData constructor called with:');
    print('id: $id (${id.runtimeType})');
    print('animalNumber: $animalNumber (${animalNumber.runtimeType})');
    print('dateOfBirth: $dateOfBirth (${dateOfBirth?.runtimeType})');
    print('weight: $weight (${weight?.runtimeType})');
    print('breed: $breed (${breed?.runtimeType})');
    print('gender: $gender (${gender?.runtimeType})');
    print('status: $status (${status?.runtimeType})');
    print('pregnancyStatus: $pregnancyStatus (${pregnancyStatus?.runtimeType})');
    print('lactationStatus: $lactationStatus (${lactationStatus?.runtimeType})');
    print('healthStatus: $healthStatus (${healthStatus?.runtimeType})');
  }

  /// Creates an [IndividualAnimalData] from JSON data.
  factory IndividualAnimalData.fromJson(Map<String, dynamic> json) {
    try {
      return IndividualAnimalData(
        id: JsonParsers.parseNumber(json['id']),
        animalNumber: _parseAnimalNumber(json['animal_number']),
        dateOfBirth: JsonParsers.parseString(json['date_of_birth']),
        weight: JsonParsers.parseDouble(json['weight']),
        breed: JsonParsers.parseString(json['breed']),
        gender: JsonParsers.parseString(json['gender']),
        status: JsonParsers.parseString(json['status']),
        pregnancyStatus: JsonParsers.parseString(json['pregnant_status']),
        lactationStatus: JsonParsers.parseString(json['lactating_status']),
        healthStatus: JsonParsers.parseString(json['health_status']),
      );
    } catch (e) {
      print('Error parsing IndividualAnimalData: $e');
      return IndividualAnimalData();
    }
  }

  /// Animal ID.
  final int? id;

  /// Animal identification number.
  @JsonKey(
    name: 'animal_number',
    fromJson: _parseAnimalNumber,
  )
  final int? animalNumber;

  /// Date of birth.
  @JsonKey(name: 'date_of_birth')
  final String? dateOfBirth;

  /// Weight of the animal.
  final double? weight;

  /// Breed of the animal.
  final String? breed;

  /// Gender of the animal.
  final String? gender;

  /// Current status of the animal.
  final String? status;

  /// Pregnancy status (if applicable).
  @JsonKey(name: 'pregnant_status')
  final String? pregnancyStatus;

  /// Lactation status (if applicable).
  @JsonKey(name: 'lactating_status')
  final String? lactationStatus;

  /// Health status.
  @JsonKey(name: 'health_status')
  final String? healthStatus;

  /// Converts this data to JSON.
  Map<String, dynamic> toJson() => _$IndividualAnimalDataToJson(this);

  /// Parses animal number from various formats
  static int? _parseAnimalNumber(value) {
    print('_parseAnimalNumber called with: ${value?.runtimeType}: $value');
    try {
      if (value == null) {
        print('Animal number is null');
        return null;
      }

      if (value is int) {
        print('Animal number is already int: $value');
        return value;
      }

      if (value is num) {
        print('Animal number is num, converting to int: ${value.toInt()}');
        return value.toInt();
      }

      if (value is String) {
        print('Animal number is String: $value');
        if (value.trim().isEmpty) {
          print('Empty string, returning null');
          return null;
        }

        final parsed = int.tryParse(value);
        print('Parsed animal number to: $parsed');
        return parsed;
      }

      print('Unknown type for animal_number: ${value.runtimeType}');
      return null;
    } catch (e, stackTrace) {
      print('Error in _parseAnimalNumber: $e');
      print('Stack trace: $stackTrace');
      return null;
    }
  }
}
