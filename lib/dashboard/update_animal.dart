import 'package:flutter/material.dart';

import 'next_in_update.dart';

class UpdateAnimal extends StatefulWidget {
  const UpdateAnimal({this.selectedAnimalOrNull, super.key});
  final String? selectedAnimalOrNull;

  static Route<void> route({String? selectedAnimalOrNull }) {
    return MaterialPageRoute(builder: (_) => UpdateAnimal(selectedAnimalOrNull: selectedAnimalOrNull));
  }

  @override
  State<UpdateAnimal> createState() => _UpdateAnimalState();
}

class _UpdateAnimalState extends State<UpdateAnimal> {
  String? selectedAnimal;
  Object? animalNumber;
  final List<String> animals = ['Cow', 'Buffalo', 'Goat', 'Hen'];
  final List<dynamic> demoNumbers = [122, 321, 'Add other animal'];

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
              widget.selectedAnimalOrNull != null
                  ? 'Update Animal - ${widget.selectedAnimalOrNull}'
                  : 'Update Animal',
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

                  if(widget.selectedAnimalOrNull == null) ...[
                    const Text(
                      'Select Animal',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 10),
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
                      items: animals.map((animal) {
                        return DropdownMenuItem(value: animal, child: Text(animal));
                      }).toList(),
                      onChanged: (val) {
                        setState(() {
                          selectedAnimal = val;
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
                              margin: const EdgeInsets.only(
                                bottom: 20,
                                left: 100,
                                right: 100,
                              ),
                              // Bottom center
                              backgroundColor: Colors.black87,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            );

                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          });
                        }
                      },
                    ),

                    const SizedBox(height: 20),
                  ],

                    const Text(
                      'Animal Number',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField(
                      items: demoNumbers.map((number) {
                        return DropdownMenuItem(
                          value: number,
                          child: Text(number.toString()),
                        );
                      }).toList(),
                      onChanged: (val) {
                        animalNumber = val;
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[200],
                        hintText: 'Select Animal Number',
                        hintStyle: const TextStyle(fontSize: 3),
                        border: const UnderlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {
                      final selected = widget.selectedAnimalOrNull ?? selectedAnimal;
                      Navigator.of(context).push(
                        NextInUpdate.route(
                          animalNumber: animalNumber ?? '',
                          selectedAnimal: selected ?? '',
                        ),
                      );
                    },
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
      ),
    );
  }
}
