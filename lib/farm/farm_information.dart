import 'package:flutter/material.dart';
import 'package:powergodha/app/app_logger_config.dart';
import 'package:powergodha/app/app_routes.dart';
import 'package:powergodha/shared/theme.dart';

/// Farm Information page for collecting farm details and investment information
class FarmInformationPage extends StatefulWidget {
  /// Creates a farm information page
  const FarmInformationPage({super.key});

  @override
  State<FarmInformationPage> createState() => _FarmInformationPageState();

  /// Creates a route for the FarmInformationPage
  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const FarmInformationPage());
  }
}

class _FarmInformationPageState extends State<FarmInformationPage> {
  final _formKey = GlobalKey<FormState>();
  final _farmNameController = TextEditingController();

  // Dropdown selection
  String? _selectedFarmType;
  final List<String> _farmTypes = ['Cow Farm', 'Buffalo Farm', 'Goat Farm', 'Hen Farm', 'Other'];

  // Radio button values
  bool? _hasLooseHousing;
  bool? _hasSilage;
  bool? _hasAzzola;
  bool? _hasHydroponics;

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
                // Farm Information Section
                _buildSectionHeader(context, 'Farm Details'),
                const SizedBox(height: 16),

                // Farm Name Field
                _buildTextField(
                  controller: _farmNameController,
                  label: 'Farm Name',
                  prefixIcon: Icons.agriculture_outlined,
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Please enter your farm name' : null,
                ),

                const SizedBox(height: 16),

                // Farm Type Dropdown
                _buildDropdownField(),

                const SizedBox(height: 32),

                // Fixed Investment Section
                _buildSectionHeader(context, 'Fixed Investment Amount'),
                const SizedBox(height: 16),

                // Radio Button Questions
                _buildRadioQuestion(
                  'Do you have Loose Housing?',
                  _hasLooseHousing,
                  (value) => setState(() => _hasLooseHousing = value),
                ),

                const SizedBox(height: 16),
                _buildRadioQuestion(
                  'Do you have Silage?',
                  _hasSilage,
                  (value) => setState(() => _hasSilage = value),
                ),

                const SizedBox(height: 16),
                _buildRadioQuestion(
                  'Do you have Azzola?',
                  _hasAzzola,
                  (value) => setState(() => _hasAzzola = value),
                ),

                const SizedBox(height: 16),
                _buildRadioQuestion(
                  'Do you have Hydroponics?',
                  _hasHydroponics,
                  (value) => setState(() => _hasHydroponics = value),
                ),

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
    _farmNameController.dispose();
    super.dispose();
  }

  /// Builds the action buttons section
  Widget _buildActionButtons() {
    return Column(
      children: [
        // Text Button for updating fixed investment details
        SizedBox(
          width: double.infinity,
          child: TextButton.icon(
            onPressed: _updateFixedInvestmentDetails,
            // icon: const Icon(Icons.edit_outlined),
            label: const Text('Update Fixed Investment Details'),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              // shape: RoundedRectangleBorder(
                // borderRadius: BorderRadius.circular(8),
                // side: BorderSide(color: Theme.of(context).colorScheme.primary),
              // ),
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Elevated Button for save and update
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _saveAndUpdate,
            icon: const Icon(Icons.save_outlined),
            label: const Text('Save and Update'),
              style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
                      backgroundColor: WidgetStateProperty.all(
                        Theme.of(context).colorScheme.primary,
                      ),
                      foregroundColor: WidgetStateProperty.all(Colors.white),
                      minimumSize: const WidgetStatePropertyAll(Size(double.infinity, 56)),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppTypography.radiusMedium),
                        ),
                      ),
                    ),
          ),
        ),
      ],
    );
  }

  /// Builds the farm type dropdown field
  Widget _buildDropdownField() {
    return DropdownButtonFormField<String>(
      value: _selectedFarmType,
      decoration: const InputDecoration(
        labelText: 'Farm Type',
        prefixIcon: Icon(Icons.category_outlined),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        focusedErrorBorder: InputBorder.none,
      ),
      items: _farmTypes.map((String farmType) {
        return DropdownMenuItem<String>(value: farmType, child: Text(farmType));
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _selectedFarmType = newValue;
        });
      },
      validator: (value) => value == null ? 'Please select a farm type' : null,
      dropdownColor: Theme.of(context).colorScheme.surface, // optional: match theme
      icon: const Icon(Icons.arrow_drop_down)); // optional: customize dropdown icon
      // The underline is controlled by the decoration property above
  }

  /// Builds a radio button question with yes/no options
  Widget _buildRadioQuestion(String question, bool? value, ValueChanged<bool?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: RadioListTile<bool>(
                title: const Text('Yes'),
                value: true,
                groupValue: value,
                onChanged: onChanged,
                dense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
            Expanded(
              child: RadioListTile<bool>(
                title: const Text('No'),
                value: false,
                groupValue: value,
                onChanged: onChanged,
                dense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      ],
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

  /// Builds a text field with consistent styling
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData prefixIcon,
    required String? Function(String?) validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(prefixIcon),
        errorStyle: TextStyle(color: Theme.of(context).colorScheme.error),
      ).applyDefaults(Theme.of(context).inputDecorationTheme),
      keyboardType: keyboardType,
      validator: validator,
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }

  /// Handles saving and updating farm information
  void _saveAndUpdate() {
    if (_formKey.currentState!.validate()) {
      // Validate radio button selections
      if (_hasLooseHousing == null ||
          _hasSilage == null ||
          _hasAzzola == null ||
          _hasHydroponics == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please answer all questions'),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 2),
          ),
        );
        return;
      }

      // Create farm information data
      final farmData = {
        'farmName': _farmNameController.text,
        'farmType': _selectedFarmType,
        'hasLooseHousing': _hasLooseHousing,
        'hasSilage': _hasSilage,
        'hasAzzola': _hasAzzola,
        'hasHydroponics': _hasHydroponics,
      };

      // For debugging - print the data to console
      // In a real app, you would send this data to your backend
      AppLogger.info('Farm Information: $farmData');

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Farm information saved successfully'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );

      // TODO: Navigate back or to next page
      // Navigator.of(context).pop();
    }
  }

  /// Handles updating fixed investment details
  void _updateFixedInvestmentDetails() {
    // TODO: Navigate to a detailed investment page or show a dialog

  Navigator.of(context).pushNamed(AppRoutes.farmInvestmentDetails);
    // For now, show a snackbar
    // ScaffoldMessenger.of(context).showSnackBar(
    //   const SnackBar(
    //     content: Text('Fixed investment details update feature coming soon'),
    //     backgroundColor: Colors.lightGreen,
    //     duration: Duration(seconds: 2),
    //   ),
    // );
  }
}
