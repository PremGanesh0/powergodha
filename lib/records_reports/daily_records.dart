import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:powergodha/shared/widgets/appbar.dart';

/// Data model for cattle feed items
class CattleFeedItem {
  late final TextEditingController nameController;

  late final TextEditingController quantityController;
  late final TextEditingController rateController;
  CattleFeedItem() {
    nameController = TextEditingController();
    quantityController = TextEditingController();
    rateController = TextEditingController();
  }

  void dispose() {
    nameController.dispose();
    quantityController.dispose();
    rateController.dispose();
  }
}

/// Daily Records page for comprehensive dairy farm data entry
class DailyRecordsPage extends StatefulWidget {
  /// Creates a daily records page
  const DailyRecordsPage({super.key});

  @override
  State<DailyRecordsPage> createState() => _DailyRecordsPageState();

  /// Creates a route for the DailyRecordsPage
  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const DailyRecordsPage());
  }
}

/// Data model for dry feed items
class DryFeedItem {
  late final TextEditingController quantityController;

  late final TextEditingController rateController;
  String selectedFeedType = 'Jawar Kadba';
  DryFeedItem() {
    quantityController = TextEditingController();
    rateController = TextEditingController();
  }

  void dispose() {
    quantityController.dispose();
    rateController.dispose();
  }
}

/// Data model for green feed items
class GreenFeedItem {
  late final TextEditingController quantityController;

  late final TextEditingController rateController;
  String selectedFeedType = 'Maize';
  GreenFeedItem() {
    quantityController = TextEditingController();
    rateController = TextEditingController();
  }

  void dispose() {
    quantityController.dispose();
    rateController.dispose();
  }
}

/// Data model for supplement items
class SupplementItem {
  late final TextEditingController nameController;

  late final TextEditingController quantityController;
  late final TextEditingController costController;
  SupplementItem() {
    nameController = TextEditingController();
    quantityController = TextEditingController();
    costController = TextEditingController();
  }

  void dispose() {
    nameController.dispose();
    quantityController.dispose();
    costController.dispose();
  }
}

class _DailyRecordsPageState extends State<DailyRecordsPage> {
  final _formKey = GlobalKey<FormState>();

  // Date selection
  DateTime _selectedDate = DateTime.now();

  // Green Feed - dynamic list
  final List<GreenFeedItem> _greenFeedItems = [];

  // Dry Feed - dynamic list
  final List<DryFeedItem> _dryFeedItems = [];

  // Cattle Feed - dynamic list
  final List<CattleFeedItem> _cattleFeedItems = [];

  // Supplements - dynamic list
  final List<SupplementItem> _supplementItems = [];

  // Cost controllers
  final _labourCostController = TextEditingController();
  final _otherCostController = TextEditingController();
  final _animalPurchaseCostController = TextEditingController();

  // Milk sale controllers
  final _morningMilkLitersController = TextEditingController();
  final _morningMilkPriceController = TextEditingController();
  final _eveningMilkLitersController = TextEditingController();
  final _eveningMilkPriceController = TextEditingController();

  // Manure and other income
  final _manureQuantityController = TextEditingController();
  final _manurePriceController = TextEditingController();
  final _animalSellingPriceController = TextEditingController();
  final _otherIncomeController = TextEditingController();

  // Milk quality details
  final _morningFatController = TextEditingController();
  final _morningSnfController = TextEditingController();
  final _eveningFatController = TextEditingController();
  final _eveningSnfController = TextEditingController();

  // Medical expense
  final _vetFeeController = TextEditingController();
  final _treatmentExpenseController = TextEditingController();

  // Bio security
  bool _bioSecuritySprayDone = false;
  final _bioSecurityExpenseController = TextEditingController();
  final _bioSecurityProductController = TextEditingController();

  // Deworming
  bool _dewormingDone = false;
  final _dewormingExpenseController = TextEditingController();
  final _dewormingMoleculeController = TextEditingController();

  // Green feed options
  final List<String> _greenFeedOptions = [
    'Maize',
    'Maize Silage',
    'Jawar',
    'DHN6',
    'Methi Grass',
    'Bajra',
    'Yashwant',
    'Yayawant',
    'Para Grass',
    'Napier',
    'Sugarcane',
    'Sugarcane Leaves',
    'Others',
  ];

