import 'package:flutter/material.dart';
import 'package:powergodha/animal/models/animal_details_response.dart';
import 'package:powergodha/dashboard/pages/next_in_update.dart';



class AnimalCardDetails extends StatelessWidget {
 final  IndividualAnimalData animal;
  final String animalType;
  final Color animalColor;
  const AnimalCardDetails({required this.animal, required this.animalType, required this.animalColor,   super.key});

  @override
  Widget build(BuildContext context) {
      return Card(
    margin: const EdgeInsets.only(bottom: 12),
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: animalColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.pets, color: animalColor, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Animal #${animal.animalNumber ?? "Unknown"}',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${animal.breed ?? "Breed not specified"} • ${animal.gender ?? "Gender not specified"}',
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                  ],
                ),
              ),
             ],
          ),
          const SizedBox(height: 16),
          _buildAnimalDetails(animal),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      NextInUpdate.route(
                        animalNumber: animal.animalNumber.toString(),
                        selectedAnimal: animalType,
                        editable: true,
                      ),
                    );
                  },
                  icon: const Icon(Icons.info_outline),
                  label: const Text('Details'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: animalColor,
                    side: BorderSide(color: animalColor),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _showHealthInfo(animal, context),
                  icon: const Icon(Icons.health_and_safety_outlined),
                  label: const Text('Health'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.green,
                    side: const BorderSide(color: Colors.green),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );

  }
    Widget _buildDetailItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey[600], fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
      ],
    );
  }
  void _showHealthInfo(IndividualAnimalData animal , BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Health Info - Animal #${animal.animalNumber ?? "Unknown"}'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Health Status: ${animal.healthStatus ?? "Not available"}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              'Health tracking functionality will be implemented here.',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Close')),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color statusColor;
    switch (status.toLowerCase()) {
      case 'healthy':
        statusColor = Colors.green;
      case 'pregnant':
        statusColor = Colors.pink;
      case 'lactating':
        statusColor = Colors.blue;
      case 'sick':
        statusColor = Colors.red;
      default:
        statusColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildAnimalDetails(IndividualAnimalData animal) {
    return Row(
      children: [
        Expanded(child: _buildDetailItem('DOB', animal.dateOfBirth ?? 'Unknown')),
        Expanded(
          child: _buildDetailItem(
            'Weight',
            animal.weight != null ? '${animal.weight} kg' : 'Unknown',
          ),
        ),
        if (animal.pregnancyStatus != null)
          Expanded(child: _buildDetailItem('Pregnancy', animal.pregnancyStatus!)),
        if (animal.lactationStatus != null)
          Expanded(child: _buildDetailItem('Lactation', animal.lactationStatus!)),
      ],
    );
  }

}
