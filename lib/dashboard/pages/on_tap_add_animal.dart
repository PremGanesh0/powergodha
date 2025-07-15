import 'package:flutter/material.dart';

class OnTapAddAnimal extends StatefulWidget{
  const OnTapAddAnimal({super.key});

  static Route<void> route(){
    return MaterialPageRoute<void>(builder: (context) => const OnTapAddAnimal());
  }

  @override
  State<OnTapAddAnimal> createState() => _OnTapAddAnimalState();
}

class _OnTapAddAnimalState extends State<OnTapAddAnimal> {
  String? selectedAnimal;
  String? selectedSex ;
  String? selectedCowOrCalf;
  String? selectedPregnant;
  String? selectedLactating;

  final List<String> animals = ['Cow','Buffalo','Goat','Hen'];
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
      body: Column(
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
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16
                    ),
                ),

                const SizedBox(height:10),

                DropdownButtonFormField<String>(
                    value: selectedAnimal,
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
                    items: animals.map((animal){
                      return DropdownMenuItem(
                        value: animal,
                        child: Text(animal),
                      );
                    }).toList(),
                    onChanged: (val){
                      setState(() {
                        selectedAnimal = val;
                      });
                    }
                ),

                if(selectedAnimal == 'Cow' || selectedAnimal == 'Buffalo')...[
                  const SizedBox(height: 10),
                  const Text(
                    'Basic Details',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16
                    ),
                  ),
                  Text(
                    'Provide birth and population details of animals at your farm by answering questions below',
                    style: TextStyle(
                        color: Colors.grey[500]
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'Animal Number',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const TextField(
                    style: TextStyle(
                      fontSize: 16,
                    ),
                    decoration: InputDecoration(
                        isDense: true,
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            width: 0.5
                          )
                        ),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                width: 0.5
                            )
                        )
                    ),
                  ),

                  const SizedBox(height: 20),

                  RadioRow(
                      question: 'Animal Sex',
                      type1: 'Male',
                      type2: 'Female',
                      groupValue: selectedSex,
                      onChanged: (val){
                        setState(() {
                          selectedSex = val;
                        });
                      }
                  ),

                  const SizedBox(height:20),

                  RadioRow(
                      question: 'Is it a Buffalo or a Calf?',
                      type1: 'Buffalo',
                      type2: 'Calf',
                      groupValue: selectedCowOrCalf,
                      onChanged: (val){
                        setState(() {
                          selectedCowOrCalf = val;
                        });
                      }
                  ),

                  const SizedBox(height:20),

                  RadioRow(
                      question: 'Is animal Pregnant?',
                      type1: 'Yes',
                      type2: 'No',
                      groupValue: selectedPregnant,
                      onChanged: (val){
                        setState(() {
                          selectedPregnant = val;
                        });
                      }
                  ),

                  const SizedBox(height: 20),

                  RadioRow(
                      question: 'Is animal Lactating?',
                      type1: 'Yes',
                      type2: 'No',
                      groupValue: selectedLactating,
                      onChanged: (val){
                        setState(() {
                          selectedLactating = val;
                        });
                      }
                  ),
                ]
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RadioRow extends StatelessWidget{
  const RadioRow({
    required this.question, required this.type1, required this.type2, super.key, required this.groupValue, required this.onChanged
  });
  final String type1;
  final String type2;
  final String question;
  final String? groupValue;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question,
          style: const TextStyle(fontSize: 18),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Radio<String>(
              value: type1,
              groupValue: groupValue,
              visualDensity: VisualDensity.compact,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              onChanged: onChanged
            ),
            Text(
              type1,
              style: const TextStyle(
                  fontSize: 16
              ),
            ),
            Radio<String>(
              value: type2,
              groupValue: groupValue,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              onChanged:onChanged,
            ),
            Text(
              type2,
              style: const TextStyle(
                  fontSize: 16
              ),
            )
          ],
        ),
      ],
    );
  }
}
