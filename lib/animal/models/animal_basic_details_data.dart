import 'package:json_annotation/json_annotation.dart';

import 'animal_question_answer.dart';

part 'animal_basic_details_data.g.dart';

@JsonSerializable()
class AnimalBasicDetailsData {
  const AnimalBasicDetailsData({
    required this.questions,
    this.isEditable = true,
  });

  factory AnimalBasicDetailsData.fromJson(Map<String, dynamic> json, {bool isEditable = true}) {
    final data = _$AnimalBasicDetailsDataFromJson(json);
    // Update each question's editable state based on the global flag
    final updatedQuestions = data.questions.map((q) =>
      AnimalQuestionAnswer(
        animalId: q.animalId,
        validationRule: q.validationRule,
        masterQuestion: q.masterQuestion,
        languageQuestion: q.languageQuestion,
        questionId: q.questionId,
        formType: q.formType,
        date: q.date,
        answer: q.answer,
        formTypeValue: q.formTypeValue,
        languageFormTypeValue: q.languageFormTypeValue,
        constantValue: q.constantValue,
        questionTag: q.questionTag,
        questionUnit: q.questionUnit,
        answerDate: q.answerDate,
        animalNumber: q.animalNumber,
        hint: q.hint,
        questionCreatedAt: q.questionCreatedAt,

      )
    ).toList();

    return AnimalBasicDetailsData(
      questions: updatedQuestions,
      isEditable: isEditable,
    );
  }

  @JsonKey(
    name:
        'Provide birth and population details of animals at your farm by answering questions below',
  )
  final List<AnimalQuestionAnswer> questions;

  @JsonKey(ignore: true)
  final bool isEditable;

  Map<String, dynamic> toJson() => _$AnimalBasicDetailsDataToJson(this);
}
