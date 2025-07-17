// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'animal_basic_details_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnimalBasicDetailsData _$AnimalBasicDetailsDataFromJson(
  Map<String, dynamic> json,
) => AnimalBasicDetailsData(
  questions:
      (json['Provide birth and population details of animals at your farm by answering questions below']
              as List<dynamic>)
          .map((e) => AnimalQuestionAnswer.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$AnimalBasicDetailsDataToJson(
  AnimalBasicDetailsData instance,
) => <String, dynamic>{
  'Provide birth and population details of animals at your farm by answering questions below':
      instance.questions.map((e) => e.toJson()).toList(),
};
