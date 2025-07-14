/// Record Delivery page for capturing animal delivery events.
///
/// This page allows users to record delivery events for their animals
/// and manage calf attachments and previous delivery records.
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:powergodha/breeding/widgets/breeding_shared_widgets.dart';

/// {@template record_delivery_page}
/// A page for recording animal delivery events and managing calves.
///
/// This page provides functionality for:
/// * Recording the type and date of delivery
/// * Viewing previous delivery records
/// * Attaching calves to the delivery
/// * Viewing attached calves
/// * Saving and submitting delivery data
/// {@endtemplate}
class RecordDeliveryPage extends StatefulWidget {

  /// {@macro record_delivery_page}
  const RecordDeliveryPage({
    required this.animalType,
    required this.animalNumber,
    super.key,
  });
  /// The type of animal (e.g., 'Cow', 'Buffalo', 'Goat')
  final String animalType;

  /// The animal identification number
  final String animalNumber;

  @override
  State<RecordDeliveryPage> createState() => _RecordDeliveryPageState();

  /// Creates a route to the record delivery page
  static Route<void> route({
    required String animalType,
    required String animalNumber,
  }) {
    return MaterialPageRoute<void>(
      builder: (_) => RecordDeliveryPage(
        animalType: animalType,
        animalNumber: animalNumber,
      ),
    );
  }
}

class _RecordDeliveryPageState extends State<RecordDeliveryPage> {
  DateTime _selectedDate = DateTime.now();
  final TextEditingController _dateController = TextEditingController();
  String _selectedDeliveryType = 'Normal';

  final List<String> _deliveryTypes = [
    'Normal',
    'Caesarean',
    'Assisted',
    'Complicated',
    'Stillborn',
  ];

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

                  // Type of delivery section
                  Text(
                    'Type of delivery',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 12.h),

                  // Delivery type dropdown
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedDeliveryType,
                        isExpanded: true,
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.black87,
                        ),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              _selectedDeliveryType = newValue;
                            });
                          }
                        },
                        items: _deliveryTypes.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ),

                  SizedBox(height: 24.h),

                  // Date of delivery section
                  Text(
                    'Date of delivery',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 12.h),

                  // Date input field
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        bottom: BorderSide(color: Colors.green[400]!, width: 2),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _dateController,
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
                          onTap: _selectDate,
                          child: Icon(
                            Icons.calendar_month,
                            color: Colors.green[400],
                            size: 24.sp,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 40.h),

                  // Save and Submit button
                  SizedBox(
                    width: double.infinity,
                    height: 50.h,
                    child: ElevatedButton(
                      onPressed: _saveAndSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[400],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Save and Submit',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 16.h),

                  // View previous delivery records button
                  SizedBox(
                    width: double.infinity,
                    height: 50.h,
                    child: ElevatedButton(
                      onPressed: _viewPreviousDeliveryRecords,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[400],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'View previous delivery records',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 24.h),

                  // Bottom action buttons row
                  Row(
                    children: [
                      // Attach a calf button
                      Expanded(
                        child: SizedBox(
                          height: 50.h,
                          child: OutlinedButton(
                            onPressed: _attachACalf,
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.green[400]!, width: 2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              backgroundColor: Colors.transparent,
                            ),
                            child: Text(
                              'Attach a calf',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.green[400],
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(width: 16.w),

                      // View attached calfs button
                      Expanded(
                        child: SizedBox(
                          height: 50.h,
                          child: OutlinedButton(
                            onPressed: _viewAttachedCalfs,
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.green[400]!, width: 2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              backgroundColor: Colors.transparent,
                            ),
                            child: Text(
                              'View attached calfs',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.green[400],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
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

  void _attachACalf() {
    // TODO: Navigate to attach calf page
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Attaching calf to ${widget.animalType} #${widget.animalNumber}'),
        backgroundColor: Colors.orange[400],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  void _saveAndSubmit() {
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Delivery recorded for ${widget.animalType} #${widget.animalNumber} on ${_formatDate(_selectedDate)}',
        ),
        backgroundColor: Colors.green[400],
        duration: const Duration(seconds: 3),
      ),
    );

    // TODO: Save to repository/API
    // await _breedingRepository.recordDelivery(
    //   animalType: widget.animalType,
    //   animalNumber: widget.animalNumber,
    //   deliveryType: _selectedDeliveryType,
    //   deliveryDate: _selectedDate,
    // );

    // Navigate back after a delay
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
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

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _updateDateController();
      });
    }
  }

  void _updateDateController() {
    _dateController.text = _formatDate(_selectedDate);
  }

  void _viewAttachedCalfs() {
    // TODO: Navigate to view attached calfs page
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Viewing attached calfs for ${widget.animalType} #${widget.animalNumber}'),
        backgroundColor: Colors.purple[400],
      ),
    );
  }

  void _viewPreviousDeliveryRecords() {
    // TODO: Navigate to previous delivery records page
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Viewing previous delivery records for ${widget.animalType} #${widget.animalNumber}'),
        backgroundColor: Colors.blue[400],
      ),
    );
  }
}
