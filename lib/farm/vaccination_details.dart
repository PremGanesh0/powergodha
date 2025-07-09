import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:powergodha/app/logger_config.dart';

/// Vaccination Details page for tracking animal vaccinations
class VaccinationDetailsPage extends StatefulWidget {
  /// Creates a vaccination details page
  const VaccinationDetailsPage({super.key});

  @override
  State<VaccinationDetailsPage> createState() => _VaccinationDetailsPageState();

  /// Creates a route for the VaccinationDetailsPage
  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const VaccinationDetailsPage());
  }
}

/// Custom input formatter for currency with comma separators
class _CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Remove any existing commas
    final cleanText = newValue.text.replaceAll(',', '');

    // Add commas for thousands
    final formattedText = _addCommaFormatter(cleanText);

    return newValue.copyWith(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }

  String _addCommaFormatter(String value) {
    if (value.isEmpty) return value;

    // Parse the number and format with commas
    try {
      final number = int.parse(value);
      return number.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match match) => '${match[1]},',
      );
    } catch (e) {
      return value;
    }
  }
}

class _VaccinationDetailsPageState extends State<VaccinationDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  final _expenseController = TextEditingController();

  // Date selection
  DateTime? _selectedDate;

  // Animal selection
  List<String> _selectedAnimals = [];
  final List<String> _availableAnimals = [
    'Cow 001 - Ganga',
    'Cow 002 - Yamuna',
    'Cow 003 - Saraswati',
    'Buffalo 001 - Mahishi',
    'Buffalo 002 - Bhains',
    'Goat 001 - Bakri',
    'Goat 002 - Chhagal',
    'Hen 001 - Murgi',
    'Hen 002 - Kukkar',
    'Bull 001 - Nandi',
  ];

  // Vaccination type selection
  List<String> _selectedVaccinationTypes = [];
  final List<String> _availableVaccinationTypes = [
    'FMD (Foot and Mouth Disease)',
    'HS (Haemorrhagic Septicaemia)',
    'BQ (Black Quarter)',
    'Anthrax',
    'Brucellosis',
    'IBR (Infectious Bovine Rhinotracheitis)',
    'PI3 (Parainfluenza 3)',
    'BRSV (Bovine Respiratory Syncytial Virus)',
    'Rotavirus',
    'Coronavirus',
    'Clostridial Diseases',
    'Leptospirosis',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vaccination Details'),
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date Selection
                _buildDateField(),

                const SizedBox(height: 24),

                // Animal Selection Dropdown
                _buildAnimalDropdown(),

                const SizedBox(height: 24),

                // Vaccination Type Selection Dropdown
                _buildVaccinationTypeDropdown(),

                const SizedBox(height: 24),

                // Expense Field
                _buildExpenseField(),

                const SizedBox(height: 32),

                // Action Buttons
                _buildActionButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _expenseController.dispose();
    super.dispose();
  }

  /// Builds the action buttons section
  Widget _buildActionButtons() {
    return Row(
      children: [
        // Cancel Button
        Expanded(
          child: OutlinedButton(
            onPressed: _cancel,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Cancel'),
          ),
        ),

        const SizedBox(width: 16),

        // OK/Submit Button
        Expanded(
          child: ElevatedButton(
            onPressed: _submit,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Submit'),
          ),
        ),
      ],
    );
  }

  /// Builds the animal selection dropdown with chips
  Widget _buildAnimalDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Animals',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),

        // Dropdown TextField with chips
        InkWell(
          onTap: _showAnimalSelectionDialog,
          child: InputDecorator(
            decoration: InputDecoration(
              hintText: 'Select animals',
              suffixIcon: const Icon(Icons.arrow_drop_down),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            child: _selectedAnimals.isEmpty
                ? const Text(
                    'Select animals',
                    style: TextStyle(color: Colors.grey),
                  )
                : Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: _selectedAnimals.map((animal) {
                      return Chip(
                        label: Text(
                          animal,
                          style: const TextStyle(fontSize: 12),
                        ),
                        deleteIcon: const Icon(Icons.close, size: 16),
                        onDeleted: () {
                          setState(() {
                            _selectedAnimals.remove(animal);
                          });
                        },
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                        labelStyle: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      );
                    }).toList(),
                  ),
          ),
        ),

        // Selected count
        if (_selectedAnimals.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'Selected: ${_selectedAnimals.length} animal(s)',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
      ],
    );
  }

  /// Builds the date selection field
  Widget _buildDateField() {
    return TextFormField(
      readOnly: true,
      decoration: InputDecoration(
        labelText: 'Vaccination Date',
        hintText: 'Select vaccination date',
        prefixIcon: const Icon(Icons.calendar_today_outlined),
        suffixIcon: const Icon(Icons.arrow_drop_down),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      controller: TextEditingController(
        text: _selectedDate != null
            ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
            : '',
      ),
      onTap: _selectDate,
      validator: (value) => _selectedDate == null ? 'Please select vaccination date' : null,
    );
  }

  /// Builds the expense input field
  Widget _buildExpenseField() {
    return TextFormField(
      controller: _expenseController,
      decoration: InputDecoration(
        labelText: 'Expense',
        hintText: 'Expense in Rs',
        prefixIcon: const Icon(Icons.currency_rupee_outlined),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        _CurrencyInputFormatter(),
      ],
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter the expense amount';
        }
        final cleanValue = value.replaceAll(',', '');
        if (double.tryParse(cleanValue) == null) {
          return 'Please enter a valid amount';
        }
        return null;
      },
    );
  }

  /// Builds the vaccination type selection dropdown with chips
  Widget _buildVaccinationTypeDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Type of Vaccination',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),

        // Dropdown TextField with chips
        InkWell(
          onTap: _showVaccinationSelectionDialog,
          child: InputDecorator(
            decoration: InputDecoration(
              hintText: 'Select vaccination types',
              suffixIcon: const Icon(Icons.arrow_drop_down),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            child: _selectedVaccinationTypes.isEmpty
                ? const Text(
                    'Select vaccination types',
                    style: TextStyle(color: Colors.grey),
                  )
                : Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: _selectedVaccinationTypes.map((vaccination) {
                      return Chip(
                        label: Text(
                          vaccination,
                          style: const TextStyle(fontSize: 12),
                        ),
                        deleteIcon: const Icon(Icons.close, size: 16),
                        onDeleted: () {
                          setState(() {
                            _selectedVaccinationTypes.remove(vaccination);
                          });
                        },
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                        labelStyle: TextStyle(
                          color: Theme.of(context).colorScheme.onSecondaryContainer,
                        ),
                      );
                    }).toList(),
                  ),
          ),
        ),

        // Selected count
        if (_selectedVaccinationTypes.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'Selected: ${_selectedVaccinationTypes.length} vaccination(s)',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
      ],
    );
  }

  /// Handles form cancellation
  void _cancel() {
    // Clear form or navigate back
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cancel Vaccination Entry'),
          content: const Text('Are you sure you want to cancel? All entered data will be lost.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Go back to previous screen
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  /// Handles date selection
  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      helpText: 'Select Vaccination Date',
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  /// Shows the animal selection dialog
  Future<void> _showAnimalSelectionDialog() async {
    final tempSelected = List<String>.from(_selectedAnimals);

    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, dialogSetState) {
            return AlertDialog(
              title: const Text('Select Animals'),
              content: SizedBox(
                width: double.maxFinite,
                height: 400,
                child: Column(
                  children: [
                    // Select All / Clear All actions
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              dialogSetState(() {
                                tempSelected.clear();
                                tempSelected.addAll(_availableAnimals);
                              });
                            },
                            icon: const Icon(Icons.select_all),
                            label: const Text('Select All'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              dialogSetState(tempSelected.clear);
                            },
                            icon: const Icon(Icons.clear_all),
                            label: const Text('Clear All'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Animal list
                    Expanded(
                      child: ListView.builder(
                        itemCount: _availableAnimals.length,
                        itemBuilder: (context, index) {
                          final animal = _availableAnimals[index];
                          return CheckboxListTile(
                            title: Text(animal),
                            value: tempSelected.contains(animal),
                            onChanged: (bool? value) {
                              dialogSetState(() {
                                if (value == true) {
                                  tempSelected.add(animal);
                                } else {
                                  tempSelected.remove(animal);
                                }
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectedAnimals = tempSelected;
                    });
                    Navigator.of(context).pop();
                  },
                  child: const Text('Done'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  /// Shows the vaccination type selection dialog
  Future<void> _showVaccinationSelectionDialog() async {
    final tempSelected = List<String>.from(_selectedVaccinationTypes);

    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, dialogSetState) {
            return AlertDialog(
              title: const Text('Select Vaccination Types'),
              content: SizedBox(
                width: double.maxFinite,
                height: 400,
                child: Column(
                  children: [
                    // Select All / Clear All actions
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              dialogSetState(() {
                                tempSelected.clear();
                                tempSelected.addAll(_availableVaccinationTypes);
                              });
                            },
                            icon: const Icon(Icons.select_all),
                            label: const Text('Select All'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              dialogSetState(tempSelected.clear);
                            },
                            icon: const Icon(Icons.clear_all),
                            label: const Text('Clear All'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Vaccination type list
                    Expanded(
                      child: ListView.builder(
                        itemCount: _availableVaccinationTypes.length,
                        itemBuilder: (context, index) {
                          final vaccinationType = _availableVaccinationTypes[index];
                          return CheckboxListTile(
                            title: Text(vaccinationType),
                            value: tempSelected.contains(vaccinationType),
                            onChanged: (bool? value) {
                              dialogSetState(() {
                                if (value == true) {
                                  tempSelected.add(vaccinationType);
                                } else {
                                  tempSelected.remove(vaccinationType);
                                }
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectedVaccinationTypes = tempSelected;
                    });
                    Navigator.of(context).pop();
                  },
                  child: const Text('Done'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  /// Handles form submission
  void _submit() {
    if (_formKey.currentState!.validate()) {
      // Validate selections
      if (_selectedAnimals.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select at least one animal'),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 2),
          ),
        );
        return;
      }

      if (_selectedVaccinationTypes.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select at least one vaccination type'),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 2),
          ),
        );
        return;
      }

      // Create vaccination data
      final cleanExpense = _expenseController.text.replaceAll(',', '');
      final vaccinationData = {
        'date': _selectedDate?.toIso8601String(),
        'animals': _selectedAnimals,
        'vaccinationTypes': _selectedVaccinationTypes,
        'expense': double.parse(cleanExpense),
        'currency': 'INR',
        'createdAt': DateTime.now().toIso8601String(),
      };

      // For debugging - print the data to console
      // In a real app, you would send this data to your backend
      AppLogger.info('Vaccination Data: $vaccinationData');

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vaccination details submitted successfully!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );

      // Navigate back after successful submission
      Navigator.of(context).pop();
    }
  }
}