  // Dry feed options
  final List<String> _dryFeedOptions = [
    'Jawar Kadba',
    'Maize',
    'Soya',
    'Tur Husk',
    'Gram Husk',
    'Wheat Dry',
    'Rice Straw',
    'Other Husk',
    'Other Straw',
    'Other Hay',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:PowerGodhaAppBar(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date Picker Section
              _buildDatePickerSection(),

              const SizedBox(height: 24),

              // Title
              _buildSectionTitle('Daily Expenses at your Dairy Farm'),

              const SizedBox(height: 16),

              // Green Feed Section
              _buildGreenFeedSection(),

              const SizedBox(height: 24),

              // Dry Feed Section
              _buildDryFeedSection(),

              const SizedBox(height: 24),

              // Cattle Feed Section
              _buildCattleFeedSection(),

              const SizedBox(height: 24),

              // Supplements Section
              _buildSupplementsSection(),

              const SizedBox(height: 24),

              // Other Costs Section
              _buildOtherCostsSection(),

              const SizedBox(height: 24),

              // Daily Output Section
              _buildDailyOutputSection(),

              const SizedBox(height: 24),

              // Milk Quality Details
              _buildMilkQualitySection(),

              const SizedBox(height: 24),

              // Medical Expenses
              _buildMedicalExpensesSection(),

              const SizedBox(height: 24),

              // Bio Security Details
              _buildBioSecuritySection(),

              const SizedBox(height: 24),

              // Deworming Details
              _buildDewormingSection(),

              const SizedBox(height: 24),

              // Breeding Records
              _buildBreedingRecordsSection(),

              const SizedBox(height: 24),

              // Health Records
              _buildHealthRecordsSection(),

              const SizedBox(height: 24),

              // Birth Records
              _buildBirthRecordsSection(),

              const SizedBox(height: 32),

              // Submit Button
              _buildSubmitButton(),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Dispose all controllers
    _labourCostController.dispose();
    _otherCostController.dispose();
    _animalPurchaseCostController.dispose();
    _morningMilkLitersController.dispose();
    _morningMilkPriceController.dispose();
    _eveningMilkLitersController.dispose();
    _eveningMilkPriceController.dispose();
    _manureQuantityController.dispose();
    _manurePriceController.dispose();
    _animalSellingPriceController.dispose();
    _otherIncomeController.dispose();
    _morningFatController.dispose();
    _morningSnfController.dispose();
    _eveningFatController.dispose();
    _eveningSnfController.dispose();
    _vetFeeController.dispose();
    _treatmentExpenseController.dispose();
    _bioSecurityExpenseController.dispose();
    _bioSecurityProductController.dispose();
    _dewormingExpenseController.dispose();
    _dewormingMoleculeController.dispose();

    // Dispose dynamic items controllers
    for (final item in _greenFeedItems) {
      item.dispose();
    }
    for (final item in _dryFeedItems) {
      item.dispose();
    }
    for (final item in _cattleFeedItems) {
      item.dispose();
    }
    for (final item in _supplementItems) {
      item.dispose();
    }

    super.dispose();
  }

  /// Add cattle feed item
  void _addCattleFeedItem() {
    setState(() {
      _cattleFeedItems.add(CattleFeedItem());
    });
  }

  /// Add dry feed item
  void _addDryFeedItem() {
    setState(() {
      _dryFeedItems.add(DryFeedItem());
    });
  }

  /// Add green feed item
  void _addGreenFeedItem() {
    setState(() {
      _greenFeedItems.add(GreenFeedItem());
    });
  }

  /// Add supplement item
  void _addSupplementItem() {
    setState(() {
      _supplementItems.add(SupplementItem());
    });
  }

  /// Builds bio security section
  Widget _buildBioSecuritySection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bio Security Details',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),

            // Radio buttons for bio security spray
            Text(
              'Did you carry out bio security spray today?',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Radio<bool>(
                  value: true,
                  groupValue: _bioSecuritySprayDone,
                  onChanged: (bool? value) {
                    setState(() {
                      _bioSecuritySprayDone = value ?? false;
                    });
                  },
                ),
                const Text('Yes'),
                const SizedBox(width: 24),
                Radio<bool>(
                  value: false,
                  groupValue: _bioSecuritySprayDone,
                  onChanged: (bool? value) {
                    setState(() {
                      _bioSecuritySprayDone = value ?? false;
                    });
                  },
                ),
                const Text('No'),
              ],
            ),

