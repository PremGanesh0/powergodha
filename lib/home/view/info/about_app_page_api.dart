import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:powergodha/shared/services/about_app_data_service.dart';
import 'package:powergodha/shared/theme.dart';

/// {@template about_app_page}
/// A page that displays about app information from the API.
///
/// This page fetches and displays dynamic about app content based on
/// the user's language preference using FutureBuilder and flutter_html.
/// {@endtemplate}
class AboutAppPage extends StatelessWidget {
  /// {@macro about_app_page}
  const AboutAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About App'),
        elevation: 0,
      ),
      body: FutureBuilder<AboutAppData>(
        future: AboutAppDataService().getAboutApp(),
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

  Widget _buildContent(BuildContext context, AboutAppData aboutAppData) {
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
          child: Html(
            data: aboutAppData.content,
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
              'h1, h2, h3': Style(
                fontSize: FontSize(18.sp),
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
                margin: Margins.only(bottom: 12.h, top: 12.h),
              ),
              'strong, b': Style(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
              'ul': Style(
                margin: Margins.only(bottom: 12.h),
                padding: HtmlPaddings.only(left: 20.w),
              ),
              'li': Style(
                margin: Margins.only(bottom: 6.h),
                fontSize: FontSize(14.sp),
                lineHeight: LineHeight.number(1.6),
              ),
            },
          ),
        ),
      ),
    );
  }

  Widget _buildContentView(BuildContext context, AboutAppData aboutAppData) {
    return RefreshIndicator(
      onRefresh: () async {
        (context as Element).markNeedsBuild();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            _buildHeader(context),
            _buildContent(context, aboutAppData),
          ],
        ),
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
            width: 80.w,
            height: 80.w,
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
              child: Icon(
                Icons.mobile_friendly,
                size: 40.r,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'About PowerGodha App',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Learn about our innovative farming solution',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.8),
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Route method for navigation
  static Route<void> route() {
    return MaterialPageRoute<void>(
      builder: (_) => const AboutAppPage(),
    );
  }
}
