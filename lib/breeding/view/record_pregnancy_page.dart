/// Record Pregnancy page for capturing animal pregnancy detection events.
///
/// This page allows users to record pregnancy detection events for their animals
/// including pregnancy status and detection date information.
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:powergodha/breeding/widgets/breeding_shared_widgets.dart';

/// {@template record_pregnancy_page}
/// A page for recording animal pregnancy detection events.
///
/// This page provides functionality for:
/// * Recording pregnancy detection status (Yes/No)
/// * Recording the date of pregnancy detection
/// * Saving and submitting pregnancy data
/// * Viewing previous pregnancy records
/// {@endtemplate}
class RecordPregnancyPage extends StatefulWidget {
  /// {@macro record_pregnancy_page}
  const RecordPregnancyPage({
    required this.animalType,
    required this.animalNumber,
    super.key,
  });

  /// The type of animal (e.g., 'Cow', 'Buffalo', 'Goat')
  final String animalType;

  /// The animal identification number
  final String animalNumber;

  @override
  State<RecordPregnancyPage> createState() => _RecordPregnancyPageState();

  /// Creates a route to the record pregnancy page
  static Route<void> route({
    required String animalType,
    required String animalNumber,
  }) {
    return MaterialPageRoute<void>(
      builder: (_) => RecordPregnancyPage(
        animalType: animalType,
        animalNumber: animalNumber,
      ),
    );
  }
}

class _RecordPregnancyPageState extends State<RecordPregnancyPage> {
  DateTime _selectedDate = DateTime.now();
  final TextEditingController _dateController = TextEditingController();
  String _pregnancyDetected = 'Yes'; // Default selection

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

                  // Pregnancy detected section
                  BreedingRadioGroup(
                    label: 'Pregnancy detected?',
                    value: _pregnancyDetected,
                    onChanged: (value) {
                      setState(() {
                        _pregnancyDetected = value;
                      });
                    },
                    option1Label: 'Yes',
                    option1Value: 'Yes',
                    option2Label: 'No',
                    option2Value: 'No',
                  ),

                  SizedBox(height: 40.h),

                  // Date of pregnancy detection section
                  BreedingDateField(
                    label: 'Date of pregnancy detection',
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

                  // View previous pregnancy records button
                  BreedingActionButton(
                    text: 'View previous pregnancy records',
                    icon: Icons.add,
                    onPressed: _viewPreviousPregnancyRecords,
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
      recordType: 'Pregnancy',
      animalType: widget.animalType,
      animalNumber: widget.animalNumber,
      date: _selectedDate,
      additionalInfo: _pregnancyDetected,
    );

    // TODO: Save to repository/API
    // await _breedingRepository.recordPregnancy(
    //   animalType: widget.animalType,
    //   animalNumber: widget.animalNumber,
    //   pregnancyDetected: _pregnancyDetected == 'Yes',
    //   detectionDate: _selectedDate,
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

  void _viewPreviousPregnancyRecords() {
    // TODO: Navigate to previous pregnancy records page
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Viewing previous pregnancy records for ${widget.animalType} #${widget.animalNumber}'),
        backgroundColor: Colors.blue[400],
      ),
    );
  }
}
