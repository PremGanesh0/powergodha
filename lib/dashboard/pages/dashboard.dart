import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:powergodha/animal/models/animal_count_response.dart';
import 'package:powergodha/animal/repositories/animal_repository.dart';
import 'package:powergodha/app/app_logger_config.dart';
import 'package:powergodha/dashboard/add_animals.dart';
import 'package:powergodha/dashboard/mixins/dashboard_dialog_mixin.dart';
import 'package:powergodha/dashboard/models/dashboard_models.dart';
import 'package:powergodha/dashboard/pages/animal_detail_page.dart';
import 'package:powergodha/dashboard/update_animal.dart';
import 'package:powergodha/dashboard/widgets/dashboard_widgets.dart';
import 'package:powergodha/animal/animal_type_utils.dart';
import 'package:powergodha/shared/enums.dart';

/// Dashboard page for dairy farm management with animal cards
class DashboardPage extends StatefulWidget with DashboardDialogMixin {
  /// Creates a dashboard page
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();

  /// Creates a route for the DashboardPage
  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const DashboardPage());
  }
}

class _DashboardPageState extends State<DashboardPage> {
  // Animal repository from context
  late final AnimalRepository _animalRepository;

  // Loading state
  bool _isLoading = true;
  String? _errorMessage;

  // Animal counts data
  AnimalCountResponse? _animalCountResponse;

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Animal Information'),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _loadAnimalCounts,
              tooltip: 'Refresh Animal Counts',
            ),
          ],
        ),
        backgroundColor: Colors.grey[50],
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Animal Information'),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _loadAnimalCounts,
              tooltip: 'Refresh Animal Counts',
            ),
          ],
        ),
        backgroundColor: Colors.grey[50],
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Failed to load animal data', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text(
                _errorMessage ?? 'Unknown error occurred',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(onPressed: _loadAnimalCounts, child: const Text('Retry')),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Animal Information'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadAnimalCounts,
            tooltip: 'Refresh Animal Counts',
          ),
        ],
      ),
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          const DashboardHeader(title: 'Farm Animal Details'),
          DashboardGrid(children: _buildDashboardItems(context)),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // Use addPostFrameCallback to access context after widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeRepositories();
      _loadAnimalCounts();
    });
  }

  /// Builds the list of dashboard items
  List<Widget> _buildDashboardItems(BuildContext context) {
    final animalCards = _getAnimalCards(context);
    final actionCards = _getActionCards(context);

    return [
      ...animalCards.map(
        (data) => AnimalCard(
          title: data.title,
          icon: data.icon,
          color: data.color,
          count: data.count,
          onTap: data.onTap,
        ),
      ),
      ...actionCards.map(
        (data) => ActionCard(title: data.title, icon: data.icon, onTap: data.onTap),
      ),
    ];
  }

  /// Gets the action card data
  List<ActionCardData> _getActionCards(BuildContext context) {
    return [
      ActionCardData(
        title: 'Add Animal',
        icon: Icons.add_circle,
        // onTap: () => widget.showAddAnimalDialog(context),
        onTap: () {
          Navigator.of(context).push(AddAnimal.route());
        },
      ),
      ActionCardData(
        title: 'Update Animal',
        icon: Icons.edit,
        // onTap: () => widget.showUpdateAnimalDialog(context),
         onTap: () {
          Navigator.of(context).push(UpdateAnimal.route());
        },
      ),
    ];
  }

  /// Gets the animal card data from API response
  List<AnimalCardData> _getAnimalCards(BuildContext context) {
    if (_animalCountResponse == null) {
      return [];
    }

    // Create a map to store animal counts by type
    final animalCounts = <String, int>{};

    for (final animal in _animalCountResponse!.data) {
      animalCounts[animal.animalType] = animal.count;
    }

    return [
      AnimalCardData(
        title: AnimalType.cow.displayName,
        icon: AnimalType.cow.iconPath,
        color: DashboardConstants.cowColor,
        count: (animalCounts['Cow'] ?? 0).toString(),
        onTap: () => _navigateToAnimalDetail(
          context,
          animalId: AnimalType.cow.apiId,
          animalName: AnimalType.cow.displayName,
          animalColor: DashboardConstants.cowColor,
        ),
      ),
      AnimalCardData(
        title: AnimalType.buffalo.displayName,
        icon: AnimalType.buffalo.iconPath,
        color: DashboardConstants.buffaloColor,
        count: (animalCounts['Buffalo'] ?? 0).toString(),
        onTap: () => _navigateToAnimalDetail(
          context,
          animalId: AnimalType.buffalo.apiId,
          animalName: AnimalType.buffalo.displayName,
          animalColor: DashboardConstants.buffaloColor,
        ),
      ),
      AnimalCardData(
        title: AnimalType.goat.displayName,
        icon: AnimalType.goat.iconPath,
        color: DashboardConstants.goatColor,
        count: (animalCounts['Goat'] ?? 0).toString(),
        onTap: () => _navigateToAnimalDetail(
          context,
          animalId: AnimalType.goat.apiId,
          animalName: AnimalType.goat.displayName,
          animalColor: DashboardConstants.goatColor,
        ),
      ),
      AnimalCardData(
        title: AnimalType.hen.displayName,
        icon: AnimalType.hen.iconPath,
        color: DashboardConstants.henColor,
        count: (animalCounts['Hen'] ?? 0).toString(),
        onTap: () => _navigateToAnimalDetail(
          context,
          animalId: AnimalType.hen.apiId,
          animalName: AnimalType.hen.displayName,
          animalColor: DashboardConstants.henColor,
        ),
      ),
    ];
  }

  void _initializeRepositories() {
    // Get the existing AnimalRepository from the widget context
    _animalRepository = context.read<AnimalRepository>();
  }

  Future<void> _loadAnimalCounts() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Get animal counts from repository
      final animalCounts = await _animalRepository.getUserAnimalCount();

      setState(() {
        _animalCountResponse = animalCounts;
      });

      AppLogger.info('Animal counts loaded successfully');
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
      AppLogger.error('Failed to load animal counts: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Navigate to animal detail page
  void _navigateToAnimalDetail(
    BuildContext context, {
    required int animalId,
    required String animalName,
    required Color animalColor,
  }) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) =>
            AnimalDetailPage(animalId: animalId, animalName: animalName, animalColor: animalColor),
      ),
    );
  }
}
