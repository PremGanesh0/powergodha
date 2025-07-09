import 'package:flutter/material.dart';
import 'package:powergodha/dashboard/on_tap_add_animal.dart';

/// Cow details page showing cow-specific information
class CowDetailsPage extends StatelessWidget {
  /// Creates a cow details page
  const CowDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animal Information'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          // Header section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green[100],
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Text(
              'Cow',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.green[700],
              ),
            ),
          ),
          // Content area
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.1,
                children: [
                  _buildCowCard(
                    context,
                    title: 'Cows',
                    count: '0',
                    color: const Color(0xFFE91E63), // Pink
                    onTap: () => _showCowList(context),
                  ),
                  _buildCowCard(
                    context,
                    title: 'Heifers',
                    count: '0',
                    color: const Color(0xFF2196F3), // Blue
                    onTap: () => _showHeiferList(context),
                  ),
                  _buildCowCard(
                    context,
                    title: 'Bulls',
                    count: '2',
                    color: const Color(0xFF4CAF50), // Green
                    onTap: () => _showBullList(context),
                  ),
                  _buildActionCard(
                    context,
                    title: 'Add Animal',
                    icon: Icons.add,
                    onTap: () => _showAddAnimal(context),
                  ),
                  _buildActionCard(
                    context,
                    title: 'Update Animal',
                    icon: Icons.refresh,
                    onTap: () => _showUpdateAnimal(context),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
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
        onTap: (){
          Navigator.of(context).push(OnTapAddAnimal.route());
        },
        borderRadius: BorderRadius.circular(12),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.green[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 48, color: Colors.green[700]),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.green[700],
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
    );
  }

  /// Builds a cow-specific card widget
  Widget _buildCowCard(
    BuildContext context, {
    required String title,
    required String count,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Stack(
            children: [
              // Background cow silhouette
              const Positioned(
                bottom: -10,
                right: -10,
                child: Opacity(
                  opacity: 0.3,
                  child: Icon(
                    Icons.pets,
                    size: 80,
                    color: Colors.white,
                  ),
                ),
              ),
              // Content
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        count,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Shows add animal dialog
  void _showAddAnimal(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Cow'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Register a new cow in your farm.'),
              SizedBox(height: 16),
              Text('Feature coming soon!'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Add Cow feature coming soon!'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  /// Shows bull list
  void _showBullList(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Bulls List'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('View and manage all bulls in your farm.'),
              SizedBox(height: 16),
              Text('You have 2 bulls registered.'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  /// Shows cow list
  void _showCowList(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cows List'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('View and manage all cows in your farm.'),
              SizedBox(height: 16),
              Text('No cows registered yet.'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  /// Shows heifer list
  void _showHeiferList(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Heifers List'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('View and manage all heifers in your farm.'),
              SizedBox(height: 16),
              Text('No heifers registered yet.'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  /// Shows update animal dialog
  void _showUpdateAnimal(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Update Cow'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Update cow information.'),
              SizedBox(height: 16),
              Text('Feature coming soon!'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Update Cow feature coming soon!'),
                    backgroundColor: Colors.blue,
                  ),
                );
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  /// Creates a route for the CowDetailsPage
  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const CowDetailsPage());
  }
}
