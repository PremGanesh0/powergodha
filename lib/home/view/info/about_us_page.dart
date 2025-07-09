import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:powergodha/shared/theme.dart';

/// {@template about_us_page}
/// A page that displays information about PowerGodha.
///
/// This page provides an overview of the organization, including:
/// * Company description
/// * Mission statement
/// * Vision
/// * Core values
/// * Features and benefits
///
/// The page follows Material Design guidelines and uses responsive layout
/// through ScreenUtil for consistency across different device sizes.
/// {@endtemplate}
class AboutUsPage extends StatelessWidget {
  /// {@macro about_us_page}
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderSection(context),
              SizedBox(height: 24.h),
              _buildAboutSection(context),
              SizedBox(height: 24.h),
              _buildMissionVisionSection(context),
              SizedBox(height: 24.h),
              _buildValuesSection(context),
              SizedBox(height: 24.h),
              _buildTeamSection(context),
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
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Image.asset(
                'assets/app_logo.png',
                width: 100.w,
                height: 100.w,
              ),
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
            'Empowering Farmers with Technology',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context, 'Our Story', Icons.history),
        SizedBox(height: 12.h),
        Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTypography.radiusMedium.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Text(
              'PowerGodha was founded in 2023 with a clear vision: to revolutionize '
              'livestock management for farmers across India. Our founders, coming from '
              'agricultural backgrounds themselves, understood the challenges faced by '
              'farmers in managing their livestock efficiently.\n\n'
              'We began by conducting extensive research with farmers from various regions, '
              'understanding their pain points, and designing solutions specifically '
              'tailored to address their needs. Today, PowerGodha has grown to serve '
              'thousands of farmers across multiple states, helping them increase '
              'productivity and profitability.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMissionVisionSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context, 'Mission & Vision', Icons.lightbulb_outline),
        SizedBox(height: 12.h),
        Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTypography.radiusMedium.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Our Mission',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'To empower farmers with accessible technology solutions that '
                  'simplify livestock management, increase productivity, and '
                  'improve livelihoods across rural communities.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                SizedBox(height: 16.h),
                Text(
                  'Our Vision',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'To be the leading agricultural technology platform that '
                  'transforms traditional farming practices into efficient, '
                  'data-driven operations, contributing to sustainable '
                  'agricultural growth and food security.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildValuesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context, 'Our Values', Icons.star_outline),
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
                _buildValueItem(
                  context,
                  'Farmer-Centric',
                  'We place farmers at the center of everything we do, designing solutions that address their real needs.',
                ),
                Divider(height: 24.h),
                _buildValueItem(
                  context,
                  'Innovation',
                  'We continuously innovate to make complex agricultural processes simple and efficient.',
                ),
                Divider(height: 24.h),
                _buildValueItem(
                  context,
                  'Inclusivity',
                  'We ensure our solutions are accessible to all farmers regardless of scale, literacy, or technological familiarity.',
                ),
                Divider(height: 24.h),
                _buildValueItem(
                  context,
                  'Sustainability',
                  'We promote sustainable farming practices that benefit both farmers and the environment.',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildValueItem(BuildContext context, String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.check_circle,
          color: Theme.of(context).colorScheme.primary,
          size: 24.r,
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
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
    );
  }

  Widget _buildTeamSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context, 'Our Team', Icons.people_outline),
        SizedBox(height: 12.h),
        Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTypography.radiusMedium.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Text(
              'PowerGodha is built by a dedicated team of agricultural experts, '
              'technologists, and designers who share a passion for rural development. '
              'Our team members come from diverse backgrounds but are united by the '
              'mission to transform agricultural practices through technology.\n\n'
              'We work closely with farming communities to understand their needs '
              'and continuously improve our solutions based on their feedback.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ),
      ],
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

  /// Creates a [MaterialPageRoute] for navigating to the [AboutUsPage].
  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const AboutUsPage());
  }
}
