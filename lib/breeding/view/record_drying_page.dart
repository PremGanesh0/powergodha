/// Record Drying page for capturing animal drying events.
///
/// This page allows users to record drying events for their animals
/// including the type of drying and date information.
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:powergodha/breeding/widgets/breeding_shared_widgets.dart';

/// {@template record_drying_page}
/// A page for recording animal drying events.
///
/// This page provides functionality for:
/// * Recording the type of drying (Manual/Natural)
/// * Recording the date of drying
/// * Saving and submitting drying data
/// * Viewing previous drying records
/// {@endtemplate}
class RecordDryingPage extends StatefulWidget {

  /// {@macro record_drying_page}
  const RecordDryingPage({
    required this.animalType,
    required this.animalNumber,
    super.key,
  });
  /// The type of animal (e.g., 'Cow', 'Buffalo', 'Goat')
  final String animalType;

  /// The animal identification number
  final String animalNumber;

  @override
  State<RecordDryingPage> createState() => _RecordDryingPageState();

  /// Creates a route to the record drying page
  static Route<void> route({
    required String animalType,
    required String animalNumber,
  }) {
    return MaterialPageRoute<void>(
      builder: (_) => RecordDryingPage(
        animalType: animalType,
        animalNumber: animalNumber,
      ),
    );
  }
}

class _RecordDryingPageState extends State<RecordDryingPage> {
  DateTime _selectedDate = DateTime.now();
  final TextEditingController _dateController = TextEditingController();
  String _selectedDryingType = 'Manual'; // Default selection

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: const BreedingAppBar(),
      body: Column(
        children: [
          // Green banner with animal info
          AnimalInfoBanner(
            animalType: widget.animalType,
            animalNumber: widget.animalNumber,
          ),

          Expanded(
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Breeding Details section
                  const BreedingSectionHeader(),
                  SizedBox(height: 32.h),

                  // Type of drying section
                  BreedingRadioGroup(
                    label: 'Type of drying',
                    value: _selectedDryingType,
                    onChanged: (value) {
                      setState(() {
                        _selectedDryingType = value;
                      });
                    },
                    option1Label: 'Manual',
                    option1Value: 'Manual',
                    option2Label: 'Natural',
                    option2Value: 'Natural',
                  ),

                  SizedBox(height: 40.h),

                  // Date of drying section
                  BreedingDateField(
                    label: 'Date of drying',
                    controller: _dateController,
                    onTap: _selectDate,
                  ),

                  const Spacer(),

                  // Save and Submit button
                  BreedingActionButton(
                    text: 'Save and Submit',
                    onPressed: _saveAndSubmit,
                  ),

                  SizedBox(height: 16.h),

                  // View previous drying records button
                  BreedingActionButton(
                    text: 'View previous drying records',
                    icon: Icons.add,
                    onPressed: _viewPreviousDryingRecords,
                  ),

                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _updateDateController();
  }

  void _saveAndSubmit() {
    // Show success message
    BreedingMessageHelper.showSuccessMessage(
      context,
      recordType: 'Drying',
      animalType: widget.animalType,
      animalNumber: widget.animalNumber,
      date: _selectedDate,
      additionalInfo: '$_selectedDryingType drying',
    );

    // TODO: Save to repository/API
    // await _breedingRepository.recordDrying(
    //   animalType: widget.animalType,
    //   animalNumber: widget.animalNumber,
    //   dryingType: _selectedDryingType,
    //   dryingDate: _selectedDate,
    // );

    // Navigate back after a delay
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
  }

  Future<void> _selectDate() async {
    final picked = await BreedingDatePickerHelper.showBreedingDatePicker(
      context: context,
      initialDate: _selectedDate,
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _updateDateController();
      });
    }
  }

  void _updateDateController() {
    _dateController.text = BreedingDatePickerHelper.formatDate(_selectedDate);
  }

  void _viewPreviousDryingRecords() {
    // TODO: Navigate to previous drying records page
    BreedingMessageHelper.showInfoMessage(
      context,
      message: 'Viewing previous drying records for ${widget.animalType} #${widget.animalNumber}',
    );
  }
}
