// ignore_for_file: avoid_dynamic_calls

import 'package:flutter/material.dart';

/// Pedigree Report page for viewing animal lineage and genetic information
class PedigreeReportPage extends StatefulWidget {
  /// Creates a pedigree report page
  const PedigreeReportPage({super.key});

  @override
  State<PedigreeReportPage> createState() => _PedigreeReportPageState();

  /// Creates a route for the PedigreeReportPage
  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const PedigreeReportPage());
  }
}

class _PedigreeReportPageState extends State<PedigreeReportPage> {
  String? _selectedAnimal;

  // Sample animal data
  final List<String> _availableAnimals = [
    'Cow 001 - Ganga',
    'Cow 002 - Yamuna',
    'Cow 003 - Saraswati',
    'Buffalo 001 - Mahishi',
    'Buffalo 002 - Bhains',
    'Bull 001 - Nandi',
  ];

  // Sample pedigree data (in real app, this would come from API)
  final Map<String, Map<String, dynamic>> _pedigreeData = {
    'Cow 001 - Ganga': {
      'dam': {
        'tagNo': 'DAM001',
        'milkYield': '15.5 L/day',
      },
      'sire': {
        'tagNo': 'SIRE001',
        'semenCompany': 'HF Genetics Ltd.',
        'sireDamYield': '22.3 L/day',
        'daughterYield': '18.7 L/day',
      },
    },
    'Cow 002 - Yamuna': {
      'dam': {
        'tagNo': 'DAM002',
        'milkYield': '18.2 L/day',
      },
      'sire': {
        'tagNo': 'SIRE002',
        'semenCompany': 'Jersey Genetics Co.',
        'sireDamYield': '20.1 L/day',
        'daughterYield': '16.9 L/day',
      },
    },
    'Cow 003 - Saraswati': {
      'dam': {
        'tagNo': 'DAM003',
        'milkYield': '12.8 L/day',
      },
      'sire': {
        'tagNo': 'SIRE003',
        'semenCompany': 'Crossbred Solutions',
        'sireDamYield': '19.5 L/day',
        'daughterYield': '14.2 L/day',
      },
    },
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pedigree Report'),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Animal Selection Dropdown
            _buildAnimalDropdown(),

            const SizedBox(height: 24),

            // Pedigree Information Cards
            if (_selectedAnimal != null) ...[
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Mother (Dam) Card
                      _buildDamCard(),

                      const SizedBox(height: 16),

                      // Father (Sire) Card
                      _buildSireCard(),

                      const SizedBox(height: 32),

                      // Family Tree Button
                      _buildFamilyTreeButton(),
                    ],
                  ),
                ),
              ),
            ] else ...[
              const Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.pets_outlined,
                        size: 64,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Select an animal to view pedigree information',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Builds the animal selection dropdown
  Widget _buildAnimalDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Animal',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedAnimal,
          hint: const Text('Choose an animal'),
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.pets),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
          items: _availableAnimals.map((String animal) {
            return DropdownMenuItem<String>(
              value: animal,
              child: Text(animal),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _selectedAnimal = newValue;
            });
          },
        ),
      ],
    );
  }

  /// Builds the mother (dam) information card
  Widget _buildDamCard() {
    final damData = _pedigreeData[_selectedAnimal]?['dam'];
    if (damData == null) return const SizedBox.shrink();

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.female,
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Mother (Dam)',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Dam Tag Number
            _buildInfoRow(
              icon: Icons.tag,
              label: 'Tag Number',
              value: (damData['tagNo'] as String?) ?? 'Not Available',
            ),

            const SizedBox(height: 12),

            // Dam Milk Yield
            _buildInfoRow(
              icon: Icons.opacity,
              label: 'Milk Yield',
              value: (damData['milkYield'] as String?) ?? 'Not Available',
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the family tree button
  Widget _buildFamilyTreeButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _showFamilyTree,
        icon: const Icon(Icons.account_tree),
        label: const Text('View Family Tree'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  /// Builds a simple family tree visualization
  Widget _buildFamilyTreeView() {
    final pedigreeInfo = _pedigreeData[_selectedAnimal];
    if (pedigreeInfo == null) {
      return const Center(
        child: Text('No pedigree data available'),
      );
    }

    return Column(
      children: [
        // Grandparents row (placeholder)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildTreeNode('MGM', 'Maternal\nGrandmother'),
            _buildTreeNode('MGF', 'Maternal\nGrandfather'),
            _buildTreeNode('PGM', 'Paternal\nGrandmother'),
            _buildTreeNode('PGF', 'Paternal\nGrandfather'),
          ],
        ),

        const SizedBox(height: 20),

        // Connection lines (visual)
        Container(
          height: 2,
          color: Colors.grey.shade300,
        ),

        const SizedBox(height: 20),

        // Parents row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildTreeNode(
              (pedigreeInfo['dam']['tagNo'] as String?) ?? 'DAM',
              'Mother (Dam)',
              isHighlighted: true,
            ),
            _buildTreeNode(
              (pedigreeInfo['sire']['tagNo'] as String?) ?? 'SIRE',
              'Father (Sire)',
              isHighlighted: true,
            ),
          ],
        ),

        const SizedBox(height: 20),

        // Connection line
        Container(
          height: 2,
          color: Colors.grey.shade300,
        ),

        const SizedBox(height: 20),

        // Current animal
        _buildTreeNode(
          _selectedAnimal!.split(' - ')[0],
          _selectedAnimal!.split(' - ')[1],
          isCurrentAnimal: true,
        ),
      ],
    );
  }

  /// Builds an information row with icon, label, and value
  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: Colors.grey.shade600,
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }

  /// Builds the father (sire) information card
  Widget _buildSireCard() {
    final sireData = _pedigreeData[_selectedAnimal]?['sire'];
    if (sireData == null) return const SizedBox.shrink();

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.male,
                  color: Theme.of(context).colorScheme.secondary,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Father (Sire)',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Sire Tag Number
            _buildInfoRow(
              icon: Icons.tag,
              label: 'Tag Number',
              value: (sireData['tagNo'] as String?) ?? 'Not Available',
            ),

            const SizedBox(height: 12),

            // Semen Company Name
            _buildInfoRow(
              icon: Icons.business,
              label: 'Semen Company',
              value: (sireData['semenCompany'] as String?) ?? 'Not Available',
            ),

            const SizedBox(height: 12),

            // Sire's Dam Yield
            _buildInfoRow(
              icon: Icons.opacity,
              label: "Sire's Dam Yield",
              value: (sireData['sireDamYield'] as String?) ?? 'Not Available',
            ),

            const SizedBox(height: 12),

            // Daughter Yield
            _buildInfoRow(
              icon: Icons.child_care,
              label: 'Daughter Yield',
              value: (sireData['daughterYield'] as String?) ?? 'Not Available',
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a tree node for the family tree
  Widget _buildTreeNode(
    String tagNo,
    String name, {
    bool isHighlighted = false,
    bool isCurrentAnimal = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isCurrentAnimal
            ? Theme.of(context).colorScheme.primary
            : isHighlighted
                ? Theme.of(context).colorScheme.primaryContainer
                : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isCurrentAnimal
              ? Theme.of(context).colorScheme.primary
              : Colors.grey.shade300,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            tagNo,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: isCurrentAnimal
                  ? Theme.of(context).colorScheme.onPrimary
                  : null,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            name,
            style: TextStyle(
              fontSize: 10,
              color: isCurrentAnimal
                  ? Theme.of(context).colorScheme.onPrimary
                  : Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Exports the family tree (placeholder functionality)
  void _exportFamilyTree() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Family tree export feature coming soon!'),
        backgroundColor: Colors.blue,
        duration: Duration(seconds: 2),
      ),
    );
  }

  /// Shows the family tree view
  void _showFamilyTree() {
    if (_selectedAnimal == null) return;

    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.account_tree),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Family Tree - $_selectedAnimal',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            height: 300,
            child: Column(
              children: [
                Text(
                  'Family Tree Visualization',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // Simple family tree layout
                Expanded(
                  child: _buildFamilyTreeView(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
                _exportFamilyTree();
              },
              icon: const Icon(Icons.download),
              label: const Text('Export'),
            ),
          ],
        );
      },
    );
  }
}
