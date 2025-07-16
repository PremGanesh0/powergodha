import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:powergodha/animal/animal_type_utils.dart';
import 'package:powergodha/animal/models/animal_basic_details_data.dart';
import 'package:powergodha/animal/repositories/animal_repository.dart';
import 'package:powergodha/shared/widgets/build_question.dart';
import 'package:powergodha/shared/widgets/elevated_outlined_button.dart';

class NextInUpdate extends StatefulWidget {
  const NextInUpdate({
    required this.selectedAnimal,
    required this.animalNumber,
    required this.editable,
    super.key,
  });

  final String selectedAnimal;
  final Object animalNumber;
  final bool editable;

  @override
  State<NextInUpdate> createState() => _AddAnimalState();

  static Route<void> route({
    required String selectedAnimal,
    required Object animalNumber,
    required bool editable,
  }) {
    return MaterialPageRoute<void>(
      builder: (_) =>
          NextInUpdate(selectedAnimal: selectedAnimal, animalNumber: animalNumber, editable: true),
    );
  }
}

class _AddAnimalState extends State<NextInUpdate> {
  String? selectedBreed;
  String? selectedSex;
  String? buffaloOrCalf;
  String? selectedPregnant;
  String? selectedLactating;
  String? selectedOwnDairy;
  final DateTime _selectedDate = DateTime.now();

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

  AnimalBasicDetailsData? _animalBasicDetailsResponse;
  bool _isLoading = false;
  String? _error;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AnimalBasicDetailsData?>(
      future: Future.value(_animalBasicDetailsResponse),
      builder: (context, snapshot) {
        if (_isLoading) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (_error != null) {
          return Scaffold(body: Center(child: Text('Error: $_error')));
        }
        if (!snapshot.hasData || snapshot.data == null) {
          return const Scaffold(body: Center(child: Text('No data available')));
        }

        final animalDetails = snapshot.data!;
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
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Text(
                        'Basic Details',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.notification_important_rounded,
                          size: 22,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'Please fill the basic details of the animal. This will help in better management and tracking.',
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: animalDetails.questions.map((question) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: buildQuestionField(
                          context: context,
                          question: question,
                          isEditable: false,
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 20),
                  const Text(
                    'Add or Update Details',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  elevatedButton('Animal Profile', () {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(const SnackBar(content: Text('Should be Added')));
                  }),
                  const SizedBox(height: 20),
                  elevatedButton('Birth Details', () {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(const SnackBar(content: Text('Should be Added')));
                  }),
                  const SizedBox(height: 20),
                  elevatedButton('Breeding Details', () {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(const SnackBar(content: Text('Should be Added')));
                  }),
                  const SizedBox(height: 20),
                  elevatedButton('Milk Details', () {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(const SnackBar(content: Text('Should be Added')));
                  }),
                  const SizedBox(height: 20),
                  elevatedButton('Delete Animal', () {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(const SnackBar(content: Text('Should be Added')));
                  }),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(foregroundColor: Colors.white),
                      child: const Text('Submit'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchAnimalBasicDetails();
  }

  Future<void> _fetchAnimalBasicDetails() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final animalType = AnimalTypeUtils.getAnimalTypeFromString(widget.selectedAnimal);
      final animalId = animalType?.apiId ?? 0;
      final animalTypeId = animalId;
      final animalNumber = widget.animalNumber.toString();
      late final AnimalRepository animalRepository;

      animalRepository = context.read<AnimalRepository>();

      final response = await animalRepository.getUserAnimalBasicDetailsQuestionAnswer(
        animalId: animalId,
        animalTypeId: animalTypeId,
        animalNumber: animalNumber,
      );
      setState(() {
        _animalBasicDetailsResponse = response;
        _isLoading = false;
        _animalNumberController.text =
            _animalBasicDetailsResponse!.questions.firstWhere((q) => q.questionId == 6).answer ??
            '';

        selectedPregnant = _animalBasicDetailsResponse!.questions[8].answer ?? '';
        selectedSex = _animalBasicDetailsResponse!.questions[1].answer ?? '';
        _dobController.text = _animalBasicDetailsResponse!.questions[2].answerDate ?? '';
        buffaloOrCalf = _animalBasicDetailsResponse!.questions[3].answer ?? '';
        _weightController.text = _animalBasicDetailsResponse!.questions[4].answer ?? '';
        selectedBreed = _animalBasicDetailsResponse!.questions[5].answer ?? '';

        selectedLactating = _animalBasicDetailsResponse!.questions[7].answer ?? '';
        selectedOwnDairy = _animalBasicDetailsResponse!.questions[8].answer ?? '';
        selectedBreed = _animalBasicDetailsResponse!.questions[9].answer ?? '';
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }
}
