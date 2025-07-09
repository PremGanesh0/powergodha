import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:powergodha/shared/theme.dart';

/// {@template about_app_page}
/// A page that displays information about the PowerGodha app,
/// including version, purpose, features, and developer information.
/// {@endtemplate}
class AboutAppPage extends StatefulWidget {
  /// {@macro about_app_page}
  const AboutAppPage({super.key});

  @override
  State<AboutAppPage> createState() => _AboutAppPageState();

  /// Creates a [MaterialPageRoute] for navigating to the [AboutAppPage].
  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const AboutAppPage());
  }
}

class _AboutAppPageState extends State<AboutAppPage> {
  String _version = '';
  String _buildNumber = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPackageInfo();
  }

  Future<void> _loadPackageInfo() async {
    final packageInfo = await PackageInfo.fromPlatform();
    if (mounted) {
      setState(() {
        _version = packageInfo.version;
        _buildNumber = packageInfo.buildNumber;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About PowerGodha'),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeaderSection(context),
                    SizedBox(height: 24.h),
                    _buildAppDescription(context),
                    SizedBox(height: 24.h),
                    _buildFeaturesSection(context),
                    SizedBox(height: 24.h),
                    _buildTechnicalDetails(context),
                    SizedBox(height: 24.h),
                    _buildDeveloperInfo(context),
                    SizedBox(height: 24.h),
                    _buildLegalSection(context),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildHeaderSection(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            width: 120.w,
            height: 120.w,
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: Image.asset(
              'assets/app_logo.png',
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'PowerGodha',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Version $_version (Build $_buildNumber)',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppDescription(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context, 'About', Icons.info_outline),
        SizedBox(height: 12.h),
        Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTypography.radiusMedium.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Text(
              'PowerGodha is a comprehensive livestock management application '
              'designed for farmers to efficiently track, manage, and optimize '
              'their agricultural operations. The app provides tools for livestock '
              'record-keeping, production analytics, health monitoring, and financial '
              'management to help increase productivity and profitability.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturesSection(BuildContext context) {
    final features = [
      _Feature(
        title: 'Livestock Management',
        description: 'Track individual animals with complete history, breeding records, and genealogy.',
        icon: Icons.pets,
      ),
      _Feature(
        title: 'Production Tracking',
        description: 'Record and analyze milk production, growth rates, and other yield metrics.',
        icon: Icons.trending_up,
      ),
      _Feature(
        title: 'Health Monitoring',
        description: 'Track vaccinations, treatments, and health events with automated reminders.',
        icon: Icons.medical_services,
      ),
      _Feature(
        title: 'Financial Analytics',
        description: 'Monitor expenses, income, and profitability across your farming operations.',
        icon: Icons.attach_money,
      ),
      _Feature(
        title: 'Multilingual Support',
        description: 'Available in multiple languages including English, Hindi, Telugu, and Marathi.',
        icon: Icons.language,
      ),
      _Feature(
        title: 'Offline Functionality',
        description: 'Use the app even without an internet connection with data synchronization when online.',
        icon: Icons.wifi_off,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context, 'Key Features', Icons.star_outline),
        SizedBox(height: 12.h),
        Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTypography.radiusMedium.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              children: features
                  .map(
                    (feature) => _buildFeatureItem(
                      context,
                      feature.title,
                      feature.description,
                      feature.icon,
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureItem(
    BuildContext context,
    String title,
    String description,
    IconData icon,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
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
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
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

  Widget _buildTechnicalDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context, 'Technical Details', Icons.code),
        SizedBox(height: 12.h),
        Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTypography.radiusMedium.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              children: [
                _buildDetailRow(context, 'Framework', 'Flutter'),
                _buildDetailRow(context, 'Database', 'SQLite (Local), Firebase (Cloud)'),
                _buildDetailRow(context, 'Minimum OS Version', 'Android 5.0, iOS 12.0'),
                _buildDetailRow(context, 'Last Updated', 'June 2025'),
                _buildDetailRow(context, 'Size', '25 MB'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeveloperInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context, 'Developer Information', Icons.business),
        SizedBox(height: 12.h),
        Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTypography.radiusMedium.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              children: [
                _buildDetailRow(context, 'Developer', 'PowerGodha Technologies Pvt. Ltd.'),
                _buildDetailRow(context, 'Website', 'www.powergodha.com'),
                _buildDetailRow(context, 'Email', 'support@powergodha.com'),
                _buildDetailRow(context, 'Founded', '2023'),
                _buildDetailRow(
                  context,
                  'Mission',
                  'To empower farmers with technology solutions that increase productivity and sustainability.',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLegalSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context, 'Legal Information', Icons.gavel),
        SizedBox(height: 12.h),
        Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTypography.radiusMedium.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              children: [
                _buildLegalButton(
                  context,
                  'Terms of Service',
                  Icons.description_outlined,
                  () {
                    // Navigate to Terms of Service page or launch URL
                    // Navigator.of(context).push...
                  },
                ),
                Divider(height: 24.h),
                _buildLegalButton(
                  context,
                  'Privacy Policy',
                  Icons.privacy_tip_outlined,
                  () {
                    // Navigate to Privacy Policy page or launch URL
                    // Navigator.of(context).push...
                  },
                ),
                Divider(height: 24.h),
                _buildLegalButton(
                  context,
                  'Open Source Licenses',
                  Icons.source_outlined,
                  () {
                    // Show licenses page
                    showLicensePage(
                      context: context,
                      applicationName: 'PowerGodha',
                      applicationVersion: 'v$_version',
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLegalButton(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Row(
          children: [
            Icon(
              icon,
              size: 24.r,
              color: Theme.of(context).colorScheme.primary,
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16.r,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          size: 24.r,
          color: Theme.of(context).colorScheme.primary,
        ),
        SizedBox(width: 8.w),
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
      ],
    );
  }
}

/// Feature data model for the Features section
class _Feature {
  final String title;
  final String description;
  final IconData icon;

  _Feature({
    required this.title,
    required this.description,
    required this.icon,
  });
}
