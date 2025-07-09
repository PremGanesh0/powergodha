import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:powergodha/app/app_routes.dart';
import 'package:powergodha/home/bloc/bloc.dart';
import 'package:powergodha/shared/theme.dart';

/// A carousel slider widget displaying featured content from the API
class FeaturedCarousel extends StatefulWidget {
  /// Creates a featured carousel widget
  const FeaturedCarousel({super.key});

  @override
  State<FeaturedCarousel> createState() => _FeaturedCarouselState();
}

class _FeaturedCarouselState extends State<FeaturedCarousel> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        // Use API data if available, otherwise fallback to static data
        final items = state.sliderArticles.isNotEmpty 
            ? state.sliderArticles 
            : _getFallbackItems();

        if (items.isEmpty) {
          return const SizedBox(
            height: 200,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return Column(
          children: [
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                SizedBox(
                  height: 200.0.h,
                  width: double.infinity,
                  child: CarouselSlider(
                    items: items.map((item) => _buildCarouselItem(context, item)).toList(),
                    options: CarouselOptions(
                      scrollDirection: Axis.vertical,
                      autoPlay: true,
                      enlargeCenterPage: true,
                      viewportFraction: 0.99,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: AppTypography.space16),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _buildPageIndicator(items.length),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  // Get fallback items when API data is not available
  List<Map<String, dynamic>> _getFallbackItems() {
    return [
      {
        'name': 'Welcome to PowerGodha',
        'subtitle': 'Modern livestock management system',
        'image': 'assets/app_logo.png',
        'web_url': 'app_navigation',
      },
      {
        'name': 'Daily Records',
        'subtitle': 'Track your livestock performance',
        'image': 'assets/app_logo.png',
        'web_url': 'app_navigation',
      },
      {
        'name': 'Analytics Dashboard',
        'subtitle': 'View your farm analytics',
        'image': 'assets/app_logo.png',
        'web_url': 'app_navigation',
      },
    ];
  }

  // Build a single carousel item with overlay text
  Widget _buildCarouselItem(BuildContext context, Map<String, dynamic> item) {
    // Handle both API data structure and fallback structure
    final title = (item['name'] ?? item['title'] ?? 'PowerGodha').toString();
    final subtitle = (item['subtitle'] ?? 'Livestock Management').toString();
    final imageUrl = (item['image'] ?? item['thumbnail'] ?? 'assets/app_logo.png').toString();
    final webUrl = (item['web_url'] ?? 'app_navigation').toString();

    return GestureDetector(
      onTap: () {
        // Handle different web_url actions
        if (webUrl.contains('app') || webUrl == 'app_navigation') {
          Navigator.of(context).pushNamed(AppRoutes.home);
        } else {
          // For external links, could open browser or show more info
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Action: $webUrl')),
          );
        }
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppTypography.radiusMedium),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background image
            ClipRRect(
              borderRadius: BorderRadius.circular(AppTypography.radiusMedium),
              child: _buildImage(imageUrl),
            ),
            // Overlay gradient for better text readability
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppTypography.radiusMedium),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                ),
              ),
            ),
            // Text overlay positioned at bottom
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withOpacity(0.9),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build image widget that handles both network and asset images
  Widget _buildImage(String imageUrl) {
    if (imageUrl.startsWith('http')) {
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(
            'assets/app_logo.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          );
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return ColoredBox(
            color: Colors.grey.shade200,
            child: Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
              ),
            ),
          );
        },
      );
    } else {
      return Image.asset(
        imageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }
  }

  // Build page indicator dots at the bottom
  List<Widget> _buildPageIndicator(int itemCount) {
    return List<Widget>.generate(
      itemCount,
      (index) => Container(
        width: 8,
        height: 8,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _currentIndex == index
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.outlineVariant,
        ),
      ),
    );
  }
}
