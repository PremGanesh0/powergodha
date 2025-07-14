/// Record Heat page for capturing animal heat events.
///
/// This page allows users to record heat events for their animals
/// and view upcoming heat event predictions.
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:powergodha/breeding/widgets/breeding_shared_widgets.dart';

/// {@template record_heat_page}
/// A page for recording animal heat events and viewing predictions.
///
/// This page provides functionality for:
/// * Recording the date of latest heat event
/// * Viewing upcoming heat event predictions
/// * Saving and submitting heat data
/// {@endtemplate}
class RecordHeatPage extends StatefulWidget {
  /// {@macro record_heat_page}
  const RecordHeatPage({
    required this.animalType,
    required this.animalNumber,
    super.key,
  });

  /// The type of animal (e.g., 'Cow', 'Buffalo', 'Goat')
  final String animalType;

  /// The animal identification number
  final String animalNumber;

  @override
  State<RecordHeatPage> createState() => _RecordHeatPageState();

  /// Creates a route to the record heat page
  static Route<void> route({
    required String animalType,
    required String animalNumber,
  }) {
    return MaterialPageRoute<void>(
      builder: (_) => RecordHeatPage(
        animalType: animalType,
        animalNumber: animalNumber,
      ),
    );
  }
}

class _RecordHeatPageState extends State<RecordHeatPage> {
  DateTime _selectedDate = DateTime.now();
  final TextEditingController _dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final upcomingHeatDate = _calculateUpcomingHeatDate();

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

                  // Date input section
                  BreedingDateField(
                    label: 'Date of latest heat event captured?',
                    controller: _dateController,
                    onTap: _selectDate,
                  ),

                  SizedBox(height: 40.h),

                  // Save and Submit button
                  BreedingActionButton(
                    text: 'Save and Submit',
                    onPressed: _saveAndSubmit,
                  ),

                  SizedBox(height: 32.h),

                  // Upcoming Heat Event card
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Upcoming Heat Event',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.green[400],
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          _formatUpcomingDate(upcomingHeatDate),
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),
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

  DateTime _calculateUpcomingHeatDate() {
    // Typical heat cycle for cattle is 21 days
    return _selectedDate.add(const Duration(days: 21));
  }

  String _formatUpcomingDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${date.day} ${months[date.month - 1]},${date.year}';
  }

  void _saveAndSubmit() {
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Heat event recorded for ${widget.animalType} #${widget.animalNumber} on ${BreedingDatePickerHelper.formatDate(_selectedDate)}',
        ),
        backgroundColor: Colors.green[400],
        duration: const Duration(seconds: 3),
      ),
    );

    // TODO: Save to repository/API
    // await _breedingRepository.recordHeatEvent(
    //   animalType: widget.animalType,
    //   animalNumber: widget.animalNumber,
    //   heatDate: _selectedDate,
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
}
