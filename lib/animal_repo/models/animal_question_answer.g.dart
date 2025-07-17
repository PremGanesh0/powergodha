// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'animal_question_answer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnimalQuestionAnswer _$AnimalQuestionAnswerFromJson(
  Map<String, dynamic> json,
) => AnimalQuestionAnswer(
  animalId: (json['animal_id'] as num).toInt(),
  questionId: (json['question_id'] as num).toInt(),
  date: (json['date'] as num).toInt(),
  constantValue: (json['constant_value'] as num).toInt(),
  questionTag: (json['question_tag'] as num).toInt(),
  questionUnit: (json['question_unit'] as num).toInt(),
  validationRule: json['validation_rule'] as String?,
  masterQuestion: json['master_question'] as String?,
  languageQuestion: json['language_question'] as String?,
  formType: json['form_type'] as String?,
  answer: json['answer'] as String?,
  formTypeValue: json['form_type_value'] as String?,
  languageFormTypeValue: json['language_form_type_value'] as String?,
  answerDate: json['answer_date'] as String?,
  animalNumber: json['animal_number'] as String?,
  hint: json['hint'] as String?,
  questionCreatedAt: json['question_created_at'] as String?,
);

Map<String, dynamic> _$AnimalQuestionAnswerToJson(
  AnimalQuestionAnswer instance,
) => <String, dynamic>{
  'animal_id': instance.animalId,
  if (instance.validationRule case final value?) 'validation_rule': value,
  if (instance.masterQuestion case final value?) 'master_question': value,
  if (instance.languageQuestion case final value?) 'language_question': value,
  'question_id': instance.questionId,
  if (instance.formType case final value?) 'form_type': value,
  'date': instance.date,
  if (instance.answer case final value?) 'answer': value,
  if (instance.formTypeValue case final value?) 'form_type_value': value,
  if (instance.languageFormTypeValue case final value?)
    'language_form_type_value': value,
  'constant_value': instance.constantValue,
  'question_tag': instance.questionTag,
  'question_unit': instance.questionUnit,
  if (instance.answerDate case final value?) 'answer_date': value,
  if (instance.animalNumber case final value?) 'animal_number': value,
  if (instance.hint case final value?) 'hint': value,
  if (instance.questionCreatedAt case final value?)
    'question_created_at': value,
};
