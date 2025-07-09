import 'package:authentication_repository/authentication_repository.dart' show AuthenticationStatus;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:powergodha/app/app_routes.dart';
import 'package:powergodha/app/app_view.dart' show AppView;
import 'package:powergodha/authentication/bloc/authentication_bloc.dart';
import 'package:powergodha/l10n/app_localizations.dart';
import 'package:powergodha/shared/theme.dart';

String _languageTitle(String languageCode) {
  return switch (languageCode) {
    'en' => 'English',
    'ne' => 'नेपाली',
    'hi' => 'हिन्दी',
    _ => languageCode.toUpperCase(),
  };
}

/// A widget that represents the app's navigation drawer.
///
/// This widget encapsulates all the navigation options available in the
/// application's drawer, including:
/// * Primary navigation links
/// * Language selection
/// * Logout functionality
/// * App version information
///
/// The drawer follows Material Design guidelines and includes proper spacing,
/// typography, and responsiveness through ScreenUtil.
class AppDrawer extends StatefulWidget {
  /// Creates an app drawer widget.
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> with SingleTickerProviderStateMixin {
  String _version = '';
  bool _isLoading = true;
  bool _isHelpExpanded = false;
  bool _isProfileExpanded = false;

  // Animation durations and curves for smoother transitions
  final Duration _animationDuration = const Duration(milliseconds: 300);
  final Curve _animationCurve = Curves.easeInOut;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Drawer(
      width: 280.w,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildDrawerHeader(context),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.home, (route) => false);
            },
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Dashboard'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.of(context).pushNamed(AppRoutes.dashboard);
            },
          ),
          ListTile(
            leading: const Icon(Icons.receipt_rounded),
            title: const Text('Daily Records'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.of(context).pushNamed(AppRoutes.dailyRecords);
            },
          ),
          ListTile(
            leading: const Icon(Icons.receipt_rounded),
            title: const Text('Record Milk'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              // TODO: Navigate to analytics
            },
          ),
          ListTile(
            leading: const Icon(Icons.report),
            title: const Text('Report'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.of(context).pushNamed(AppRoutes.reports);
            },
          ),

          // Profile section with expandable sub-items
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            trailing: AnimatedRotation(
              duration: _animationDuration,
              curve: _animationCurve,
              turns: _isProfileExpanded ? 0.25 : 0,
              child: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ),
            onTap: () {
              setState(() {
                _isProfileExpanded = !_isProfileExpanded;
              });
            },
          ),
          // Profile sub-items with smooth animation
          AnimatedContainer(
            duration: _animationDuration,
            curve: _animationCurve,
            height: _isProfileExpanded ? 110.h : 0,
            child: ClipRect(
              child: Align(
                alignment: Alignment.topCenter,
                heightFactor: _isProfileExpanded ? 1.0 : 0.0,
                child: Column(
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.only(left: 56.w, right: 16.w),
                      title: Text(
                        'Profile Information',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      onTap: () {
                        Navigator.pop(context); // Close the drawer
                        Navigator.of(context).pushNamed(AppRoutes.profile);
                      },
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.only(left: 56.w, right: 16.w),
                      title: Text(
                        'Form Information',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      onTap: () {
                        Navigator.pop(context); // Close the drawer
                        Navigator.of(context).pushNamed(AppRoutes.farmInformation);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),

          ListTile(
            leading: const Icon(Icons.vaccines),
            title: const Text('Vaccination'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.of(context).pushNamed(AppRoutes.vaccinationDetails);
            },
          ),
          ListTile(
            leading: const Icon(Icons.report),
            title: const Text('Pedigree Report'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.of(context).pushNamed(AppRoutes.pedigreeReport);
            },
          ),
          ListTile(
            leading: const Icon(Icons.shopping_cart),
            title: const Text('Products'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.of(context).pushNamed(AppRoutes.products);
            },
          ),
          // Language selector
          ListTile(
            leading: const Icon(Icons.language),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Language/भाषा'),
                Text(
                  localizations != null
                      ? ' ${_languageTitle(localizations.localeName)}'
                      : 'Language',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.primary),
                ),
              ],
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.of(context).pushNamed(AppRoutes.languageSelection);
            },
          ),
          // Help section with expandable sub-items
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('Help'),
            trailing: AnimatedRotation(
              duration: _animationDuration,
              curve: _animationCurve,
              turns: _isHelpExpanded ? 0.25 : 0,
              child: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ),
            onTap: () {
              setState(() {
                _isHelpExpanded = !_isHelpExpanded;
              });
            },
          ),
          // Help sub-items with smooth animation
          AnimatedContainer(
            duration: _animationDuration,
            curve: _animationCurve,
            height: _isHelpExpanded ? 210.h : 0,
            child: ClipRect(
              child: Align(
                alignment: Alignment.topCenter,
                heightFactor: _isHelpExpanded ? 1.0 : 0.0,
                child: Column(
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.only(left: 56.w, right: 16.w),
                      title: Text('About App', style: Theme.of(context).textTheme.bodyMedium),
                      onTap: () {
                        Navigator.pop(context); // Close the drawer
                        Navigator.of(context).pushNamed(AppRoutes.aboutApp);
                      },
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.only(left: 56.w, right: 16.w),
                      title: Text('How to use app', style: Theme.of(context).textTheme.bodyMedium),
                      onTap: () {
                        Navigator.pop(context); // Close the drawer
                        Navigator.of(context).pushNamed(AppRoutes.howToUseApp);
                      },
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.only(left: 56.w, right: 16.w),
                      title: Text('About Us', style: Theme.of(context).textTheme.bodyMedium),
                      onTap: () {
                        Navigator.pop(context); // Close the drawer
                        Navigator.of(context).pushNamed(AppRoutes.aboutUs);
                      },
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.only(left: 56.w, right: 16.w),
                      title: Text('Contact Us', style: Theme.of(context).textTheme.bodyMedium),
                      onTap: () {
                        Navigator.pop(context); // Close the drawer
                        Navigator.of(context).pushNamed(AppRoutes.contactUs);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const _LogoutButton(),
              if (!_isLoading)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  child: Text(
                    'v$_version',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadPackageInfo();
  }

  Widget _buildDrawerHeader(BuildContext context) {
    return DrawerHeader(
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary),
      child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          // Check if the state is authenticated by checking the status instead of using 'is' expression
          if (state.status == AuthenticationStatus.authenticated) {
            return Row(
              children: [
                CircleAvatar(
                  radius: 36.r,
                  backgroundColor: Theme.of(context).colorScheme.onPrimary.withOpacity(0.2),
                  child: Icon(
                    Icons.person,
                    size: 48.r,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Welcome,',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                      Text(
                        state.user.farmName,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),

                    ],
                  ),
                ),
              ],
            );
          }
          return Center(
            child: CircularProgressIndicator(color: Theme.of(context).colorScheme.onPrimary),
          );
        },
      ),
    );
  }

  Future<void> _loadPackageInfo() async {
    final packageInfo = await PackageInfo.fromPlatform();
    if (mounted) {
      setState(() {
        _version = '${packageInfo.version}+${packageInfo.buildNumber}';
        _isLoading = false;
      });
    }
  }
}

/// A private widget that provides logout functionality.
///
/// This widget renders an elevated button that triggers the logout process
/// when pressed. It integrates directly with the [AuthenticationBloc] to
/// dispatch logout events.
///
/// **Functionality:**
/// * Displays a styled logout button
/// * Dispatches [AuthenticationLogoutPressed] event when pressed
/// * Uses "context.read" for efficient bloc access without listening
///
/// **Design:**
/// * Uses [ElevatedButton] for prominent, actionable appearance
/// * Simple text label for clear user understanding
/// * Follows Material Design guidelines for button styling
///
/// **Integration:**
/// * Accesses [AuthenticationBloc] from the widget tree context
/// * Triggers logout flow which will update app navigation
/// * No need to handle navigation directly (handled by [AppView])
class _LogoutButton extends StatelessWidget {
  /// Creates a logout button widget.
  const _LogoutButton();

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return ElevatedButton.icon(
      icon: const Icon(Icons.logout_outlined),
      label: Text(localizations?.signOut ?? 'Sign Out'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        minimumSize: const Size(120, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTypography.radiusMedium),
        ),
      ),
      onPressed: () {
        // Dispatch logout event to the authentication bloc
        // This will trigger the logout process and update authentication state
        context.read<AuthenticationBloc>().add(AuthenticationLogoutPressed());
      },
    );
  }
}
