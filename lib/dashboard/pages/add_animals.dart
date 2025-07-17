import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:powergodha/animal/animal_type_utils.dart';
import 'package:powergodha/animal/repositories/animal_repository.dart';
import 'package:powergodha/dashboard/mixins/dashboard_dialog_mixin.dart';
import 'package:powergodha/dashboard/widgets/radio_buttons.dart';
import 'package:powergodha/dashboard/widgets/text_field.dart';
import 'package:powergodha/shared/enums.dart';

class AddAnimal extends StatefulWidget with DialogMixin {
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
                      if (val == 'AnimalType.goat' || val == 'AnimalType.hen') {
                        widget.showToast(context, 'Coming Soon');
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
                    TextFieldOption(controller: _animalNumberController, question: 'Animal Number'),
                    const SizedBox(height: 20),
                    RadioOptions(
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
                      RadioOptions(
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
                      RadioOptions(
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
                    RadioOptions(
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
                    RadioOptions(
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
                    TextFieldOption(
                      question: 'Date of birth of the Animal',
                      controller: _dobController,
                      icon: const Icon(Icons.calendar_month, size: 24),
                      onIconTap: _selectDate,
                    ),
                    const SizedBox(height: 20),
                    RadioOptions(
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
                    TextFieldOption(
                      question: 'Purchase price of the Animal',
                      controller: _purchasePriceController,
                      // input should be numeric
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 20),
                    TextFieldOption(
                      controller: _weightController,
                      question: 'Weight of the Animal',
                      // input should be numeric
                      keyboardType: TextInputType.number,
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
      widget.showToast(context, 'Please fill all fields');

      return;
    }

    late final animalRepository = RepositoryProvider.of<AnimalRepository>(context);

    //       {
    //   'animal_id': '1',                                     // Cow
    //   'animal_number': 'ankhjd',
    //   'answers': [
    //     { 'answer': 'akkjnd',       'question_id': 6 },     // Animal Number
    //     { 'answer': 'Male',      'question_id': 7 },     // Gender
    //     { 'answer': 'Cow',       'question_id': 44 },    // Cow or Calf
    //     { 'answer': 'Yes',       'question_id': 8 },     // Is Pregnant
    //     { 'answer': 'Yes',       'question_id': 9 },     // Is Lactating
    //     { 'answer': '2025-07-15','question_id': 10 },    // Date of Birth
    //     { 'answer': 'Yes',       'question_id': 11 },    // Born in farm
    //     { 'answer': '2358',      'question_id': 12 },    // Purchase Price
    //     { 'answer': '289',       'question_id': 13 },    // Weight
    //     { 'answer': 'Gir',       'question_id': 49 }     // Breed
    //   ]
    // }
    final response = await animalRepository.submitAnimalQuestionAnswers({
      'animal_id': AnimalTypeUtils.getAnimalId(_selectedAnimal),
      'animal_number': _animalNumberController.text,
      'answers': [
        {'answer': _animalNumberController.text, 'question_id': 6},
        {'answer': selectedSex, 'question_id': 7},
        {'answer': _selectedAnimal.toString(), 'question_id': 44},
        {'answer': buffaloOrCalf, 'question_id': 8},
        {'answer': selectedLactating, 'question_id': 9},
        {'answer': _selectedDate.toIso8601String().split('T').first, 'question_id': 10},
        {'answer': buffaloOrCalf, 'question_id': 11},
        {'answer': _purchasePriceController.text, 'question_id': 12},
        {'answer': _weightController.text, 'question_id': 13},
        {'answer': selectedBreed, 'question_id': 49},
      ],
    });
    if (!mounted) return;
    if (response.success) {
      widget.showToast(context, 'Animal data submitted successfully');
    } else {
      widget.showToast(context, 'Failed to submit animal data: ${response.message}');
    }
  }
}
