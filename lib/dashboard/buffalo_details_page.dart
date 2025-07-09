import 'package:flutter/material.dart';

/// Buffalo details page showing buffalo-specific information
class BuffaloDetailsPage extends StatelessWidget {
  /// Creates a buffalo details page
  const BuffaloDetailsPage({super.key});

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
              'Buffalo',
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
                  _buildBuffaloCard(
                    context,
                    title: 'Buffalos',
                    count: '1',
                    color: const Color(0xFF4CAF50), // Green
                    onTap: () => _showBuffaloList(context),
                  ),
                  _buildBuffaloCard(
                    context,
                    title: 'Buffalo Heifers',
                    count: '0',
                    color: const Color(0xFF2196F3), // Blue
                    onTap: () => _showBuffaloHeiferList(context),
                  ),
                  _buildBuffaloCard(
                    context,
                    title: 'Buffalo Bulls',
                    count: '0',
                    color: const Color(0xFF9C27B0), // Purple
                    onTap: () => _showBuffaloBullList(context),
                  ),
                  _buildActionCard(
                    context,
                    title: 'Add Buffalo',
                    icon: Icons.add,
                    onTap: () => _showAddBuffalo(context),
                  ),
                  _buildActionCard(
                    context,
                    title: 'Update Buffalo',
                    icon: Icons.refresh,
                    onTap: () => _showUpdateBuffalo(context),
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
        onTap: onTap,
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

  /// Builds a buffalo-specific card widget
  Widget _buildBuffaloCard(
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
              // Background buffalo silhouette
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

  /// Shows add buffalo dialog
  void _showAddBuffalo(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Buffalo'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Register a new buffalo in your farm.'),
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
                    content: Text('Add Buffalo feature coming soon!'),
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

  /// Shows buffalo bull list
  void _showBuffaloBullList(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Buffalo Bulls List'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('View and manage all buffalo bulls in your farm.'),
              SizedBox(height: 16),
              Text('No buffalo bulls registered yet.'),
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

  /// Shows buffalo heifer list
  void _showBuffaloHeiferList(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Buffalo Heifers List'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('View and manage all buffalo heifers in your farm.'),
              SizedBox(height: 16),
              Text('No buffalo heifers registered yet.'),
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

  /// Shows buffalo list
  void _showBuffaloList(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Buffalos List'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('View and manage all buffalos in your farm.'),
              SizedBox(height: 16),
              Text('You have 1 buffalo registered.'),
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

  /// Shows update buffalo dialog
  void _showUpdateBuffalo(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Update Buffalo'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Update buffalo information.'),
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
                    content: Text('Update Buffalo feature coming soon!'),
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

  /// Creates a route for the BuffaloDetailsPage
  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const BuffaloDetailsPage());
  }
}
