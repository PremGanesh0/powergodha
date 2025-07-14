import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:powergodha/animal/animal_type_utils.dart';
import 'package:powergodha/animal/repositories/animal_repository.dart';
import 'package:powergodha/shared/enums.dart';

class AddAnimal extends StatefulWidget {
  const AddAnimal({super.key});

  @override
  State<AddAnimal> createState() => _AddAnimalState();

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (context) => const AddAnimal());
  }
}

class _AddAnimalState extends State<AddAnimal> {
  AnimalType _selectedAnimal = AnimalType.cow;
  String? selectedBreed;
  String? selectedSex;
  String? buffaloOrCalf;
  String? selectedPregnant;
  String? selectedLactating;
  String? selectedOwnDairy;
  DateTime _selectedDate = DateTime.now();

  final _animalNumberController = TextEditingController();
  final _purchasePriceController = TextEditingController();
  final _weightController = TextEditingController();
  final _dobController = TextEditingController();

  final List<String> breeds = [
    'Bhadawari',
    'Jaffarbadi',
    'Marathwadi',
    'Mehsana',
    'Murrah',
    'Nagpuri',
    'Nili Ravi',
    'Pandharpuri',
    'Surti',
    'Toda',
    'Other',
  ];

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
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        child: Column(
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
                'Basic Details',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.green[700],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    'Select Animal',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 10),

                  // // Animal dropdown
                  // Container(
                  //   width: double.infinity,
                  //   padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
                  //   decoration: BoxDecoration(
                  //     color: Colors.grey[200],
                  //     borderRadius: BorderRadius.circular(8.r),
                  //   ),
                  //   child: DropdownButtonHideUnderline(
                  //     child: DropdownButton<AnimalType>(
                  //       value: __selectedAnimal,
                  //       isExpanded: true,
                  //       style: TextStyle(fontSize: 16.sp, color: Colors.black87),
                  //       onChanged: (AnimalType? newValue) {
                  //         if (newValue != null) {
                  //           setState(() {
                  //             __selectedAnimal = newValue;
                  //           });
                  //         }
                  //       },
                  //       items: _availableAnimals.map<DropdownMenuItem<AnimalType>>((
                  //         AnimalType value,
                  //       ) {
                  //         return DropdownMenuItem<AnimalType>(
                  //           value: value,
                  //           child: Text(value.displayName),
                  //         );
                  //       }).toList(),
                  //     ),
                  //   ),
                  // ),

