/// Shared widgets for breeding record pages.
///
/// This file contains reusable UI components that are common across
/// different breeding record pages to promote code reusability and
/// maintain consistent design patterns.
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:powergodha/shared/shared.dart';

/// {@template animal_info_banner}
/// A green banner displaying animal type and number.
///
/// Provides a consistent header banner showing:
/// * Animal type and number in green background
/// * Rounded bottom corners
/// {@endtemplate}
class AnimalInfoBanner extends StatelessWidget {
  /// The type of animal (e.g., 'Cow', 'Buffalo', 'Goat')
  final String animalType;

  /// The animal identification number
  final String animalNumber;

  /// {@macro animal_info_banner}
  const AnimalInfoBanner({
    required this.animalType,
    required this.animalNumber,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 20.h),
      decoration: BoxDecoration(
        color: Colors.green[300],
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20.r),
          bottomRight: Radius.circular(20.r),
        ),
      ),
      child: Center(
        child: Text(
          '$animalType - $animalNumber',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

/// {@template breeding_action_button}
/// A reusable action button for breeding forms.
///
/// Provides a consistent button style with:
/// * Green background color
/// * White text
/// * Rounded corners
/// * Full width
/// {@endtemplate}
class BreedingActionButton extends StatelessWidget {
  /// The button text
  final String text;

  /// Called when the button is pressed
  final VoidCallback onPressed;

  /// Optional icon to display in the button
  final IconData? icon;

  /// {@macro breeding_action_button}
  const BreedingActionButton({
    required this.text,
    required this.onPressed,
    this.icon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50.h,
      child: icon != null
          ? ElevatedButton.icon(
              onPressed: onPressed,
              icon: Icon(
                icon,
                color: Colors.white,
                size: 20.sp,
              ),
              label: Text(
                text,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[400],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                elevation: 0,
              ),
            )
          : ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[400],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                elevation: 0,
              ),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
    );
  }
}

/// {@template breeding_app_bar}
/// A standardized app bar for breeding record pages.
///
/// Provides a consistent header with:
/// * Customizable title (defaults to "Animal Information")
/// * Menu icon (leading)
/// * Search and notification icons (actions)
/// * Notification badge automatically managed by HomeBloc
/// {@endtemplate}
class BreedingAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// The title to display in the app bar
  final String title;

  /// Called when the search icon is pressed
  final VoidCallback? onSearchPressed;

  /// Called when the notification icon is pressed
  final VoidCallback? onNotificationPressed;

  /// {@macro breeding_app_bar}
  const BreedingAppBar({
    this.title = 'Animal Information',
    this.onSearchPressed,
    this.onNotificationPressed,
    super.key,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          color: Colors.black87,
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.menu, color: Colors.black87),
        onPressed: () => Scaffold.of(context).openDrawer(),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: Colors.black87),
          onPressed: onSearchPressed ?? () {
            // TODO: Implement search
          },
        ),
        AppNotificationButton(
          onPressed: onNotificationPressed,
        ),
      ],
    );
  }
}

/// {@template breeding_date_field}
/// A reusable date input field for breeding forms.
///
/// Provides a consistent date field with:
/// * Label text
/// * Read-only text field showing formatted date
/// * Calendar icon that opens date picker
/// * Green accent color
/// {@endtemplate}
class BreedingDateField extends StatelessWidget {
  /// The label text displayed above the date field
  final String label;

  /// The controller for the date text field
  final TextEditingController controller;

  /// Called when the calendar icon is tapped
  final VoidCallback onTap;

  /// {@macro breeding_date_field}
  const BreedingDateField({
    required this.label,
    required this.controller,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 12.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(color: Colors.grey[300]!),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  readOnly: true,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.black87,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              GestureDetector(
                onTap: onTap,
                child: Icon(
                  Icons.calendar_month,
                  color: Colors.green[400],
                  size: 24.sp,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// {@template breeding_date_picker_helper}
/// A helper class for consistent date picker configuration across breeding pages.
/// {@endtemplate}
class BreedingDatePickerHelper {
  /// Formats a date to YYYY-MM-DD format consistently.
  static String formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  /// Shows a date picker with consistent styling for breeding pages.
  ///
  /// Returns the selected date or null if cancelled.
  static Future<DateTime?> showBreedingDatePicker({
    required BuildContext context,
    required DateTime initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
  }) async {
    return showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate ?? DateTime(2020),
      lastDate: lastDate ?? DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.green[400]!,
            ),
          ),
          child: child!,
        );
      },
    );
  }
}

/// {@template breeding_message_helper}
/// Helper class for displaying consistent success and error messages in breeding pages.
/// {@endtemplate}
class BreedingMessageHelper {
  /// Shows a standardized error message for breeding operations.
  ///
  /// Displays a red SnackBar for error messages.
  static void showErrorMessage(
    BuildContext context, {
    required String message,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red[400],
      ),
    );
  }

  /// Shows a standardized info message for breeding operations.
  ///
  /// Displays a blue SnackBar for informational messages.
  static void showInfoMessage(
    BuildContext context, {
    required String message,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.blue[400],
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Shows a standardized success message for breeding record operations.
  ///
  /// Displays a green SnackBar with a consistent message format:
  /// "[recordType] record saved for [animalType] #[animalNumber] on [date]"
  static void showSuccessMessage(
    BuildContext context, {
    required String recordType,
    required String animalType,
    required String animalNumber,
    required DateTime date,
    String? additionalInfo,
  }) {
    final dateStr = BreedingDatePickerHelper.formatDate(date);
    final message = additionalInfo != null
        ? '$recordType record saved for $animalType #$animalNumber - $additionalInfo on $dateStr'
        : '$recordType record saved for $animalType #$animalNumber on $dateStr';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green[400],
        duration: const Duration(seconds: 3),
      ),
    );
  }
}

/// {@template breeding_radio_group}
/// A reusable radio button group for breeding forms.
///
/// Provides a consistent radio button group with:
/// * Label text
/// * Two radio options with custom labels
/// * Green accent color
/// {@endtemplate}
class BreedingRadioGroup extends StatelessWidget {
  /// The label text displayed above the radio buttons
  final String label;

  /// The currently selected value
  final String value;

  /// Called when the selection changes
  final ValueChanged<String> onChanged;

  /// Label for the first radio option
  final String option1Label;

  /// Value for the first radio option
  final String option1Value;

  /// Label for the second radio option
  final String option2Label;

  /// Value for the second radio option
  final String option2Value;

  /// {@macro breeding_radio_group}
  const BreedingRadioGroup({
    required this.label,
    required this.value,
    required this.onChanged,
    required this.option1Label,
    required this.option1Value,
    required this.option2Label,
    required this.option2Value,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Row(
              children: [
                Radio<String>(
                  value: option1Value,
                  groupValue: value,
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      onChanged(newValue);
                    }
                  },
                  activeColor: Colors.green[400],
                ),
                Text(
                  option1Label,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            SizedBox(width: 40.w),
            Row(
              children: [
                Radio<String>(
                  value: option2Value,
                  groupValue: value,
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      onChanged(newValue);
                    }
                  },
                  activeColor: Colors.green[400],
                ),
                Text(
                  option2Label,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

/// {@template breeding_section_header}
/// A standardized section header for breeding pages.
///
/// Displays "Breeding Details" with consistent styling.
/// {@endtemplate}
class BreedingSectionHeader extends StatelessWidget {
  /// {@macro breeding_section_header}
  const BreedingSectionHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Breeding Details',
      style: TextStyle(
        fontSize: 20.sp,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }
}
