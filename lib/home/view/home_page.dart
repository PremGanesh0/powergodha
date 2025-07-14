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
import 'package:powergodha/app/app_routes.dart';
import 'package:powergodha/app/app_view.dart' show AppView;
import 'package:powergodha/authentication/bloc/authentication_bloc.dart';
import 'package:powergodha/home/bloc/bloc.dart';
import 'package:powergodha/home/view/bottomNavigation/profitable_dairy_farm_view.dart';
import 'package:powergodha/home/widgets/app_drawer.dart';
import 'package:powergodha/home/widgets/featured_carousel.dart';
import 'package:powergodha/home/widgets/profit_loss.dart';
import 'package:powergodha/l10n/app_localizations.dart';
import 'package:powergodha/shared/shared.dart';

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
    return BlocProvider(
      create: (context) => HomeBloc()..add(const HomeStarted()),
      child: const _HomePage(),
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

class _HomePage extends StatelessWidget {
  const _HomePage();

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
            BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                return _NotificationButton(
                  notificationCount: state.notificationCount,
                  onPressed: () {
                    // TODO: Navigate to notifications
                  },
                );
              },
            ),
            // IconButton(
            //   icon: const Icon(Icons.refresh),
            //   tooltip: 'Refresh',
            //   onPressed: () {
            //     context.read<HomeBloc>().add(const RefreshHomeData());
            //   },
            // ),
          ],
        ),
        body: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state.status == HomeStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.status == HomeStatus.error) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error loading data',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.errorMessage ?? 'An unknown error occurred',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<HomeBloc>().add(const RefreshHomeData());
                      },
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<HomeBloc>().add(const RefreshHomeData());
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
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
                            label: 'Reports',
                            onPressed: () {
                              Navigator.of(
                                context,
                              ).pushNamed(AppRoutes.reports);
                            },
                          ),
                          QuickAction(
                            icon: 'assets/icons/record_milk.png',
                            label: 'ORB',
                            onPressed: () {
                              Navigator.of(
                                context,
                              ).pushNamed(AppRoutes.dailyRecords);
                            },
                          ),
                          QuickAction(
                            icon: 'assets/icons/record_milk.png',
                            label: 'Premium',
                            onPressed: () {
                              // Navigator.of(
                              //   context,
                              // ).pushNamed(AppRoutes.profile);
                            },
                          ),
                          QuickAction(
                            icon: 'assets/icons/record_milk.png',
                            label: 'Dashboard',
                            onPressed: () {
                              Navigator.of(
                                context,
                              ).pushNamed(AppRoutes.dashboard);
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: AppTypography.space16),

                      // Featured Carousel Slider
                      const FeaturedCarousel(),
                      const SizedBox(height: AppTypography.space16),

                      // Record information card
                      RecordInfoCard(profitLossReport: state.profitLossReport),

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
                                icon:
                                    'assets/icons/profitable_dairy_farming.png',
                                label: 'Profitable\nDairy Farming',
                                onPressed: () {
                                  Navigator.of(context).push(ProfitableDiaryFarmView.route());
                                },
                              ),
                              QuickAction(
                                icon: 'assets/icons/backyard_poultry.png',
                                label: 'Backyar\nPoultry',
                                onPressed: () {
                                  Navigator.of(
                                    context,
                                  ).pushNamed(AppRoutes.profile);
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
                                  // Navigator.of(
                                  //   context,
                                  // ).pushNamed(AppRoutes.record);
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
            );
          },
        ),
      ),
    );
  }
}

/// {@template notification_button}
/// A custom notification button widget that displays a badge with the notification count.
/// {@endtemplate}
class _NotificationButton extends StatelessWidget {
  /// {@macro notification_button}
  const _NotificationButton({required this.notificationCount,
    required this.onPressed,
  });

  /// The number of unread notifications
  final int notificationCount;

  /// Callback when the notification button is pressed
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Stack(
        children: [
          const Icon(Icons.notifications_outlined),
          if (notificationCount > 0)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
                constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                child: Text(
                  notificationCount > 99 ? '99+' : notificationCount.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
      tooltip: 'Notifications',
      onPressed: onPressed,
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
    return InkWell(
      onTap: onPressed,
      child: Column(
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
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
