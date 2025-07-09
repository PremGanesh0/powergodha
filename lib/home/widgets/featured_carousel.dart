import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:powergodha/app/app_routes.dart';
import 'package:powergodha/shared/theme.dart';

/// A carousel slider widget displaying featured content
class FeaturedCarousel extends StatefulWidget {
  /// Creates a featured carousel widget
  const FeaturedCarousel({super.key});

  @override
  State<FeaturedCarousel> createState() => _FeaturedCarouselState();
}

class _FeaturedCarouselState extends State<FeaturedCarousel> {
  int _currentIndex = 0;

  // Sample carousel items - replace with actual data from your backend
  final List<Map<String, String>> _items = [
    {
      'image': 'assets/app_logo.png',
      'title': 'Welcome to PowerGodha',
      'subtitle': 'Modern livestock management system',
      'route': AppRoutes.home,
    },
    {
      'image': 'assets/app_logo.png',
      'title': 'Daily Records',
      'subtitle': 'Track your livestock performance',
      'route': AppRoutes.home,
    },
    {
      'image': 'assets/app_logo.png',
      'title': 'Analytics Dashboard',
      'subtitle': 'View your farm analytics',
      'route': AppRoutes.home,
    },
    {
      'image': 'assets/app_logo.png',
      'title': 'Milk Production',
      'subtitle': 'Track milk yields and quality',
      'route': AppRoutes.home,
    },
    {
      'image': 'assets/app_logo.png',
      'title': 'Vaccination Schedule',
      'subtitle': 'Keep your livestock healthy',
      'route': AppRoutes.home,
    },
    {
      'image': 'assets/app_logo.png',
      'title': 'Market Updates',
      'subtitle': 'Latest livestock market trends',
      'route': AppRoutes.home,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            SizedBox(
              height: 200.0.h,
              width: double.infinity,
              child: CarouselSlider(
                items: _items.map((item) => _buildCarouselItem(context, item)).toList(),
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
                children: _buildPageIndicator(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Build a single carousel item with overlay text
  Widget _buildCarouselItem(BuildContext context, Map<String, String> item) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(item['route']!);
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
              child: Image.asset(
                item['image']!,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
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
                    item['title']!,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item['subtitle']!,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.white.withOpacity(0.9)),
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

  // Build page indicator dots at the bottom
  List<Widget> _buildPageIndicator() {
    return List<Widget>.generate(
      _items.length,
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
