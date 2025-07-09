/// Home page for authenticated users.
///
/// This file contains the [HomePage] widget which serves as the main screen
/// for authenticated users. It provides:
/// * User information display (User ID)
/// * Logout functionality
/// * Clean, centered layout
/// * Integration with authentication system
///
/// **Architecture:**
/// * Uses [AuthenticationBloc] for logout operations and user data access
/// * Contains private widgets for better organization and reusability
/// * Follows the composition pattern with small, focused widgets
///
/// **Widget Structure:**
/// ```
/// HomePage (Scaffold)
/// └── Center
///     └── Column
///         ├── _UserId (displays user ID)
///         └── _LogoutButton (logout functionality)
/// ```
///
/// **Navigation Integration:**
/// * Provides static route method for navigation system
/// * Used by [AppView] when user is authenticated
/// * Replaces login/splash screens in navigation stack
///
/// This page demonstrates how to integrate with the authentication system
/// and provides a foundation for building authenticated user features.
library;

import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:powergodha/app/app_view.dart' show AppView;
import 'package:powergodha/app/app_routes.dart';
import 'package:powergodha/authentication/bloc/authentication_bloc.dart';
import 'package:powergodha/home/widgets/app_drawer.dart';
import 'package:powergodha/home/widgets/featured_carousel.dart';
import 'package:powergodha/l10n/app_localizations.dart';
import 'package:powergodha/shared/theme.dart';

