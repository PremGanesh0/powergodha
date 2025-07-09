import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:powergodha/shared/theme.dart';

/// {@template how_to_use_app_page}
/// A guide page that provides instructions on how to use the PowerGodha app.
///
/// This page offers step-by-step guidance on using the app's core features:
/// * Getting started with the app
/// * Navigating the dashboard
/// * Managing livestock records
/// * Using analytics features
/// * Setting up notifications
///
/// Each section includes clear instructions and tips for effective usage.
/// {@endtemplate}
class HowToUseAppPage extends StatelessWidget {
  /// {@macro how_to_use_app_page}
  const HowToUseAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('How to Use the App'),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Introduction section
              Text(
                'Welcome to PowerGodha!',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'This guide will help you get the most out of our livestock management platform. '
                'Follow these instructions to better understand how PowerGodha works.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              SizedBox(height: 24.h),

              // Step 1: Getting Started
              const _InstructionSection(
                stepNumber: 1,
                title: 'Getting Started',
                instructions: [
                  _Instruction(
                    title: 'Log in to your account',
                    description: 'Use your registered phone number and password to log in. '
                        'If you\'ve forgotten your password, use the "Forgot Password" option.',
                    icon: Icons.login,
                  ),
                  _Instruction(
                    title: 'Complete your profile',
                    description: 'Navigate to the Profile section and ensure all your '
                        'information is up-to-date, including your farm details.',
                    icon: Icons.person,
                  ),
                  _Instruction(
                    title: 'Set your language preference',
                    description: 'PowerGodha supports multiple languages. Choose your preferred '
                        'language from the drawer menu under "Language/भाषा".',
                    icon: Icons.language,
                  ),
                ],
              ),

              SizedBox(height: 16.h),

              // Step 2: Dashboard Navigation
              const _InstructionSection(
                stepNumber: 2,
                title: 'Navigating the Dashboard',
                instructions: [
                  _Instruction(
                    title: 'Understand the home screen',
                    description: 'The home screen shows key statistics about your livestock, '
                        'upcoming tasks, and recent activities.',
                    icon: Icons.dashboard,
                  ),
                  _Instruction(
                    title: 'Access the menu drawer',
                    description: 'Tap the hamburger icon (≡) in the top-left corner to open '
                        'the navigation drawer. This gives you access to all app sections.',
                    icon: Icons.menu,
                  ),
                  _Instruction(
                    title: 'Use Quick Actions',
                    description: 'The Quick Actions section on the home screen provides shortcuts '
                        'to your most common tasks.',
                    icon: Icons.flash_on,
                  ),
                ],
              ),

              SizedBox(height: 16.h),

              // Step 3: App Navigation
              const _InstructionSection(
                stepNumber: 3,
                title: 'Navigating Between Screens',
                instructions: [
                  _Instruction(
                    title: 'Using Bottom Navigation',
                    description: "The app's main sections are accessible via the bottom navigation bar. "
                        'Tap on the icons to quickly switch between key features.',
                    icon: Icons.swap_horiz,
                  ),
                  _Instruction(
                    title: 'Navigate Back',
                    description: 'Use the back arrow (←) in the app bar to return to the previous screen. '
                        "You can also use your device's back button for the same purpose.",
                    icon: Icons.arrow_back,
                  ),
                  _Instruction(
                    title: 'Accessing Help Pages',
                    description: 'Tap on the Help option in the drawer menu to access guides like this one, '
                        'along with About Us and Contact Support pages.',
                    icon: Icons.help_outline,
                  ),
                ],
              ),

              SizedBox(height: 16.h),

              // Step 4: Managing Records
              const _InstructionSection(
                stepNumber: 4,
                title: 'Managing Livestock Records',
                instructions: [
                  _Instruction(
                    title: 'Add new livestock',
                    description: 'Go to the Records section and tap the "+" button to add '
                        'a new animal. Fill in details like breed, birth date, weight, and ID.',
                    icon: Icons.add_circle,
                  ),
                  _Instruction(
                    title: 'Record daily activities',
                    description: 'Use the Daily Records section to log milk production, '
                        'feed consumption, health checks, and other daily activities.',
                    icon: Icons.calendar_today,
                  ),
                  _Instruction(
                    title: 'Track health records',
                    description: 'Record vaccinations, treatments, and health issues. '
                        'Set reminders for upcoming treatments or check-ups.',
                    icon: Icons.medical_services,
                  ),
                ],
              ),

              SizedBox(height: 16.h),

              // Step 5: Using Analytics & Reports
              const _InstructionSection(
                stepNumber: 5,
                title: 'Using Analytics & Reports',
                instructions: [
                  _Instruction(
                    title: 'View production trends',
                    description: 'The Analytics section shows trends in milk production, '
                        'growth rates, and other key metrics over time.',
                    icon: Icons.analytics,
                  ),
                  _Instruction(
                    title: 'Generate reports',
                    description: 'Create detailed reports for specific time periods '
                        'or livestock groups. Reports can be saved and shared.',
                    icon: Icons.bar_chart,
                  ),
                  _Instruction(
                    title: 'Analyze profitability',
                    description: 'Track expenses and income to understand the profitability '
                        'of different animals or operations.',
                    icon: Icons.monetization_on,
                  ),
                ],
              ),

              SizedBox(height: 16.h),

              // Step 6: Settings & Preferences
              const _InstructionSection(
                stepNumber: 6,
                title: 'Settings & Preferences',
                instructions: [
                  _Instruction(
                    title: 'Customize notifications',
                    description: 'Go to Settings to manage what notifications you receive '
                        'and how you receive them.',
                    icon: Icons.notifications,
                  ),
                  _Instruction(
                    title: 'Backup your data',
                    description: 'Use the backup feature to keep your data safe. '
                        'We recommend regular backups to prevent data loss.',
                    icon: Icons.backup,
                  ),
                  _Instruction(
                    title: 'Get help',
                    description: 'If you encounter any issues, tap on Help in the drawer menu '
                        'to access FAQs or contact our support team.',
                    icon: Icons.help,
                  ),
                ],
              ),

              SizedBox(height: 24.h),

              // Tips & Tricks
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTypography.radiusMedium.r),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.lightbulb,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'Tips & Tricks',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      const _TipItem(
                        tip: 'Swipe right on a record to quickly view details.',
                      ),
                      const _TipItem(
                        tip: 'Long-press on a chart to see specific data points.',
                      ),
                      const _TipItem(
                        tip: 'Double-tap on the home screen to quickly access your most used features.',
                      ),
                      const _TipItem(
                        tip: 'Use tags to categorize your livestock for easier filtering and reporting.',
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 24.h),

