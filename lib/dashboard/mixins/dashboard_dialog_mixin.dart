import 'package:flutter/material.dart';

/// Mixin for common dialog and toast functionality
mixin DashboardDialogMixin {
  /// Shows add animal dialog
  void showAddAnimalDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Animal'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Register a new animal in your farm.'),
              SizedBox(height: 16),
              Text('Information to capture:'),
              SizedBox(height: 8),
              Text('• Animal type and breed'),
              Text('• Age and gender'),
              Text('• Health status'),
              Text('• Purchase details'),
              Text('• Identification tags'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Add Animal feature coming soon!'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text('Add Animal'),
            ),
          ],
        );
      },
    );
  }


  /// Shows a coming soon toast message for animal types
  void showComingSoonToast(BuildContext context, String animalType) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$animalType management coming soon!'),
        backgroundColor: Colors.orange,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
  /// Shows a coming soon toast message for animal types
  void showToast(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.orange,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  /// Shows update animal dialog
  void showUpdateAnimalDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Update Animal'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Update existing animal information.'),
              SizedBox(height: 16),
              Text('Available updates:'),
              SizedBox(height: 8),
              Text('• Health records'),
              Text('• Breeding status'),
              Text('• Weight tracking'),
              Text('• Vaccination history'),
              Text('• Production records'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Update Animal feature coming soon!'),
                    backgroundColor: Colors.blue,
                  ),
                );
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }
}