/// {@template home_page}
/// The main home screen for authenticated users.
///
/// This [StatelessWidget] provides the primary interface for users who have
/// successfully logged into the application. It serves as a dashboard or
/// landing page with essential user information and actions.
///
/// **Features:**
/// * Displays user identification information
/// * Provides logout functionality
/// * Clean, centered layout optimized for mobile devices
/// * Real-time integration with authentication state
///
/// **Layout:**
/// * Uses [Scaffold] for consistent app structure
/// * Centers content vertically and horizontally
/// * Minimal design focusing on essential functionality
/// * Responsive design that works on different screen sizes
///
/// **State Management:**
/// * Integrates with [AuthenticationBloc] for user data and logout
/// * Uses [BlocProvider.of] and "context.select" for efficient state access
/// * Automatically updates when authentication state changes
///
/// **Navigation:**
/// * Accessible via [route] method for consistent routing
/// * Typically navigated to after successful authentication
/// * Serves as the main authenticated screen in the app flow
/// {@endtemplate}
class HomePage extends StatelessWidget {
  /// {@macro home_page}
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return SafeArea(
      top: false,
      child: Scaffold(
        drawer: const AppDrawer(),
        appBar: AppBar(
          title: Text(localizations?.appTitle ?? 'PowerGodha'),
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              tooltip: 'Search',
              onPressed: () {
                // TODO: Navigate to search
              },
            ),
            IconButton(
              icon: const Icon(Icons.notifications_outlined),
              tooltip: 'Notifications',
              onPressed: () {
                // TODO: Navigate to notifications
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(AppTypography.space8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // FormName section
                const _FormName(),
                const SizedBox(height: AppTypography.space16),

                // Quick actions
                _QuickActions(
                  actions: [
                    QuickAction(
                      icon: 'assets/icons/record_milk.png',
                      label: 'Dashboard',
                      onPressed: () {
                        // Navigate to dashboard
                        Navigator.of(context).pushNamed(AppRoutes.dashboard);
                      },
                    ),

                    QuickAction(
                      icon: 'assets/icons/record_milk.png',
                      label: 'Analytics',
                      onPressed: () {
                        // Navigate to analytics
                      },
                    ),
                    QuickAction(
                      icon: 'assets/icons/record_milk.png',
                      label: 'Profile',
                      onPressed: () {
                        Navigator.of(context).pushNamed(AppRoutes.profile);
                      },
                    ),
                    QuickAction(
                      icon: 'assets/icons/record_milk.png',
                      label: 'Farm\nInvestment',
                      onPressed: () {
                        Navigator.of(context).pushNamed(AppRoutes.farmInvestmentDetails);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: AppTypography.space16),

                // Featured Carousel Slider
                const FeaturedCarousel(),
                const SizedBox(height: AppTypography.space16),

                // Record information card
                const _RecordInfoCard(),

                FittedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: _QuickActions(
                      actions: [
                        QuickAction(
                          icon: 'assets/icons/offers.png',
                          label: 'Offers',
                          onPressed: () {
                            // Navigate to offers
                          },
                        ),
                        QuickAction(
                          icon: 'assets/icons/profitable_dairy_farming.png',
                          label: 'Profitable\nDairy Farming',
                          onPressed: () {
                            // Navigate to analytics
                          },
                        ),
                        QuickAction(
                          icon: 'assets/icons/backyard_poultry.png',
                          label: 'Backyar\nPoultry',
                          onPressed: () {
                            Navigator.of(context).pushNamed(AppRoutes.profile);
                          },
                        ),
                        QuickAction(
                          icon: 'assets/icons/goat_farming.png',
                          label: 'Goat \n Farming',
                          onPressed: () {
                            // Navigate to help
                          },
                        ),
                        QuickAction(
                          icon: 'assets/icons/record_milk.png',
                          label: 'Record Milk',
                          onPressed: () {
                            Navigator.of(context).pushNamed(AppRoutes.vaccinationDetails);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Creates a [MaterialPageRoute] for navigating to the [HomePage].
  ///
  /// This static method provides a standardized way to create routes to the
  /// home page, ensuring consistent navigation throughout the application.
  ///
  /// **Returns:** A [MaterialPageRoute] that builds a [HomePage] instance
  ///
  /// **Usage:**
  /// ```dart
  /// // Navigate to home page after successful authentication
  /// Navigator.pushAndRemoveUntil(
  ///   context,
  ///   HomePage.route(),
  ///   (route) => false, // Clear navigation stack
  /// );
  /// ```
  ///
  /// **Navigation Integration:**
  /// This route is used by [AppView] when the authentication status changes
  /// to authenticated, ensuring users are directed to the main app interface.
  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const HomePage());
  }
}

class QuickAction {
  const QuickAction({required this.icon, required this.label, required this.onPressed});
  final String icon;
  final String label;
  final VoidCallback onPressed;
}

/// Welcome section widget that greets the user
class _FormName extends StatelessWidget {
  const _FormName();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).colorScheme.primary,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, state) {
              if (state.status == AuthenticationStatus.authenticated) {
                return Text(
                  state.user.farmName,
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                );
              }
              return Center(
                child: CircularProgressIndicator(color: Theme.of(context).colorScheme.onPrimary),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions({required this.actions});
  final List<QuickAction> actions;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: actions.map((action) {
        return Padding(
          padding: const EdgeInsets.all(8),
          child: _buildIconButton(
            context,
            icon: action.icon,
            label: action.label,
            onPressed: action.onPressed,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildIconButton(
    BuildContext context, {
    required String icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Column(
      children: [
        DecoratedBox(
          decoration: const BoxDecoration(shape: BoxShape.circle),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12), // adjust as needed
            child: Image.asset(
              icon,
              width: 50.w,
              height: 50.h,
              fit: BoxFit.cover, // optional, for best image scaling
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: Theme.of(context).textTheme.labelMedium, textAlign: TextAlign.center),
      ],
    );
  }
}

/// User information card
class _RecordInfoCard extends StatelessWidget {
  const _RecordInfoCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias, // Ensures image respects border radius
      child: Stack(
        children: [
          // Background image
          Positioned.fill(child: Image.asset('assets/profit_back.png', fit: BoxFit.cover)),
          // Content
          Padding(
            padding: const EdgeInsets.all(AppTypography.space16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppTypography.space32),
                const SizedBox(height: AppTypography.space32),
                const SizedBox(height: AppTypography.space32),
                Text(
                  'Latest profit/loss of your farm \n ${DateFormat('yyyy-MM-dd').format(DateTime.now())}',
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
                Text(
                  '₹2,23,232/-',
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: AppTypography.space16),
                const SizedBox(height: AppTypography.space8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Write Record',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white),
                    ),
                    const Icon(Icons.edit_outlined, color: Colors.white, size: 20),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
