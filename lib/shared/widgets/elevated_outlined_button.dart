import 'package:flutter/material.dart';

ElevatedButton elevatedButton(String text, VoidCallback onTap) {
  return ElevatedButton(
    onPressed: onTap,
    style: ElevatedButton.styleFrom(
      elevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.green,
      minimumSize: const Size(double.infinity, 20),
      padding: const EdgeInsets.symmetric(vertical: 12),
      side: const BorderSide(color: Colors.grey, width: 2),
      shape: const RoundedRectangleBorder(),
    ),
    child: Text(text),
  );
}