            if (_bioSecuritySprayDone) ...[
              const SizedBox(height: 16),

              TextFormField(
                controller: _bioSecurityExpenseController,
                decoration: const InputDecoration(
                  labelText: 'Bio Security Expense (Rs)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _bioSecurityProductController,
                decoration: const InputDecoration(
                  labelText: 'Name of the Product Used',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Builds birth records section
  Widget _buildBirthRecordsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Birth Records',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),

            Text(
              'If new calf is born, animal died, new purchase or animal sold:',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _navigateToBirthUpdate,
                icon: const Icon(Icons.pets),
                label: const Text('Click here to update the record'),
                style: OutlinedButton.styleFrom(padding: const EdgeInsets.all(16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds breeding records section
  Widget _buildBreedingRecordsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Breeding Records',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),

            Text(
              'Did you carry out artificial insemination today?',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _navigateToBreedingUpdate,
                icon: const Icon(Icons.edit),
                label: const Text('Click here to update the record'),
                style: OutlinedButton.styleFrom(padding: const EdgeInsets.all(16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a single cattle feed item
  Widget _buildCattleFeedItem(CattleFeedItem item, int index) {
    return Card(
      margin: const EdgeInsets.only(top: 8),
      color: Colors.grey[50],
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Cattle Feed Item ${index + 1}',
                    style: Theme.of(
                      context,
                    ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w500),
                  ),
                ),
                IconButton(
                  onPressed: () => _removeCattleFeedItem(index),
                  icon: const Icon(Icons.remove_circle, color: Colors.red),
                  constraints: const BoxConstraints(),
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: item.nameController,
              decoration: const InputDecoration(
                labelText: 'Feed Name',
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: item.quantityController,
                    decoration: const InputDecoration(
                      labelText: 'Quantity (kg)',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    controller: item.rateController,
                    decoration: const InputDecoration(
                      labelText: 'Rate (Rs/kg)',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the cattle feed section with dynamic items
  Widget _buildCattleFeedSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Cattle Feed',
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
                IconButton(
                  onPressed: _addCattleFeedItem,
                  icon: const Icon(Icons.add_circle, color: Colors.green),
                  tooltip: 'Add Cattle Feed Item',
                ),
              ],
            ),

            if (_cattleFeedItems.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(
                  child: Text(
                    'No cattle feed items added. Tap + to add.',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),

            // Dynamic cattle feed items
            ..._cattleFeedItems.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              return _buildCattleFeedItem(item, index);
            }),
          ],
        ),
      ),
    );
  }

  /// Builds daily output section
  Widget _buildDailyOutputSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Daily Output of your Dairy Farm'),
        const SizedBox(height: 16),

        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Milk Sale Morning
                Text(
                  'Milk Sale Morning',
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _morningMilkLitersController,
                        decoration: const InputDecoration(
                          labelText: 'Liters',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _morningMilkPriceController,
                        decoration: const InputDecoration(
                          labelText: 'Price (Rs)',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Milk Sale Evening
                Text(
                  'Milk Sale Evening',
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _eveningMilkLitersController,
                        decoration: const InputDecoration(
                          labelText: 'Liters',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _eveningMilkPriceController,
                        decoration: const InputDecoration(
                          labelText: 'Price (Rs)',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Manure Production
                Text(
                  'Manure Production Daily',
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _manureQuantityController,
                        decoration: const InputDecoration(
                          labelText: 'Quantity (kg)',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _manurePriceController,
                        decoration: const InputDecoration(
                          labelText: 'Cost per kg (Rs)',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Selling Price of Animals
                TextFormField(
                  controller: _animalSellingPriceController,
                  decoration: const InputDecoration(
                    labelText: 'Selling Price of Animals (Rs)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                ),

                const SizedBox(height: 16),

                // Other Income
                TextFormField(
                  controller: _otherIncomeController,
                  decoration: const InputDecoration(
                    labelText: 'Other Income (Rs)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Builds the date picker section
  Widget _buildDatePickerSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.calendar_today, color: Colors.green),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Date',
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('yyyy-MM-dd').format(_selectedDate),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: _selectDate,
              icon: const Icon(Icons.edit_calendar),
              tooltip: 'Change Date',
            ),
          ],
        ),
      ),
    );
  }

  /// Builds deworming section
  Widget _buildDewormingSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Deworming Details',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),

            // Radio buttons for deworming
            Text(
              'Did you carry out deworming today?',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Radio<bool>(
                  value: true,
                  groupValue: _dewormingDone,
                  onChanged: (bool? value) {
                    setState(() {
                      _dewormingDone = value ?? false;
                    });
                  },
                ),
                const Text('Yes'),
                const SizedBox(width: 24),
                Radio<bool>(
                  value: false,
                  groupValue: _dewormingDone,
                  onChanged: (bool? value) {
                    setState(() {
                      _dewormingDone = value ?? false;
                    });
                  },
                ),
                const Text('No'),
              ],
            ),

            if (_dewormingDone) ...[
              const SizedBox(height: 16),

              TextFormField(
                controller: _dewormingExpenseController,
                decoration: const InputDecoration(
                  labelText: 'Deworming Expense (Rs)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _dewormingMoleculeController,
                decoration: const InputDecoration(
                  labelText: 'Name of the Molecule Used',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Builds a single dry feed item
  Widget _buildDryFeedItem(DryFeedItem item, int index) {
    return Card(
      margin: const EdgeInsets.only(top: 8),
      color: Colors.grey[50],
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Dry Feed Item ${index + 1}',
                    style: Theme.of(
                      context,
                    ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w500),
                  ),
                ),
                IconButton(
                  onPressed: () => _removeDryFeedItem(index),
                  icon: const Icon(Icons.remove_circle, color: Colors.red),
                  constraints: const BoxConstraints(),
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: item.selectedFeedType,
              decoration: const InputDecoration(
                labelText: 'Select Dry Feed Type',
                border: OutlineInputBorder(),
                isDense: true,
              ),
              items: _dryFeedOptions.map((String feed) {
                return DropdownMenuItem<String>(value: feed, child: Text(feed));
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    item.selectedFeedType = newValue;
                  });
                }
              },
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: item.quantityController,
                    decoration: const InputDecoration(
                      labelText: 'Quantity (kg)',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    controller: item.rateController,
                    decoration: const InputDecoration(
                      labelText: 'Rate (Rs/kg)',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the dry feed section with dynamic items
  Widget _buildDryFeedSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Dry Feed',
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
                IconButton(
                  onPressed: _addDryFeedItem,
                  icon: const Icon(Icons.add_circle, color: Colors.green),
                  tooltip: 'Add Dry Feed Item',
                ),
              ],
            ),

            if (_dryFeedItems.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(
                  child: Text(
                    'No dry feed items added. Tap + to add.',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),

            // Dynamic dry feed items
            ..._dryFeedItems.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              return _buildDryFeedItem(item, index);
            }),
          ],
        ),
      ),
    );
  }

  /// Builds a single green feed item
  Widget _buildGreenFeedItem(GreenFeedItem item, int index) {
    return Card(
      margin: const EdgeInsets.only(top: 8),
      color: Colors.grey[50],
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Green Feed Item ${index + 1}',
                    style: Theme.of(
                      context,
                    ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w500),
                  ),
                ),
                IconButton(
                  onPressed: () => _removeGreenFeedItem(index),
                  icon: const Icon(Icons.remove_circle, color: Colors.red),
                  constraints: const BoxConstraints(),
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: item.selectedFeedType,
              decoration: const InputDecoration(
                labelText: 'Select Green Feed Type',
                border: OutlineInputBorder(),
                isDense: true,
              ),
              items: _greenFeedOptions.map((String feed) {
                return DropdownMenuItem<String>(value: feed, child: Text(feed));
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    item.selectedFeedType = newValue;
                  });
                }
              },
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: item.quantityController,
                    decoration: const InputDecoration(
                      labelText: 'Quantity (kg)',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    controller: item.rateController,
                    decoration: const InputDecoration(
                      labelText: 'Rate (Rs/kg)',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the green feed section with dynamic items
  Widget _buildGreenFeedSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Green Feed',
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
                IconButton(
                  onPressed: _addGreenFeedItem,
                  icon: const Icon(Icons.add_circle, color: Colors.green),
                  tooltip: 'Add Green Feed Item',
                ),
              ],
            ),

            if (_greenFeedItems.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(
                  child: Text(
                    'No green feed items added. Tap + to add.',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),

            // Dynamic green feed items
            ..._greenFeedItems.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              return _buildGreenFeedItem(item, index);
            }),
          ],
        ),
      ),
    );
  }

  /// Builds health records section
  Widget _buildHealthRecordsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Health Records',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),

            Text(
              "Any instance of animal health issue and doctor's treatment today?",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _navigateToHealthUpdate,
                icon: const Icon(Icons.medical_services),
                label: const Text('Click here to update the records'),
                style: OutlinedButton.styleFrom(padding: const EdgeInsets.all(16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds medical expenses section
  Widget _buildMedicalExpensesSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Medical Expense Details',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _vetFeeController,
              decoration: const InputDecoration(
                labelText: 'Veterinary Doctor Visit Fee (Rs)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _treatmentExpenseController,
              decoration: const InputDecoration(
                labelText: 'Treatment Expense (Rs)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
            ),
          ],
        ),
      ),
    );
  }

  /// Builds milk quality details section
  Widget _buildMilkQualitySection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Milk Quality Details',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),

            // Morning Fat and SNF
            Text(
              'Morning Milk Quality',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _morningFatController,
                    decoration: const InputDecoration(
                      labelText: 'Fat (%)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _morningSnfController,
                    decoration: const InputDecoration(
                      labelText: 'SNF (%)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Evening Fat and SNF
            Text(
              'Evening Milk Quality',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _eveningFatController,
                    decoration: const InputDecoration(
                      labelText: 'Fat (%)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _eveningSnfController,
                    decoration: const InputDecoration(
                      labelText: 'SNF (%)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Builds other costs section
  Widget _buildOtherCostsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Other Costs',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _labourCostController,
              decoration: const InputDecoration(
                labelText: 'Labour Cost (Rs)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _otherCostController,
              decoration: const InputDecoration(
                labelText: 'Other Cost (Rs)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _animalPurchaseCostController,
              decoration: const InputDecoration(
                labelText: 'Cost of Purchasing Animals (Rs)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a section title with green background
  Widget _buildSectionTitle(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(8)),
      child: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  /// Builds the submit button
  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _submitForm,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(16),
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
        ),
        child: Text(
          'Submit Daily Records',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  /// Builds a single supplement item
  Widget _buildSupplementItem(SupplementItem item, int index) {
    return Card(
      margin: const EdgeInsets.only(top: 8),
      color: Colors.grey[50],
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Supplement Item ${index + 1}',
                    style: Theme.of(
                      context,
                    ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w500),
                  ),
                ),
                IconButton(
                  onPressed: () => _removeSupplementItem(index),
                  icon: const Icon(Icons.remove_circle, color: Colors.red),
                  constraints: const BoxConstraints(),
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: item.nameController,
              decoration: const InputDecoration(
                labelText: 'Supplement Name',
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: item.quantityController,
                    decoration: const InputDecoration(
                      labelText: 'Quantity',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    controller: item.costController,
                    decoration: const InputDecoration(
                      labelText: 'Cost (Rs)',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the supplements section with dynamic items
  Widget _buildSupplementsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Supplements',
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
                IconButton(
                  onPressed: _addSupplementItem,
                  icon: const Icon(Icons.add_circle, color: Colors.green),
                  tooltip: 'Add Supplement Item',
                ),
              ],
            ),

            if (_supplementItems.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(
                  child: Text(
                    'No supplement items added. Tap + to add.',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),

            // Dynamic supplement items
            ..._supplementItems.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              return _buildSupplementItem(item, index);
            }),
          ],
        ),
      ),
    );
  }

  /// Navigate to birth update (placeholder)
  void _navigateToBirthUpdate() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Birth records update - Coming soon!'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  /// Navigate to breeding update (placeholder)
  void _navigateToBreedingUpdate() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Breeding records update - Coming soon!'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  /// Navigate to health update (placeholder)
  void _navigateToHealthUpdate() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Health records update - Coming soon!'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  /// Remove cattle feed item
  void _removeCattleFeedItem(int index) {
    setState(() {
      _cattleFeedItems[index].dispose();
      _cattleFeedItems.removeAt(index);
    });
  }

  /// Remove dry feed item
  void _removeDryFeedItem(int index) {
    setState(() {
      _dryFeedItems[index].dispose();
      _dryFeedItems.removeAt(index);
    });
  }

  /// Remove green feed item
  void _removeGreenFeedItem(int index) {
    setState(() {
      _greenFeedItems[index].dispose();
      _greenFeedItems.removeAt(index);
    });
  }

  /// Remove supplement item
  void _removeSupplementItem(int index) {
    setState(() {
      _supplementItems[index].dispose();
      _supplementItems.removeAt(index);
    });
  }

  /// Date picker function
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
      });
    }
  }

  /// Submit form function
  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      // Show loading
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Saving daily records...'),
              ],
            ),
          );
        },
      );

      // Simulate saving
      // Future.delayed(const Duration(seconds: 2), () {
        Navigator.of(context).pop(); // Close loading dialog

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Daily records saved successfully!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );

        // Optionally navigate back or clear form
        Navigator.of(context).pop();
      // });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all required fields'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