                  DropdownButtonFormField<String>(
                    value: _selectedAnimal.toString(),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                    hint: const Text('Select Animal'),
                    items: AnimalType.values.map((animal) {
                      return DropdownMenuItem<String>(
                        value: animal.toString(),
                        child: Text(animal.displayName),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        _selectedAnimal = AnimalType.values.firstWhere(
                          (element) => element.toString() == val,
                          orElse: () => AnimalType.cow,
                        );
                      });

                      // 👇 Show "Coming Soon" popup for Goat or Hen
                      if (val == 'Goat' || val == 'Hen') {
                        Future.delayed(Duration.zero, () {
                          final snackBar = SnackBar(
                            content: const Text(
                              'Coming Soon',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 12),
                            ),
                            duration: const Duration(milliseconds: 800),
                            // Short duration
                            behavior: SnackBarBehavior.floating,
                            margin: const EdgeInsets.only(bottom: 20, left: 100, right: 100),
                            // Bottom center
                            backgroundColor: Colors.black87,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          );

                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        });
                      }
                    },
                  ),

                  // 👇 Conditionally render form for Cow or Buffalo
                  if (_selectedAnimal == AnimalType.cow ||
                      _selectedAnimal == AnimalType.buffalo) ...[
                    const SizedBox(height: 10),
                    const Text(
                      'Basic Details',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      'Provide birth and population details of animals at your farm by answering questions below',
                      style: TextStyle(color: Colors.grey[500]),
                    ),
                    const SizedBox(height: 20),
                    _TextFieldOption(
                      controller: _animalNumberController,
                      question: 'Animal Number',
                    ),
                    const SizedBox(height: 20),
                    _RadioOptions(
                      question: 'Animal Sex',
                      type1: 'Male',
                      type2: 'Female',
                      groupValue: selectedSex ?? '',
                      onChanged: (val) {
                        setState(() {
                          selectedSex = val;
                        });
                      },
                    ),
                    const SizedBox(height: 20),

                    if (_selectedAnimal == AnimalType.buffalo)
                      _RadioOptions(
                        question: 'Is it a Buffalo or calf?',
                        type1: 'Buffalo',
                        type2: 'Calf',
                        groupValue: buffaloOrCalf ?? '',
                        onChanged: (val) {
                          setState(() {
                            buffaloOrCalf = val;
                          });
                        },
                      ),
                    if (_selectedAnimal == AnimalType.cow)
                      _RadioOptions(
                        question: 'Is it a Cow or calf?',
                        type1: 'Cow',
                        type2: 'Calf',
                        groupValue: buffaloOrCalf ?? '',
                        onChanged: (val) {
                          setState(() {
                            buffaloOrCalf = val;
                          });
                        },
                      ),
                    const SizedBox(height: 20),
                    _RadioOptions(
                      question: 'Is animal Pregnant?',
                      type1: 'Yes',
                      type2: 'No',
                      groupValue: selectedPregnant ?? '',
                      onChanged: (val) {
                        setState(() {
                          selectedPregnant = val;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    _RadioOptions(
                      question: 'Is animal Lactating',
                      type1: 'Yes',
                      type2: 'No',
                      groupValue: selectedLactating ?? '',
                      onChanged: (val) {
                        setState(() {
                          selectedLactating = val;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    _TextFieldOption(
                      question: 'Date of birth of the Animal',
                      controller: _dobController,
                      icon: const Icon(Icons.calendar_month, size: 24),
                      onIconTap: _selectDate,
                    ),
                    const SizedBox(height: 20),
                    _RadioOptions(
                      question: 'Whether borne in own dairy farm',
                      type1: 'Yes',
                      type2: 'No',
                      groupValue: selectedOwnDairy ?? '',
                      onChanged: (val) {
                        setState(() {
                          selectedOwnDairy = val;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    _TextFieldOption(
                      question: 'Purchase price of the Animal',
                      controller: _purchasePriceController,
                      // input should be numeric
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _TextFieldOption(
                      controller: _weightController,
                      question: 'Weight of the Animal',
                    ),
                    const SizedBox(height: 20),
                    const Text('Buffalo Breed', style: TextStyle(fontSize: 16)),
                    DropdownButtonFormField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[200],
                        hintText: 'Select Breed',
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                      ),
                      items: breeds.map((breed) {
                        return DropdownMenuItem(value: breed, child: Text(breed));
                      }).toList(),
                      onChanged: (val) {
                        selectedBreed = val;
                      },
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _submitAnimalData,
                        style: ElevatedButton.styleFrom(foregroundColor: Colors.white),
                        child: const Text('Submit'),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animalNumberController.dispose();
    _purchasePriceController.dispose();
    _weightController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      helpText: 'Select Record Date',
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dobController.text = '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}';
      });
    }
  }

  Future<void> _submitAnimalData() async {
    if (selectedBreed == null ||
        selectedSex == null ||
        buffaloOrCalf == null ||
        selectedPregnant == null ||
        selectedLactating == null ||
        selectedOwnDairy == null ||
        _animalNumberController.text.isEmpty ||
        _purchasePriceController.text.isEmpty ||
        _weightController.text.isEmpty ||
        _dobController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
      return;
    }

    // // Here you would typically send the data to your backend
    // // For now, just print it to the console
    // print('Animal Data Submitted:');
    // print('Animal: $_selectedAnimal');
    // print('Breed: $selectedBreed');
    // print('Sex: $selectedSex');
    // print('Buffalo/Calf: $buffaloOrCalf');
    // print('Pregnant: $selectedPregnant');
    // print('Lactating: $selectedLactating');
    // print('Own Dairy: $selectedOwnDairy');
    // print('Animal Number: ${_animalNumberController.text}');
    // print('Purchase Price: ${_purchasePriceController.text}');
    // print('Weight: ${_weightController.text}');
    // print('Date of Birth: ${_dobController.text}');

    late final animalRepository = RepositoryProvider.of<AnimalRepository>(context);
    final response = await animalRepository.submitAnimalQuestionAnswers({
      'animal_id': '1',
      'animal_number': _animalNumberController.text,
      'answers': [
        {'answer': _animalNumberController.text, 'question_id': 6},
        {'answer': selectedSex, 'question_id': 7},
        {'answer': _selectedAnimal, 'question_id': 44},
        {'answer': buffaloOrCalf, 'question_id': 8},
        {'answer': selectedLactating, 'question_id': 9},
        {'answer': _dobController.text, 'question_id': 10},
        {'answer': buffaloOrCalf, 'question_id': 11},
        {'answer': _purchasePriceController.text, 'question_id': 12},
        {'answer': _weightController.text, 'question_id': 13},
        {'answer': selectedBreed, 'question_id': 49},
      ],
    });

    if (response.success) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Animal data submitted successfully')));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${response.message}')));
    }
  }
}

class _RadioOptions extends StatelessWidget {
  const _RadioOptions({
    required this.question,
    required this.type1,
    required this.type2,
    required this.groupValue,
    required this.onChanged,
  });

  final String type1;
  final String type2;
  final String question;
  final String groupValue;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(question, style: const TextStyle(fontSize: 16)),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Radio<String>(
              value: type1,
              groupValue: groupValue,
              visualDensity: VisualDensity.compact,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              onChanged: onChanged,
            ),
            Text(type1, style: const TextStyle(fontSize: 16)),
            Radio<String>(
              value: type2,
              groupValue: groupValue,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              onChanged: onChanged,
            ),
            Text(type2, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ],
    );
  }
}

class _TextFieldOption extends StatelessWidget {
  const _TextFieldOption({
    required this.question,
    this.controller,
    this.icon,
    this.onIconTap,
    this.decoration,
  });

  final String question;
  final Icon? icon;
  final VoidCallback? onIconTap;
  final TextEditingController? controller;
  final InputDecoration? decoration;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(question, style: const TextStyle(fontSize: 16)),
        SizedBox(
          height: 35,
          child: TextField(
            controller: controller,
            style: const TextStyle(fontSize: 16),
            decoration:
                decoration ??
                InputDecoration(
                  isDense: true,
                  suffixIcon: icon != null ? IconButton(onPressed: onIconTap, icon: icon!) : null,
                  suffixIconColor: Colors.green,
                  focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(width: 0.5)),
                  enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(width: 0.5)),
                ),
          ),
        ),
      ],
    );
  }
}
