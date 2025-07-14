import 'package:json_annotation/json_annotation.dart';

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

      return _$AnimalDetailsDataFromJson(
        json,
      ).copyWith(animalData: animalData.isNotEmpty ? animalData : null,
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

  /// Creates a copy of this object with the given fields replaced with new values.
  AnimalDetailsData copyWith({
    String? animalName,
    int? pregnantAnimal,
    int? nonPregnantAnimal,
    int? lactating,
    int? nonLactating,
    List<IndividualAnimalData>? animalData,
  }) {
    return AnimalDetailsData(
      animalName: animalName ?? this.animalName,
      pregnantAnimal: pregnantAnimal ?? this.pregnantAnimal,
      nonPregnantAnimal: nonPregnantAnimal ?? this.nonPregnantAnimal,
      lactating: lactating ?? this.lactating,
      nonLactating: nonLactating ?? this.nonLactating,
      animalData: animalData ?? this.animalData,
    );
  }

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
      return _$AnimalDetailsResponseFromJson(json);
    } catch (e) {
      print('Error parsing AnimalDetailsResponse: $e');
      return AnimalDetailsResponse(
        message: json['message']?.toString(),
        status: json['status'] is int ? (json['status'] as int) : 500,
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
      return _$IndividualAnimalDataFromJson(json);
    } catch (e) {
      print('Error parsing IndividualAnimalData: $e');
      return IndividualAnimalData();
    }
  }

  /// Animal ID.
  final int? id;

  /// Animal identification number.
  /// Changed from int to String to accommodate formats like "cow 1"
  @JsonKey(name: 'animal_number')
  final String? animalNumber;

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
}