              // Quick Navigation Options
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTypography.radiusMedium.r),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.r),
                  child: Column(
                    children: [
                      Text(
                        'Quick Navigation',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        'Explore these important sections of the app:',
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16.h),
                      Wrap(
                        spacing: 12.w,
                        runSpacing: 12.h,
                        alignment: WrapAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            icon: const Icon(Icons.contact_support),
                            label: const Text('Contact Us'),
                            onPressed: () {
                              Navigator.of(context).pushNamed('/contact-us');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              foregroundColor: Theme.of(context).colorScheme.onPrimary,
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 10.h,
                              ),
                            ),
                          ),
                          OutlinedButton.icon(
                            icon: const Icon(Icons.business),
                            label: const Text('About Us'),
                            onPressed: () {
                              Navigator.of(context).pushNamed('/about-us');
                            },
                          ),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.home),
                            label: const Text('Home'),
                            onPressed: () {
                              Navigator.of(context).pushNamed('/');
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 24.h),

              // Need More Help?
              Center(
                child: Column(
                  children: [
                    Text(
                      'Need more help?',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    OutlinedButton.icon(
                      icon: const Icon(Icons.contact_support),
                      label: const Text('Contact Support'),
                      onPressed: () {
                        Navigator.of(context).pushNamed('/contact-us');
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Creates a [MaterialPageRoute] for navigating to the [HowToUseAppPage].
  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const HowToUseAppPage());
  }
}

/// A single instruction with an icon, title, and description.
class _Instruction extends StatelessWidget {
  const _Instruction({
    required this.title,
    required this.description,
    required this.icon,
  });

  final String title;
  final String description;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              icon,
              size: 24.r,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// A section of instructions with a step number, title, and list of instructions.
class _InstructionSection extends StatelessWidget {
  const _InstructionSection({
    required this.stepNumber,
    required this.title,
    required this.instructions,
  });

  final int stepNumber;
  final String title;
  final List<_Instruction> instructions;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTypography.radiusMedium.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 32.w,
                  height: 32.w,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      stepNumber.toString(),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            ...instructions,
          ],
        ),
      ),
    );
  }
}

/// A tip item with a bullet point and tip text.
class _TipItem extends StatelessWidget {
  const _TipItem({required this.tip});

  final String tip;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '•',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              tip,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
