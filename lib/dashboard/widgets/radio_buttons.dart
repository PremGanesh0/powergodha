import 'package:flutter/material.dart';

class RadioOptions extends StatelessWidget {
  const RadioOptions({required this.question, required this.type1, required this.type2, required this.groupValue, required this.onChanged, super.key});

  final String type1;
  final String type2;
  final String question;
  final String groupValue;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(question, style: const TextStyle(fontSize: 16)),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Radio<String>(
              value: type1,
              groupValue: groupValue,
              visualDensity: VisualDensity.compact,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              onChanged: onChanged,
            ),
            Text(type1, style: const TextStyle(fontSize: 16)),
            Radio<String>(
              value: type2,
              groupValue: groupValue,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              onChanged: onChanged,
            ),
            Text(type2, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ],
    );
  }
}
