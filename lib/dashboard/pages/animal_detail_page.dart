import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:powergodha/animal/models/animal_info_response.dart';
import 'package:powergodha/animal/repositories/animal_repository.dart';
import 'package:powergodha/app/app_logger_config.dart';
import 'package:powergodha/dashboard/pages/add_animals.dart';
import 'package:powergodha/dashboard/pages/animal_list_page.dart';
import 'package:powergodha/dashboard/pages/update_animal.dart';
import 'package:powergodha/dashboard/widgets/dashboard_widgets.dart';

List<Color> animalColors = [
  const Color(0xFFE91E63), // Pink
  const Color(0xFF2196F3), // Blue
  const Color(0xFF4CAF50), // Green

  const Color(0xFF4CAF50), // Green
  const Color(0xFF4CAF50), // Green
];

/// Animal detail page that shows detailed information about a specific animal type
class AnimalDetailPage extends StatefulWidget {
  /// Creates an animal detail page
  const AnimalDetailPage({
    required this.animalId,
    required this.animalName,
    required this.animalColor,
    super.key,
  });

  /// The ID of the animal type (1=Cow, 2=Buffalo, 3=Goat, 4=Hen)
  final int animalId;

  /// The name of the animal type
  final String animalName;

  /// The color theme for the animal
  final Color animalColor;

  @override
  State<AnimalDetailPage> createState() => _AnimalDetailPageState();

  /// Creates a route for the AnimalDetailPage
  static Route<void> route({
    required int animalId,
    required String animalName,
    required Color animalColor,
  }) {
    return MaterialPageRoute<void>(
      builder: (_) =>
          AnimalDetailPage(animalId: animalId, animalName: animalName, animalColor: animalColor),
    );
  }
}

class _AnimalDetailPageState extends State<AnimalDetailPage> {
  // Animal repository from context
  late final AnimalRepository _animalRepository;

  // Loading state
  bool _isLoading = true;
  String? _errorMessage;

  // Animal info data
  AnimalInfoResponse? _animalInfoResponse;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.animalName} Details'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),

      backgroundColor: Colors.grey[50],
      body: _buildBody(),
    );
  }

  @override
  void initState() {
    super.initState();
    // Use addPostFrameCallback to access context after widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeRepositories();
      _loadAnimalInfo();
    });
  }

  /// Builds an action card widget
  Widget _buildActionCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: AspectRatio(
          aspectRatio: 1.2, // Match the grid's childAspectRatio
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: widget.animalColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 48, color: widget.animalColor),
                  const SizedBox(height: 12),
                  Text(
                    title,
                    style: TextStyle(
                      color: widget.animalColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimalInfo() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DashboardHeader(title: widget.animalName),
          // Animal info grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.2,
            ),
            itemCount: _animalInfoResponse!.data.length,
            itemBuilder: (context, index) {
              final animalData = _animalInfoResponse!.data[index];
              return AnimalCard(
                color: animalColors[index % animalColors.length],
                title: animalData.category,
                icon: 'assets/icons/cows.png',
                count: animalData.count.toString(),
                onTap: () => _navigateToAnimalList(animalData),
              );
            },
          ),

          const SizedBox(height: 16),

          // Action buttons row
          Row(
            children: [
              Expanded(
                child: _buildActionCard(
                  context,
                  title: 'Add Animal',
                  icon: Icons.add,
                  // onTap: _showAddAnimalDialog,
                  onTap: () {
                    Navigator.of(context).push(AddAnimal.route());
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionCard(
                  context,
                  title: 'Update Animal',
                  icon: Icons.refresh,
                  // onTap: _showUpdateAnimalDialog,
                  onTap: () {
                    Navigator.of(context).push(UpdateAnimal.route(animal: widget.animalName));
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return _buildErrorView();
    }

    if (_animalInfoResponse == null || _animalInfoResponse!.data.isEmpty) {
      return _buildEmptyView();
    }

    return _buildAnimalInfo();
  }

  Widget _buildEmptyView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.pets, size: 64, color: widget.animalColor),
            const SizedBox(height: 16),
            Text(
              'No ${widget.animalName.toLowerCase()} data available',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Add some ${widget.animalName.toLowerCase()} to see detailed information here.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: widget.animalColor),
            const SizedBox(height: 16),
            Text(
              'Failed to load ${widget.animalName.toLowerCase()} data',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage ?? 'Unknown error occurred',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadAnimalInfo,
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.animalColor,
                foregroundColor: Colors.white,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  void _initializeRepositories() {
    // Get the existing AnimalRepository from the widget context
    _animalRepository = context.read<AnimalRepository>();
  }

  Future<void> _loadAnimalInfo() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Get animal info from repository
      final animalInfo = await _animalRepository.getAnimalInfo(widget.animalId);

      setState(() {
        _animalInfoResponse = animalInfo as AnimalInfoResponse?;
      });

      AppLogger.info('Animal info loaded successfully for ${widget.animalName}');
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
      AppLogger.error('Failed to load animal info: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Navigate to animal list page
  void _navigateToAnimalList(AnimalInfoData animalData) {
    // Only navigate if there are animals to show
    if (animalData.count > 0) {
      Navigator.of(context).push(
        AnimalListPage.route(
          animalId: widget.animalId,
          animalName: widget.animalName,
          animalType: widget.animalName.toLowerCase(),
          animalColor: widget.animalColor,
        ),
      );
    } else {
      // Show message if no animals
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No ${animalData.category.toLowerCase()} found'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }
}
