/// Breeding Details page for animal breeding management.
///
/// This page allows users to manage breeding activities for their animals
/// including heat recording, delivery tracking, AI procedures, and more.
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:powergodha/animal/models/animal_details_response.dart';
import 'package:powergodha/animal/repositories/animal_repository.dart';
import 'package:powergodha/breeding/view/record_ai_page.dart';
import 'package:powergodha/breeding/view/record_delivery_page.dart';
import 'package:powergodha/breeding/view/record_drying_page.dart';
import 'package:powergodha/breeding/view/record_heat_page.dart';
import 'package:powergodha/breeding/view/record_pregnancy_page.dart';
import 'package:powergodha/breeding/widgets/breeding_shared_widgets.dart';
import 'package:powergodha/l10n/app_localizations.dart';
import 'package:powergodha/animal/animal_type_utils.dart';
import 'package:powergodha/shared/enums.dart';

/// {@template breeding_details_page}
/// A page for managing animal breeding details and activities.
///
/// This page provides functionality for:
/// * Selecting animals for breeding activities
/// * Recording heat cycles
/// * Tracking deliveries
/// * Managing AI procedures
/// * Recording drying periods
/// * Tracking pregnancies
/// {@endtemplate}
class BreedingDetailsPage extends StatefulWidget {
  /// {@macro breeding_details_page}
  const BreedingDetailsPage({super.key});

  @override
  State<BreedingDetailsPage> createState() => _BreedingDetailsPageState();

  /// Creates a route to the breeding details page
  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const BreedingDetailsPage());
  }
}

class _BreedingDetailsPageState extends State<BreedingDetailsPage> {
  late final AnimalRepository _animalRepository;

