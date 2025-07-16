import 'package:flutter/material.dart';
import 'package:powergodha/animal/models/animal_question_answer.dart';
import 'package:powergodha/dashboard/widgets/radio_buttons.dart';
import 'package:powergodha/dashboard/widgets/text_field.dart';

Widget buildQuestionField({
  required AnimalQuestionAnswer question,
  required bool isEditable,
  required BuildContext context,
}) {
  Future<void> selectDate(DateTime initialDate) async {
    await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      helpText: 'Select Record Date',
    );
  }

  switch (question.formType) {
    case 'EditText':
      return TextFieldOption(
        question: question.languageQuestion ?? '',
        editable: isEditable,
        controller: TextEditingController(text: question.answer ?? ''),
       
      );

    case 'RadioGridGroup':
      final options = (question.formTypeValue ?? '').split(',');
      return RadioOptions(
        question: question.languageQuestion ?? '',
        type1: options.isNotEmpty ? options[0] : '',
        type2: options.length > 1 ? options[1] : '',
        groupValue: question.answer ?? '',
        onChanged: (value) {},
      );

    case 'Date':
      return TextFieldOption(
        question: question.languageQuestion ?? '',
        controller: TextEditingController(text: question.answer ?? ''),
        icon: const Icon(Icons.calendar_month, size: 24),
        onIconTap: () => selectDate(DateTime.now()),
      );

    case 'Spinner':
      final items = (question.formTypeValue ?? '').split(',');
      return DropdownButtonFormField<String>(
        decoration: InputDecoration(labelText: question.languageQuestion),
        value: question.answer,
        items: items.map((value) => DropdownMenuItem(value: value, child: Text(value))).toList(),
        onChanged: (value) {},
      );

    default:
      return const SizedBox.shrink();
  }
}
