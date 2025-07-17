// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'animal_info_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnimalInfoData _$AnimalInfoDataFromJson(Map<String, dynamic> json) =>
    AnimalInfoData(
      cow: (json['Cow'] as num?)?.toInt(),
      buffalo: (json['Buffalo'] as num?)?.toInt(),
      goat: (json['Goat'] as num?)?.toInt(),
      hen: (json['Hen'] as num?)?.toInt(),
      male: (json['male'] as num?)?.toInt(),
      female: (json['female'] as num?)?.toInt(),
      heifer: (json['heifer'] as num?)?.toInt(),
      bull: (json['bull'] as num?)?.toInt(),
      calf: (json['calf'] as num?)?.toInt(),
    );

Map<String, dynamic> _$AnimalInfoDataToJson(AnimalInfoData instance) =>
    <String, dynamic>{
      if (instance.cow case final value?) 'Cow': value,
      if (instance.buffalo case final value?) 'Buffalo': value,
      if (instance.goat case final value?) 'Goat': value,
      if (instance.hen case final value?) 'Hen': value,
      if (instance.male case final value?) 'male': value,
      if (instance.female case final value?) 'female': value,
      if (instance.heifer case final value?) 'heifer': value,
      if (instance.bull case final value?) 'bull': value,
      if (instance.calf case final value?) 'calf': value,
    };

AnimalInfoResponse _$AnimalInfoResponseFromJson(Map<String, dynamic> json) =>
    AnimalInfoResponse(
      data: (json['data'] as List<dynamic>)
          .map((e) => AnimalInfoData.fromJson(e as Map<String, dynamic>))
          .toList(),
      message: json['message'] as String,
      status: (json['status'] as num).toInt(),
    );

Map<String, dynamic> _$AnimalInfoResponseToJson(AnimalInfoResponse instance) =>
    <String, dynamic>{
      'data': instance.data.map((e) => e.toJson()).toList(),
      'message': instance.message,
      'status': instance.status,
    };
