import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:powergodha/app/logger_config.dart';

/// Farm Investment Details page for tracking farm equipment and infrastructure investments
class FarmInvestmentDetailsPage extends StatefulWidget {
  /// Creates a farm investment details page
  const FarmInvestmentDetailsPage({super.key});

  @override
  State<FarmInvestmentDetailsPage> createState() => _FarmInvestmentDetailsPageState();

  /// Creates a route for the FarmInvestmentDetailsPage
  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const FarmInvestmentDetailsPage());
  }
}

/// Custom input formatter for currency with comma separators
class _CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
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

class _FarmInvestmentDetailsPageState extends State<FarmInvestmentDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();

  // Investment type selection
  String? _selectedInvestmentType;
  final List<String> _investmentTypes = [
    'Farm Shed Construction Expense',
    'Cow Purchase',
    'Milking Machine',
    'Chaff Cutter',
    'Silage Machine',
    'Bulk Cooler',
    'Pellet Machine',
    'Sprayer',
    'Tractor',
    'Dung Lifter and Puller',
    'Milk Supply Vehicle',
    'Dairy Farm Software',
    'Semen Straw Container',
    'Other',
  ];

  // Date selection
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Farm Information'), elevation: 0),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Investment Type Section
                _buildSectionHeader(context, 'Farm Investment Details'),
                const SizedBox(height: 16),

                Text(
                  'Select the investment type.',
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),

                // Investment Type Dropdown
                _buildInvestmentTypeDropdown(),

                const SizedBox(height: 24),

                // Amount Field
                _buildAmountField(),

                const SizedBox(height: 24),

                // Date Selection Field
                _buildDateField(),

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
    _amountController.dispose();
    super.dispose();
  }

  /// Builds the action buttons section
  Widget _buildActionButtons() {
    return Column(
      children: [
        // Save and Add More Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _saveAndAddMore,
            icon: const Icon(Icons.add_outlined),
            label: const Text('Save and Add More'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              backgroundColor: Theme.of(context).colorScheme.secondary,
              foregroundColor: Theme.of(context).colorScheme.onSecondary,
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Save and Update Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _saveAndUpdate,
            icon: const Icon(Icons.save_outlined),
            label: const Text('Save and Update'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ),
      ],
    );
  }

  /// Builds the amount input field
  Widget _buildAmountField() {
    return TextFormField(
      controller: _amountController,
          decoration: InputDecoration(
        hintText: 'Amount',
        prefixIcon: const Icon(Icons.currency_rupee_outlined),
        errorStyle: TextStyle(color: Theme.of(context).colorScheme.error),
      ).applyDefaults(Theme.of(context).inputDecorationTheme),

      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
         _CurrencyInputFormatter(),
      ],
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter the amount';
        }
        final cleanValue = value.replaceAll(',', '');
        if (double.tryParse(cleanValue) == null) {
          return 'Please enter a valid amount';
        }
        return null;
      },
    );
  }

  /// Builds the date selection field
  Widget _buildDateField() {
    return TextFormField(
      readOnly: true,
      decoration: InputDecoration(
        labelText: 'Date of Installation/Purchase',
        hintText: 'Select date',
        prefixIcon: const Icon(Icons.calendar_today_outlined),
        suffixIcon: const Icon(Icons.arrow_drop_down),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      controller: TextEditingController(
        text: _selectedDate != null
            ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
            : '',
      ),
      onTap: _selectDate,
      validator: (value) => _selectedDate == null ? 'Please select a date' : null,
    );
  }

  /// Builds the investment type dropdown field
  Widget _buildInvestmentTypeDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedInvestmentType,
      decoration: const InputDecoration(
        hintText: 'Investment Type',
        prefixIcon: Icon(Icons.category_outlined),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        focusedErrorBorder: InputBorder.none,
      ),

      items: _investmentTypes.map((String investmentType) {
        return DropdownMenuItem<String>(
          value: investmentType,
          child: Text(investmentType, style: const TextStyle(fontSize: 14)),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _selectedInvestmentType = newValue;
        });
      },
      validator: (value) => value == null ? 'Please select an investment type' : null,
      isExpanded: true,
      icon: const Icon(Icons.arrow_drop_down),
    );
  }

  /// Builds a section header with background color
  Widget _buildSectionHeader(BuildContext context, String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  /// Clears the form for next entry
  void _clearForm() {
    setState(() {
      _selectedInvestmentType = null;
      _selectedDate = null;
    });
    _amountController.clear();
  }

  /// Handles saving and adding more investments
  void _saveAndAddMore() {
    if (_formKey.currentState!.validate()) {
      // Save the current investment
      _saveInvestmentData();

      // Clear the form for next entry
      _clearForm();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Investment saved! Add another investment.'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  /// Handles saving and updating (final save)
  void _saveAndUpdate() {
    if (_formKey.currentState!.validate()) {
      // Save the current investment
      _saveInvestmentData();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Investment details saved and updated successfully!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );

      // Navigate back or to summary page
      // Navigator.of(context).pop();
    }
  }

  /// Saves investment data (would typically send to backend)
  void _saveInvestmentData() {
    final cleanAmount = _amountController.text.replaceAll(',', '');

    final investmentData = {
      'investmentType': _selectedInvestmentType,
      'amount': double.parse(cleanAmount),
      'currency': 'INR',
      'date': _selectedDate?.toIso8601String(),
      'createdAt': DateTime.now().toIso8601String(),
    };

    // For debugging - print the data to console
    // In a real app, you would send this data to your backend
    AppLogger.info('Investment Data: $investmentData');
  }

  /// Shows date picker and updates selected date
  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      helpText: 'Select Installation/Purchase Date',
      cancelText: 'Cancel',
      confirmText: 'Select',
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }
}
