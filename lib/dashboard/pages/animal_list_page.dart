import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:powergodha/app/app_logger_config.dart';
import 'package:powergodha/dashboard/widgets/dashboard_widgets.dart';
import 'package:powergodha/animal/models/animal_details_response.dart';
import 'package:powergodha/animal/repositories/animal_repository.dart';

/// Page that shows detailed list of animals of a specific type
class AnimalListPage extends StatefulWidget {
  /// Creates an animal list page
  const AnimalListPage({
    required this.animalId, required this.animalName, required this.animalType, required this.animalColor, super.key,
  });

  /// The ID of the animal type (1=Cow, 2=Buffalo, 3=Goat, 4=Hen)
  final int animalId;

  /// The name of the animal type
  final String animalName;

  /// The type of the animal (e.g., "cow", "buffalo", "goat", "hen")
  final String animalType;

  /// The color theme for the animal
  final Color animalColor;

  @override
  State<AnimalListPage> createState() => _AnimalListPageState();

  /// Creates a route for the AnimalListPage
  static Route<void> route({
    required int animalId,
    required String animalName,
    required String animalType,
    required Color animalColor,
  }) {
    return MaterialPageRoute<void>(
      builder: (_) => AnimalListPage(
        animalId: animalId,
        animalName: animalName,
        animalType: animalType,
        animalColor: animalColor,
      ),
    );
  }
}

class _AnimalListPageState extends State<AnimalListPage> {
  late final AnimalRepository _animalRepository;

  // Search controller
  final TextEditingController _searchController = TextEditingController();

  // Loading state
  bool _isLoading = true;
  String? _errorMessage;

