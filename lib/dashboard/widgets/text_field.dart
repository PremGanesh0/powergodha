import 'package:flutter/material.dart';

class TextFieldOption extends StatelessWidget {
  const TextFieldOption({
    required this.question,
    this.keyboardType = TextInputType.text,
    this.controller,
    this.icon,
    this.onIconTap,
    this.decoration,
    this.editable = true,
    super.key,

  });

  final String question;
  final Icon? icon;
  final VoidCallback? onIconTap;
  final TextEditingController? controller;
  final InputDecoration? decoration;
  final TextInputType keyboardType;
  final bool editable;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(question, style: const TextStyle(fontSize: 16 , fontWeight: FontWeight.bold)),
        SizedBox(
          height: 35,
          child: TextField(
            controller: controller,
            enabled: editable,
            style: const TextStyle(fontSize: 16),
            keyboardType:  keyboardType,
            decoration:
                decoration ??
                InputDecoration(
                  isDense: true,
                  suffixIcon: icon != null ? IconButton(onPressed: onIconTap, icon: icon!) : null,
                  suffixIconColor: Colors.green,
                  focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(width: 0.5)),
                  enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(width: 0.5)),
                ),
          ),
        ),
      ],
    );
  }
}
