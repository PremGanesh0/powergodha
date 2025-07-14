import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:powergodha/animal/models/animal_details_response.dart';
import 'package:powergodha/animal/repositories/animal_repository.dart';
import 'package:powergodha/dashboard/next_in_update.dart';
import 'package:powergodha/animal/animal_type_utils.dart';
import 'package:powergodha/shared/enums.dart';

class UpdateAnimal extends StatefulWidget {
  const UpdateAnimal({this.selectedAnimalOrNull, super.key});
  final String? selectedAnimalOrNull;

  @override
  State<UpdateAnimal> createState() => _UpdateAnimalState();

  static Route<void> route({String? selectedAnimalOrNull}) {
    return MaterialPageRoute(
      builder: (_) => UpdateAnimal(selectedAnimalOrNull: selectedAnimalOrNull),
    );
  }
}

class _UpdateAnimalState extends State<UpdateAnimal> {
  late final AnimalRepository _animalRepository;

  // Data
  List<AnimalType> _availableAnimals = [];
  List<IndividualAnimalData> _animalNumbers = [];
  AnimalType? _selectedAnimal;
  String? _selectedAnimalNumber;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animal Information'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: _buildBody(),
    );
  }

  @override
  void initState() {
    super.initState();
    _animalRepository = RepositoryProvider.of<AnimalRepository>(context);
    _loadAvailableAnimals();

    // If a specific animal was passed, try to convert it and load its numbers
    if (widget.selectedAnimalOrNull != null) {
      final selectedAnimalType = AnimalTypeUtils.getAnimalTypeFromString(
        widget.selectedAnimalOrNull!,
      );
      if (selectedAnimalType != null) {
        _selectedAnimal = selectedAnimalType;
        _loadAnimalNumbers(selectedAnimalType);
      }
    }
  }

  Widget _buildBody() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.green[100],
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: Text(
            widget.selectedAnimalOrNull != null
                ? 'Update Animal - ${widget.selectedAnimalOrNull}'
                : 'Update Animal',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.green[700]),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Animal Type Selection (if not already selected)
              if (widget.selectedAnimalOrNull == null) ...[
                const Text(
                  'Select Animal',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 10),

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
                const SizedBox(height: 20),
              ],

              // Animal Number Selection
              const Text(
                'Animal Number',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 10),
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
                    items: _animalNumbers
                        .where((animal) => animal.animalNumber != null)
                        .map<DropdownMenuItem<String>>((IndividualAnimalData value) {
                          return DropdownMenuItem<String>(
                            value: value.animalNumber,
                            child: Text(value.animalNumber!),
                          );
                        })
                        .toList(),
                  ),
                ),
              ),

              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _canProceed()
                    ? () {
                        final selectedType = widget.selectedAnimalOrNull != null
                            ? widget.selectedAnimalOrNull!
                            : _selectedAnimal!.displayName;
                        Navigator.of(context).push(
                          NextInUpdate.route(
                            animalNumber: _selectedAnimalNumber ?? '',
                            selectedAnimal: selectedType,
                          ),
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 20),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                ),
                child: const Text('Next', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  bool _canProceed() {
    final selectedAnimalType = widget.selectedAnimalOrNull ?? _selectedAnimal;
    return selectedAnimalType != null && _selectedAnimalNumber != null;
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
          _selectedAnimalNumber =
              _animalNumbers.isNotEmpty && _animalNumbers.first.animalNumber != null
              ? _animalNumbers.first.animalNumber!
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
  /// Loads available animal types from the repository
  Future<void> _loadAvailableAnimals() async {
    // If a specific animal is already selected, don't load all available animals
    if (widget.selectedAnimalOrNull != null) {
      return;
    }

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