  // Data
  List<AnimalType> _availableAnimals = [];
  List<IndividualAnimalData> _animalNumbers = [];
  AnimalType? _selectedAnimal;
  String? _selectedAnimalNumber;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: BreedingAppBar(title: localizations?.appTitle ?? 'PowerGotha'),
      body: Column(
        children: [
          // Header section with green background
          Container(
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
                'Breeding Details',
                style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          Expanded(
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Select animal section
                  Text(
                    'Select animal',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 12.h),

                  // Animal dropdown
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<AnimalType>(
                        value: _selectedAnimal,
                        isExpanded: true,
                        style: TextStyle(fontSize: 16.sp, color: Colors.black87),
                        onChanged: (AnimalType? newValue) {
                          if (newValue != null) {
                            setState(() {
                              _selectedAnimal = newValue;
                            });
                            _loadAnimalNumbers(newValue);
                          }
                        },
                        items: _availableAnimals.map<DropdownMenuItem<AnimalType>>((
                          AnimalType value,
                        ) {
                          return DropdownMenuItem<AnimalType>(
                            value: value,
                            child: Text(value.displayName),
                          );
                        }).toList(),
                      ),
                    ),
                  ),

                  SizedBox(height: 24.h),

                  // Animal Number section
                  Text(
                    'Animal Number',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 12.h),

                  // Animal number dropdown
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedAnimalNumber,
                        isExpanded: true,
                        style: TextStyle(fontSize: 16.sp, color: Colors.black87),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              _selectedAnimalNumber = newValue;
                            });
                          }
                        },
                        items: _animalNumbers.map<DropdownMenuItem<String>>((
                          IndividualAnimalData value,
                        ) {
                          return DropdownMenuItem<String>(
                            value: value.animalNumber.toString(),
                            child: Text(value.animalNumber.toString()),
                          );
                        }).toList(),
                      ),
                    ),
                  ),

                  SizedBox(height: 32.h),

                  // Choose an option section
                  Center(
                    child: Text(
                      'Choose an option to proceed',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ),

                  SizedBox(height: 24.h),

                  // Action buttons
                  Expanded(
                    child: Column(
                      children: [
                        _buildActionButton(
                          'Record Heat',
                          Colors.green[400]!,
                          () => _handleActionTap('Record Heat'),
                        ),
                        SizedBox(height: 16.h),
                        _buildActionButton(
                          'Record Delivery',
                          Colors.green[400]!,
                          () => _handleActionTap('Record Delivery'),
                        ),
                        SizedBox(height: 16.h),
                        _buildActionButton(
                          'Record AI',
                          Colors.green[400]!,
                          () => _handleActionTap('Record AI'),
                        ),
                        SizedBox(height: 16.h),
                        _buildActionButton(
                          'Record Drying',
                          Colors.green[400]!,
                          () => _handleActionTap('Record Drying'),
                        ),
                        SizedBox(height: 16.h),
                        _buildActionButton(
                          'Record Pregnancy',
                          Colors.green[400]!,
                          () => _handleActionTap('Record Pregnancy'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _animalRepository = RepositoryProvider.of<AnimalRepository>(context);
    _loadAvailableAnimals();
  }

  Widget _buildActionButton(String title, Color color, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      height: 50.h,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: color, width: 2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
          backgroundColor: Colors.transparent,
        ),
        child: Text(
          title,
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500, color: color),
        ),
      ),
    );
  }

  void _handleActionTap(String action) {
    // Check if both animal type and number are selected
    if (_selectedAnimal == null || _selectedAnimalNumber == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please select both animal type and number'),
          backgroundColor: Colors.red[400],
        ),
      );
      return;
    }

    // Navigate to specific action page based on the action
    switch (action) {
      case 'Record Heat':
        // Direct navigation to Record Heat page
        Navigator.of(context).push(
          RecordHeatPage.route(
            animalType: _selectedAnimal!.displayName,
            animalNumber: _selectedAnimalNumber!,
          ),
        );
      case 'Record Delivery':
        // Direct navigation to Record Delivery page
        Navigator.of(context).push(
          RecordDeliveryPage.route(
            animalType: _selectedAnimal!.displayName,
            animalNumber: _selectedAnimalNumber!,
          ),
        );
      case 'Record AI':
        // Direct navigation to Record AI page
        Navigator.of(context).push(
          RecordAiPage.route(
            animalType: _selectedAnimal!.displayName,
            animalNumber: _selectedAnimalNumber!,
          ),
        );
      case 'Record Drying':
        // Direct navigation to Record Drying page
        Navigator.of(context).push(
          RecordDryingPage.route(
            animalType: _selectedAnimal!.displayName,
            animalNumber: _selectedAnimalNumber!,
          ),
        );
      case 'Record Pregnancy':
        // Direct navigation to Record Pregnancy page
        Navigator.of(context).push(
          RecordPregnancyPage.route(
            animalType: _selectedAnimal!.displayName,
            animalNumber: _selectedAnimalNumber!,
          ),
        );
      default:
        // Show a snackbar for other actions (not yet implemented)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '$action selected for ${_selectedAnimal!.displayName} #$_selectedAnimalNumber',
            ),
            backgroundColor: Colors.green[400],
          ),
        );
    }
  }

  /// Loads animal numbers for the selected animal type
  Future<void> _loadAnimalNumbers(AnimalType animalType) async {
    try {
      final animalDetailsResponse = await _animalRepository.getAnimalDetailsByType(
        animalId: animalType.apiId,
        animalType: animalType.apiString,
      );

      if (animalDetailsResponse.data?.animalData != null) {
        setState(() {
          _animalNumbers = animalDetailsResponse.data!.animalData!;
          _selectedAnimalNumber = _animalNumbers.isNotEmpty
              ? _animalNumbers.first.animalNumber
              : null;
        });
      } else {
        setState(() {
          _animalNumbers = [];
          _selectedAnimalNumber = null;
        });
      }
    } catch (e) {
      setState(() {
        _animalNumbers = [];
        _selectedAnimalNumber = null;
      });
    }
  }

  /// Loads available animal types from the repository
  Future<void> _loadAvailableAnimals() async {
    try {
      final animalCountResponse = await _animalRepository.getUserAnimalCount();

      if (animalCountResponse.data.isNotEmpty) {
        final availableAnimals = <AnimalType>[];

        for (final animalCount in animalCountResponse.data) {
          // Check which animals the user has and add them to the list
          if (animalCount.cow != null && animalCount.cow! > 0) {
            availableAnimals.add(AnimalType.cow);
          }
          if (animalCount.buffalo != null && animalCount.buffalo! > 0) {
            availableAnimals.add(AnimalType.buffalo);
          }
          if (animalCount.goat != null && animalCount.goat! > 0) {
            availableAnimals.add(AnimalType.goat);
          }
          if (animalCount.hen != null && animalCount.hen! > 0) {
            availableAnimals.add(AnimalType.hen);
          }
        }

        setState(() {
          _availableAnimals = availableAnimals;
          _selectedAnimal = availableAnimals.isNotEmpty ? availableAnimals.first : null;
        });

        // Load animal numbers for the first available animal
        if (_selectedAnimal != null) {
          await _loadAnimalNumbers(_selectedAnimal!);
        }
      } else {
        setState(() {
          _availableAnimals = <AnimalType>[
            AnimalType.buffalo,
            AnimalType.cow,
            AnimalType.goat,
          ]; // Fallback to default animals
          _selectedAnimal = AnimalType.buffalo;
        });
        await _loadAnimalNumbers(AnimalType.buffalo);
      }
    } catch (e) {
      setState(() {
        _availableAnimals = <AnimalType>[
          AnimalType.buffalo,
          AnimalType.cow,
          AnimalType.goat,
        ]; // Fallback to default animals
        _selectedAnimal = AnimalType.buffalo;
      });
      await _loadAnimalNumbers(AnimalType.buffalo);
    }
  }
}
