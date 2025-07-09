// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'animal_count_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnimalCountResponse _$AnimalCountResponseFromJson(Map<String, dynamic> json) =>
    AnimalCountResponse(
      data: (json['data'] as List<dynamic>)
          .map((e) => AnimalCountData.fromJson(e as Map<String, dynamic>))
          .toList(),
      message: json['message'] as String,
      status: (json['status'] as num).toInt(),
    );

Map<String, dynamic> _$AnimalCountResponseToJson(
  AnimalCountResponse instance,
) => <String, dynamic>{
  'data': instance.data.map((e) => e.toJson()).toList(),
  'message': instance.message,
  'status': instance.status,
};

AnimalCountData _$AnimalCountDataFromJson(Map<String, dynamic> json) =>
    AnimalCountData(
      animalId: (json['animal_id'] as num).toInt(),
      cow: (json['Cow'] as num?)?.toInt(),
      buffalo: (json['Buffalo'] as num?)?.toInt(),
      goat: (json['Goat'] as num?)?.toInt(),
      hen: (json['Hen'] as num?)?.toInt(),
    );

Map<String, dynamic> _$AnimalCountDataToJson(AnimalCountData instance) =>
    <String, dynamic>{
      'animal_id': instance.animalId,
      if (instance.cow case final value?) 'Cow': value,
      if (instance.buffalo case final value?) 'Buffalo': value,
      if (instance.goat case final value?) 'Goat': value,
      if (instance.hen case final value?) 'Hen': value,
    };
