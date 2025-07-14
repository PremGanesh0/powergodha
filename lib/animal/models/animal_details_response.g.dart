// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'animal_details_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnimalDetailsData _$AnimalDetailsDataFromJson(Map<String, dynamic> json) =>
    AnimalDetailsData(
      animalName: json['animal_name'] as String?,
      pregnantAnimal: (json['pregnant_animal'] as num?)?.toInt(),
      nonPregnantAnimal: (json['non_pregnant_animal'] as num?)?.toInt(),
      lactating: (json['lactating'] as num?)?.toInt(),
      nonLactating: (json['nonLactating'] as num?)?.toInt(),
      animalData: (json['animal_data'] as List<dynamic>?)
          ?.map((e) => IndividualAnimalData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AnimalDetailsDataToJson(
  AnimalDetailsData instance,
) => <String, dynamic>{
  if (instance.animalName case final value?) 'animal_name': value,
  if (instance.pregnantAnimal case final value?) 'pregnant_animal': value,
  if (instance.nonPregnantAnimal case final value?)
    'non_pregnant_animal': value,
  if (instance.lactating case final value?) 'lactating': value,
  if (instance.nonLactating case final value?) 'nonLactating': value,
  if (instance.animalData?.map((e) => e.toJson()).toList() case final value?)
    'animal_data': value,
};

AnimalDetailsResponse _$AnimalDetailsResponseFromJson(
  Map<String, dynamic> json,
) => AnimalDetailsResponse(
  data: json['data'] == null
      ? null
      : AnimalDetailsData.fromJson(json['data'] as Map<String, dynamic>),
  message: json['message'] as String?,
  status: (json['status'] as num?)?.toInt(),
);

Map<String, dynamic> _$AnimalDetailsResponseToJson(
  AnimalDetailsResponse instance,
) => <String, dynamic>{
  if (instance.data?.toJson() case final value?) 'data': value,
  if (instance.message case final value?) 'message': value,
  if (instance.status case final value?) 'status': value,
};

IndividualAnimalData _$IndividualAnimalDataFromJson(
  Map<String, dynamic> json,
) => IndividualAnimalData(
  id: (json['id'] as num?)?.toInt(),
  animalNumber: IndividualAnimalData._parseAnimalNumber(json['animal_number']),
  dateOfBirth: json['date_of_birth'] as String?,
  weight: (json['weight'] as num?)?.toDouble(),
  breed: json['breed'] as String?,
  gender: json['gender'] as String?,
  status: json['status'] as String?,
  pregnancyStatus: json['pregnant_status'] as String?,
  lactationStatus: json['lactating_status'] as String?,
  healthStatus: json['health_status'] as String?,
);

Map<String, dynamic> _$IndividualAnimalDataToJson(
  IndividualAnimalData instance,
) => <String, dynamic>{
  if (instance.id case final value?) 'id': value,
  if (instance.animalNumber case final value?) 'animal_number': value,
  if (instance.dateOfBirth case final value?) 'date_of_birth': value,
  if (instance.weight case final value?) 'weight': value,
  if (instance.breed case final value?) 'breed': value,
  if (instance.gender case final value?) 'gender': value,
  if (instance.status case final value?) 'status': value,
  if (instance.pregnancyStatus case final value?) 'pregnant_status': value,
  if (instance.lactationStatus case final value?) 'lactating_status': value,
  if (instance.healthStatus case final value?) 'health_status': value,
};
