import 'package:flutter/material.dart';
import 'package:powergodha/app/app_routes.dart';
import 'package:powergodha/dashboard/mixins/dashboard_dialog_mixin.dart';
import 'package:powergodha/dashboard/models/dashboard_models.dart';
import 'package:powergodha/dashboard/widgets/dashboard_widgets.dart';

/// Dashboard page for dairy farm management with animal cards
class DashboardPage extends StatelessWidget with DashboardDialogMixin {
  /// Creates a dashboard page
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DashboardAppBar(title: 'Animal Information'),
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          const DashboardHeader(title: 'Farm Animal Details'),
          DashboardGrid(children: _buildDashboardItems(context)),
        ],
      ),
    );
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
        onTap: () => showAddAnimalDialog(context),
      ),
      ActionCardData(
        title: 'Update Animal',
        icon: Icons.edit,
        onTap: () => showUpdateAnimalDialog(context),
      ),
    ];
  }

  /// Gets the animal card data
  List<AnimalCardData> _getAnimalCards(BuildContext context) {
    return [
      AnimalCardData(
        title: 'Cows',
        icon: 'assets/icons/cows.png',
        color: DashboardConstants.cowColor,
        count: '2',
        onTap: () => Navigator.of(context).pushNamed(AppRoutes.cowDetails),
      ),
      AnimalCardData(
        title: 'Buffalo',
        icon: 'assets/icons/buffalos.png',
        color: DashboardConstants.buffaloColor,
        count: '1',
        onTap: () => Navigator.of(context).pushNamed(AppRoutes.buffaloDetails),
      ),
      AnimalCardData(
        title: 'Goats',
        icon: 'assets/icons/cows.png',
        color: DashboardConstants.goatColor,
        count: '0',
        onTap: () => showComingSoonToast(context, 'Goats'),
      ),
      AnimalCardData(
        title: 'Hens',
        icon: 'assets/icons/hens.png',
        color: DashboardConstants.henColor,
        count: '0',
        onTap: () => showComingSoonToast(context, 'Hens'),
      ),
    ];
  }

  /// Creates a route for the DashboardPage
  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const DashboardPage());
  }
}
