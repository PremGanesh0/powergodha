import 'package:flutter/material.dart';

class NextInUpdate extends StatefulWidget {
  const NextInUpdate({
    required this.selectedAnimal,
    required this.animalNumber,
    super.key,
  });

  final String selectedAnimal;
  final Object animalNumber;

  static Route<void> route({
    required String selectedAnimal,
    required Object animalNumber,
  }) {
    return MaterialPageRoute<void>(
      builder: (_) => NextInUpdate(
        selectedAnimal: selectedAnimal,
        animalNumber: animalNumber,
      ),
    );
  }

  @override
  State<NextInUpdate> createState() => _AddAnimalState();
}

class _AddAnimalState extends State<NextInUpdate> {
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
                '${widget.selectedAnimal} - ${widget.animalNumber}',
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
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Text(
                        'Basic Details',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
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

                  if (widget.selectedAnimal == 'Buffalo')
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
                  if (widget.selectedAnimal == 'Cow')
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
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                      ),
                    ),
                    items: breeds.map((breed) {
                      return DropdownMenuItem(value: breed, child: Text(breed));
                    }).toList(),
                    onChanged: (val) {
                      selectedBreed = val;
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Add or Update Details',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  _elevatedButton(
                      'Animal Profile',
                      (){
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Should be Added'))
                        );
                      }
                  ),
                  const SizedBox(height: 20),
                  _elevatedButton(
                      'Birth Details',
                          (){
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Should be Added'))
                        );
                      }
                  ),
                  const SizedBox(height: 20),
                  _elevatedButton(
                      'Breeding Details',
                          (){
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Should be Added'))
                        );
                      }
                  ),
                  const SizedBox(height: 20),
                  _elevatedButton(
                      'Milk Details',
                          (){
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Should be Added'))
                        );
                      }
                  ),
                  const SizedBox(height: 20),
                  _elevatedButton(
                      'Delete Animal',
                          (){
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Should be Added'))
                        );
                      }
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Submit'),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  ElevatedButton _elevatedButton(String text, VoidCallback onTap){
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.green,
        minimumSize: const Size(double.infinity, 20),
        padding: const EdgeInsets.symmetric(vertical: 12),
        side: const BorderSide(
          color: Colors.grey,
          width: 2,
        ),
        shape: const RoundedRectangleBorder(

        ),
      ),
      child: Text(text),
    );
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
        _dobController.text =
            '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}';
      });
    }
  }
}

class _TextFieldOption extends StatelessWidget {
  const _TextFieldOption({
    required this.question,
    this.controller,
    this.icon,
    this.onIconTap,
  });

  final String question;
  final Icon? icon;
  final VoidCallback? onIconTap;
  final TextEditingController? controller;

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
            decoration: InputDecoration(
              isDense: true,
              suffixIcon: icon != null
                  ? IconButton(onPressed: onIconTap, icon: icon!)
                  : null,
              suffixIconColor: Colors.green,
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(width: 0.5),
              ),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(width: 0.5),
              ),
            ),
          ),
        ),
      ],
    );
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