  // Animal details data
  AnimalDetailsResponse? _animalDetailsResponse;
  List<IndividualAnimalData> _filteredAnimals = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.animalName} List'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.refresh),
        //     onPressed: _loadAnimalDetails,
        //     tooltip: 'Refresh',
        //   ),
        // ],
      ),
      backgroundColor: Colors.grey[50],
      body: _buildBody(),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeRepositories();
      _loadAnimalDetails();
    });
  }

  Widget _buildAnimalCard(IndividualAnimalData animal) {
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
                    color: widget.animalColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.pets, color: widget.animalColor, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Animal #${animal.animalNumber ?? "Unknown"}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${animal.breed ?? "Breed not specified"} • ${animal.gender ?? "Gender not specified"}',
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                    ],
                  ),
                ),
                _buildStatusChip(animal.status ?? 'Active'),
              ],
            ),
            const SizedBox(height: 16),
            _buildAnimalDetails(animal),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showAnimalDetails(animal),
                    icon: const Icon(Icons.info_outline),
                    label: const Text('Details'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: widget.animalColor,
                      side: BorderSide(color: widget.animalColor),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showHealthInfo(animal),
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

  Widget _buildAnimalDetails(IndividualAnimalData animal) {
    return Row(
      children: [
        Expanded(
          child: _buildDetailItem('DOB', animal.dateOfBirth ?? 'Unknown'),
        ),
        Expanded(
          child: _buildDetailItem(
            'Weight',
            animal.weight != null ? '${animal.weight} kg' : 'Unknown',
          ),
        ),
        if (animal.pregnancyStatus != null)
          Expanded(
            child: _buildDetailItem('Pregnancy', animal.pregnancyStatus!),
          ),
        if (animal.lactationStatus != null)
          Expanded(
            child: _buildDetailItem('Lactation', animal.lactationStatus!),
          ),
      ],
    );
  }

  Widget _buildAnimalList() {
    if (_filteredAnimals.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No animals found',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search criteria',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredAnimals.length,
      itemBuilder: (context, index) {
        final animal = _filteredAnimals[index];
        return _buildAnimalCard(animal);
      },
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return _buildErrorView();
    }

    if (_animalDetailsResponse == null) {
      return _buildEmptyView();
    }

    return Column(
      children: [
        DashboardHeader(title: widget.animalName),
        _buildSearchBar(),
        _buildSummaryCards(),

        Expanded(
          child: (_animalDetailsResponse!.data?.animalData?.isEmpty ?? true)
              ? _buildNoAnimalsView()
              : _buildAnimalList(),
        ),
      ],
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildDialogDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
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
              'No ${widget.animalName.toLowerCase()} found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Add some ${widget.animalName.toLowerCase()} to see them here.',
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
              onPressed: _loadAnimalDetails,
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

  Widget _buildNoAnimalsView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.pets, size: 64, color: widget.animalColor),
            const SizedBox(height: 16),
            Text(
              'No individual ${widget.animalName.toLowerCase()} records',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'The summary shows general statistics, but no detailed animal records are available yet.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                // TODO: Navigate to add animal page
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Add animal functionality will be implemented',
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: Text('Add ${widget.animalName}'),
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.animalColor,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: _filterAnimals,
        decoration: InputDecoration(
          hintText: 'Search animals by number or breed...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
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
        style: TextStyle(
          color: statusColor,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildSummaryCard(
    String title,
    String count,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              count,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: TextStyle(fontSize: 12, color: color.withOpacity(0.8)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCards() {
    if (_animalDetailsResponse?.data == null) return const SizedBox.shrink();

    final data = _animalDetailsResponse!.data!;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildSummaryCard(
              'Pregnant',
              (data.pregnantAnimal ?? 0).toString(),
              Icons.pregnant_woman,
              Colors.pink,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildSummaryCard(
              'Lactating',
              (data.lactating ?? 0).toString(),
              Icons.water_drop,
              Colors.blue,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildSummaryCard(
              'Total',
              (data.animalData?.length ?? 0).toString(),
              Icons.pets,
              widget.animalColor,
            ),
          ),
        ],
      ),
    );
  }

  void _filterAnimals(String query) {
    if (_animalDetailsResponse?.data == null) return;

    setState(() {
      if (query.isEmpty) {
        _filteredAnimals = _animalDetailsResponse!.data!.animalData ?? [];
      } else {
        _filteredAnimals = (_animalDetailsResponse!.data!.animalData ?? [])
            .where(
              (animal) =>
                  (animal.animalNumber?.toString().contains(
                        query.toLowerCase(),
                      ) ??
                      false) ||
                  (animal.breed?.toLowerCase().contains(query.toLowerCase()) ??
                      false) ||
                  (animal.dateOfBirth?.toLowerCase().contains(
                        query.toLowerCase(),
                      ) ??
                      false),
            )
            .toList();
      }
    });
  }

  void _initializeRepositories() {
    _animalRepository = context.read<AnimalRepository>();
  }

  Future<void> _loadAnimalDetails() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final animalDetails = await _animalRepository.getAnimalDetailsByType(
        widget.animalId,
        widget.animalType,
      );

      setState(() {
        _animalDetailsResponse = animalDetails;
        _filteredAnimals = animalDetails.data?.animalData ?? [];
      });

      AppLogger.info(
        'Animal details loaded successfully for ${widget.animalName}',
      );
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
      AppLogger.error('Failed to load animal details: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showAnimalDetails(IndividualAnimalData animal) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Animal #${animal.animalNumber ?? "Unknown"}'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDialogDetailItem(
                'Animal Number',
                animal.animalNumber?.toString() ?? 'Unknown',
              ),
              _buildDialogDetailItem(
                'Date of Birth',
                animal.dateOfBirth ?? 'Unknown',
              ),
              _buildDialogDetailItem(
                'Weight',
                animal.weight != null ? '${animal.weight} kg' : 'Unknown',
              ),
              if (animal.breed != null)
                _buildDialogDetailItem('Breed', animal.breed!),
              if (animal.gender != null)
                _buildDialogDetailItem('Gender', animal.gender!),
              if (animal.status != null)
                _buildDialogDetailItem('Status', animal.status!),
              if (animal.pregnancyStatus != null &&
                  animal.pregnancyStatus!.isNotEmpty)
                _buildDialogDetailItem(
                  'Pregnancy Status',
                  animal.pregnancyStatus!,
                ),
              if (animal.lactationStatus != null &&
                  animal.lactationStatus!.isNotEmpty)
                _buildDialogDetailItem(
                  'Lactation Status',
                  animal.lactationStatus!,
                ),
              if (animal.healthStatus != null &&
                  animal.healthStatus!.isNotEmpty)
                _buildDialogDetailItem('Health Status', animal.healthStatus!),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showHealthInfo(IndividualAnimalData animal) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Health Info - Animal #${animal.animalNumber ?? "Unknown"}',
        ),
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
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
