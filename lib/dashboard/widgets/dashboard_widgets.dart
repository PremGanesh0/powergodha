import 'package:flutter/material.dart';

/// Reusable action card widget for add/update actions
class ActionCard extends StatelessWidget {
  /// The title of the action
  final String title;

  /// The icon for the action
  final IconData icon;

  /// Callback when the card is tapped
  final VoidCallback onTap;

  /// Creates an action card
  const ActionCard({required this.title, required this.icon, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
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
}

/// Reusable animal card widget for displaying animal counts
class AnimalCard extends StatelessWidget {
  /// The title of the animal type
  final String title;

  /// The icon asset path for the animal
  final String? icon;

  /// The background color of the card
  final Color color;

  /// The count to display
  final String count;

  /// Callback when the card is tapped
  final VoidCallback onTap;

  /// Creates an animal card
  const AnimalCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.count,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
              // Background animal silhouette
              if (icon != null)
                Positioned(
                  bottom: -10,
                  left: -10,
                  child: Opacity(
                    opacity: 0.5,
                    child: Image.asset(
                          icon!, width: 100, height: 100, color: Colors.white),
                  ),
                )
              else
                const SizedBox.shrink(),
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
}

/// Reusable custom app bar widget
class DashboardAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// The title to display in the app bar
  final String title;

  /// Creates a dashboard app bar
  const DashboardAppBar({required this.title, super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
    );
  }
}

/// Custom grid view widget for dashboard items
class DashboardGrid extends StatelessWidget {
  /// The child widgets to display in the grid
  final List<Widget> children;

  /// Creates a dashboard grid
  const DashboardGrid({required this.children, super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.1,
          children: children,
        ),
      ),
    );
  }
}

/// Reusable header section widget for dashboard pages
class DashboardHeader extends StatelessWidget {
  /// The title to display in the header
  final String title;

  /// Creates a dashboard header
  const DashboardHeader({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
        title,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.green[700]),
      ),
    );
  }
}
