import 'package:flutter/material.dart';





class UpdateHealthInfoPage extends StatefulWidget {
      final int animalId;
  final String animalName;
  final Color animalColor;
  const UpdateHealthInfoPage({required this.animalColor, required this.animalId, required this.animalName,super.key});
    /// Creates a route for the AnimalHealth page
  static Route<void> route({
    required int animalId,
    required String animalName,
    required Color animalColor,
  }) {
    return MaterialPageRoute<void>(
      builder: (_) => UpdateHealthInfoPage(
        animalId: animalId,
        animalName: animalName,
        animalColor: animalColor,
      ),
    );
  }

  @override
  State<UpdateHealthInfoPage> createState() => _UpdateHealthInfoPageState();


}

class _UpdateHealthInfoPageState extends State<UpdateHealthInfoPage> {
  final _formKey = GlobalKey<FormState>();
  String? selectedDisease = 'Mastatits';
  String? selectedMedicine = 'Oxytetracyclin';
  DateTime? treatmentDate;

  final milkLossController = TextEditingController();
  final treatmentDetailsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animal Information'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
        ],
      ),
      drawer: const Drawer(), // Replace with your AppDrawer
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.green[100],
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              child: const Text(
                'Update Health Info Of  Buffalo-buff',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Health Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Disease name'),
              value: selectedDisease,
              items: ['Mastatits', 'Foot and Mouth', 'Lumpy']
                  .map((disease) => DropdownMenuItem(
                        value: disease,
                        child: Text(disease),
                      ))
                  .toList(),
              onChanged: (value) => setState(() {
                selectedDisease = value;
              }),
            ),
            const SizedBox(height: 16),
            InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Treatment Date',
                suffixIcon: Icon(Icons.calendar_today, color: Colors.green),
              ),
              child: InkWell(
                onTap: _selectDate,
                child: Text(
                  treatmentDate != null
                      ? '${treatmentDate!.day}/${treatmentDate!.month}/${treatmentDate!.year}'
                      : 'Select a date',
                  style: TextStyle(
                    color: treatmentDate != null
                        ? Colors.black
                        : Colors.grey.shade600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: milkLossController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Milk Loss in Litre (If any)',
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: treatmentDetailsController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Treatment Details',
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration:
                  const InputDecoration(labelText: 'Details of medicine used'),
              value: selectedMedicine,
              items: ['Oxytetracyclin', 'Penicillin', 'Amoxicillin']
                  .map((med) => DropdownMenuItem(
                        value: med,
                        child: Text(med),
                      ))
                  .toList(),
              onChanged: (value) => setState(() {
                selectedMedicine = value;
              }),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () {
                  // Submit logic
                },
                child: const Text(
                  'Save and Submit',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    milkLossController.dispose();
    treatmentDetailsController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: treatmentDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != treatmentDate) {
      setState(() {
        treatmentDate = picked;
      });
    }
  }
}
