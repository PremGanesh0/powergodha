import 'package:json_annotation/json_annotation.dart';

part 'animal_question_answer.g.dart';

@JsonSerializable()
class AnimalQuestionAnswer {



  const AnimalQuestionAnswer({
    required this.animalId,
    required this.questionId, required this.date, required this.constantValue, required this.questionTag, required this.questionUnit, this.validationRule,
    this.masterQuestion,
    this.languageQuestion,
    this.formType,
    this.answer,
    this.formTypeValue,
    this.languageFormTypeValue,
    this.answerDate,
    this.animalNumber,
    this.hint,
    this.questionCreatedAt,
  });

  factory AnimalQuestionAnswer.fromJson(Map<String, dynamic> json) =>
      _$AnimalQuestionAnswerFromJson(json);
  @JsonKey(name: 'animal_id')
  final int animalId;

  @JsonKey(name: 'validation_rule')
  final String? validationRule;

  @JsonKey(name: 'master_question')
  final String? masterQuestion;

  @JsonKey(name: 'language_question')
  final String? languageQuestion;

  @JsonKey(name: 'question_id')
  final int questionId;

  @JsonKey(name: 'form_type')
  final String? formType;

  final int date;
  final String? answer;

  @JsonKey(name: 'form_type_value')
  final String? formTypeValue;

  @JsonKey(name: 'language_form_type_value')
  final String? languageFormTypeValue;

  @JsonKey(name: 'constant_value')
  final int constantValue;

  @JsonKey(name: 'question_tag')
  final int questionTag;

  @JsonKey(name: 'question_unit')
  final int questionUnit;

  @JsonKey(name: 'answer_date')
  final String? answerDate;

  @JsonKey(name: 'animal_number')
  final String? animalNumber;

  final String? hint;

  @JsonKey(name: 'question_created_at')
  final String? questionCreatedAt;

  Map<String, dynamic> toJson() => _$AnimalQuestionAnswerToJson(this);
}
