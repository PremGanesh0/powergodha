import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:powergodha/shared/api/api_models.dart';
import 'package:powergodha/shared/services/about_app_data_service.dart';
import 'package:powergodha/shared/theme.dart';

/// {@template about_us_page}
/// A page that displays about us information from the API.
///
/// This page fetches and displays dynamic about us content based on
/// the user's language preference. It uses FutureBuilder for simple
/// state management and flutter_html for proper HTML rendering.
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
      body: FutureBuilder<AboutAppData>(
        future: AboutAppDataService().getAboutUs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return _buildErrorView(context, snapshot.error.toString());
          }

          if (snapshot.hasData && snapshot.data != null) {
            return _buildContentView(context, snapshot.data!);
          }

          return const Center(child: Text('No content available'));
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, AboutAppData aboutUsData) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTypography.radiusMedium.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HTML Content
              Html(
                data: aboutUsData.content,
                style: {
                  'body': Style(
                    fontSize: FontSize(14.sp),
                    lineHeight: LineHeight.number(1.6),
                    color: Theme.of(context).colorScheme.onSurface,
                    fontFamily: 'Ubuntu',
                    margin: Margins.zero,
                    padding: HtmlPaddings.zero,
                  ),
                  'p': Style(
                    margin: Margins.only(bottom: 12.h),
                    fontSize: FontSize(14.sp),
                    lineHeight: LineHeight.number(1.6),
                    textAlign: TextAlign.justify,
                  ),
                  'h1': Style(
                    fontSize: FontSize(20.sp),
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                    margin: Margins.only(bottom: 16.h, top: 16.h),
                  ),
                  'h2': Style(
                    fontSize: FontSize(18.sp),
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                    margin: Margins.only(bottom: 12.h, top: 12.h),
                  ),
                  'h3': Style(
                    fontSize: FontSize(16.sp),
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.primary,
                    margin: Margins.only(bottom: 8.h, top: 8.h),
                  ),
                  'ul': Style(
                    margin: Margins.only(bottom: 12.h),
                    padding: HtmlPaddings.only(left: 20.w),
                  ),
                  'li': Style(
                    margin: Margins.only(bottom: 6.h),
                    fontSize: FontSize(14.sp),
                    lineHeight: LineHeight.number(1.6),
                    display: Display.listItem,
                  ),
                  'strong': Style(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  'b': Style(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  'span': Style(fontSize: FontSize(14.sp), lineHeight: LineHeight.number(1.6)),
                },
              ),
              SizedBox(height: 16.h),
              // Language indicator
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(AppTypography.radiusSmall.r),
                ),
                child: Text(
                  'Language: ${_getLanguageName(aboutUsData.languageId)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContentView(BuildContext context, AboutAppData aboutUsData) {
    return RefreshIndicator(
      onRefresh: () async {
        // Trigger a rebuild to refresh data
        (context as Element).markNeedsBuild();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(children: [_buildHeader(context), _buildContent(context, aboutUsData)]),
      ),
    );
  }

  Widget _buildErrorView(BuildContext context, String errorMessage) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64.r,
              color: Theme.of(context).colorScheme.error,
            ),
            SizedBox(height: 16.h),
            Text(
              'Error loading content',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              errorMessage,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: () {
                // Trigger a rebuild to retry
                (context as Element).markNeedsBuild();
              },
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.r),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primaryContainer,
            Theme.of(context).colorScheme.primaryContainer.withOpacity(0.7),
          ],
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 100.w,
            height: 100.w,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Image.asset(
                'assets/app_logo.png',
                width: 60.w,
                height: 60.w,
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'PowerGodha',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Dream to Excel prospects of Indian Dairy Farmer',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.8),
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Helper method to get language name from language ID
  String _getLanguageName(int languageId) {
    switch (languageId) {
      case 1:
        return 'English';
      case 2:
        return 'Hindi';
      case 3:
        return 'Telugu';
      case 4:
        return 'Marathi';
      default:
        return 'Unknown';
    }
  }

  /// Route method for navigation
  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const AboutUsPage());
  }
}
