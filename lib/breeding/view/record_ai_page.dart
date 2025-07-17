/// Record AI page for capturing artificial insemination events.
///
/// This page allows users to record artificial insemination events for their animals
/// and manage AI-related data and veterinary information.
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:powergodha/breeding/widgets/breeding_shared_widgets.dart';

/// {@template record_ai_page}
/// A page for recording animal artificial insemination events.
///
/// This page provides functionality for:
/// * Recording the date of artificial insemination
/// * Capturing bull and semen company information
/// * Recording veterinary doctor details
/// * Managing pregnancy cycle information
/// * Saving and submitting AI data
/// {@endtemplate}
class RecordAiPage extends StatefulWidget {

  /// The type of animal (e.g., 'Cow', 'Buffalo', 'Goat')
  final String animalType;
  /// The animal identification number
  final String animalNumber;

  /// {@macro record_ai_page}
  const RecordAiPage({
    required this.animalType,
    required this.animalNumber,
    super.key,
  });

  @override
  State<RecordAiPage> createState() => _RecordAiPageState();

  /// Creates a route to the record AI page
  static Route<void> route({
    required String animalType,
    required String animalNumber,
  }) {
    return MaterialPageRoute<void>(
      builder: (_) => RecordAiPage(
        animalType: animalType,
        animalNumber: animalNumber,
      ),
    );
  }
}

class _RecordAiPageState extends State<RecordAiPage> {
  DateTime _selectedDate = DateTime.now();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _bullNumberController = TextEditingController();
  final TextEditingController _semenCompanyController = TextEditingController();
  final TextEditingController _bullMotherYieldController = TextEditingController();
  final TextEditingController _expenseController = TextEditingController();
  final TextEditingController _vetNameController = TextEditingController();
  final TextEditingController _vetMobileController = TextEditingController();
  final TextEditingController _pregnancyCycleController = TextEditingController();

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
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Breeding Details section
                  const BreedingSectionHeader(),
                  SizedBox(height: 32.h),

                  // Date of Artificial Insemination
                  _buildInputField(
                    label: 'Date of Artificial Insemination',
                    controller: _dateController,
                    hasDatePicker: true,
                    onDateTap: _selectDate,
                  ),

                  // Number of bull used for Artificial Insemination
                  _buildInputField(
                    label: 'Number of bull used for Artificial Insemination',
                    controller: _bullNumberController,
                  ),

                  // Semen company name
                  _buildInputField(
                    label: 'Semen company name',
                    controller: _semenCompanyController,
                  ),

                  // Bull Mother Yield
                  _buildInputField(
                    label: 'Bull Mother Yield',
                    controller: _bullMotherYieldController,
                    hintText: 'In Litres',
                    keyboardType: TextInputType.number,
                  ),

                  // Expense for Artificial Insemination
                  _buildInputField(
                    label: 'Expense for Artificial Insemination',
                    controller: _expenseController,
                    keyboardType: TextInputType.number,
                  ),

                  // Name of the Veterinary Doctor carrying out AI
                  _buildInputField(
                    label: 'Name of the Veterinary Doctor carrying out AI',
                    controller: _vetNameController,
                  ),

                  // Mobile number of the Veterinary Doctor
                  _buildInputField(
                    label: 'Mobile number of the Veterinary Doctor',
                    controller: _vetMobileController,
                    keyboardType: TextInputType.phone,
                  ),

                  // Pregnancy cycle of animal?
                  _buildInputField(
                    label: 'Pregnancy cycle of animal?',
                    controller: _pregnancyCycleController,
                  ),

                  SizedBox(height: 20.h),

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

                  // View previous AI records button
                  SizedBox(
                    width: double.infinity,
                    height: 50.h,
                    child: ElevatedButton.icon(
                      onPressed: _viewPreviousAiRecords,
                      icon: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 20.sp,
                      ),
                      label: Text(
                        'View previous AI records',
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
                    ),
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
    _bullNumberController.dispose();
    _semenCompanyController.dispose();
    _bullMotherYieldController.dispose();
    _expenseController.dispose();
    _vetNameController.dispose();
    _vetMobileController.dispose();
    _pregnancyCycleController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _updateDateController();
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    String? hintText,
    TextInputType keyboardType = TextInputType.text,
    bool hasDatePicker = false,
    VoidCallback? onDateTap,
  }) {
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
        SizedBox(height: 8.h),
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
                  readOnly: hasDatePicker,
                  keyboardType: keyboardType,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.black87,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    hintText: hintText,
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 16.sp,
                    ),
                  ),
                ),
              ),
              if (hasDatePicker)
                GestureDetector(
                  onTap: onDateTap,
                  child: Icon(
                    Icons.calendar_month,
                    color: Colors.green[400],
                    size: 24.sp,
                  ),
                ),
            ],
          ),
        ),
        SizedBox(height: 20.h),
      ],
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
          'AI record saved for ${widget.animalType} #${widget.animalNumber} on ${_formatDate(_selectedDate)}',
        ),
        backgroundColor: Colors.green[400],
        duration: const Duration(seconds: 3),
      ),
    );

    // TODO: Save to repository/API
    // await _breedingRepository.recordAI(
    //   animalType: widget.animalType,
    //   animalNumber: widget.animalNumber,
    //   aiDate: _selectedDate,
    //   bullNumber: _bullNumberController.text,
    //   semenCompany: _semenCompanyController.text,
    //   bullMotherYield: _bullMotherYieldController.text,
    //   expense: _expenseController.text,
    //   vetName: _vetNameController.text,
    //   vetMobile: _vetMobileController.text,
    //   pregnancyCycle: _pregnancyCycleController.text,
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

  void _viewPreviousAiRecords() {
    // TODO: Navigate to previous AI records page
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Viewing previous AI records for ${widget.animalType} #${widget.animalNumber}'),
        backgroundColor: Colors.blue[400],
      ),
    );
  }
}
