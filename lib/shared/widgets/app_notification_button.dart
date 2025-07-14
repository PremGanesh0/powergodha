/// Centralized notification button widget that uses HomeBloc for notification count.
///
/// This file contains the [AppNotificationButton] widget which provides:
/// * Centralized notification icon with badge using HomeBloc state
/// * Consistent notification display across the entire app
/// * Customizable onPressed callback for navigation
/// * Automatic badge count updates from HomeBloc
/// * Graceful fallback when HomeBloc is not available
///
/// **Usage:**
/// ```dart
/// AppNotificationButton(
///   onPressed: () => Navigator.pushNamed(context, '/notifications'),
/// )
/// ```
///
/// **Architecture:**
/// * Uses Provider.of<HomeBloc?> to safely check for HomeBloc availability
/// * Uses BlocBuilder<HomeBloc, HomeState> when HomeBloc is available
/// * Falls back to no badge when HomeBloc is not in context
/// * Follows Material Design guidelines for notification badges
/// * Supports 99+ display for large notification counts
/// * Reusable across all app screens that need notification display
///
/// This widget centralizes notification badge logic and ensures all
/// notification icons in the app reflect the same HomeBloc state when available.
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:powergodha/home/bloc/bloc.dart';
import 'package:provider/provider.dart';

/// {@template app_notification_button}
/// A centralized notification button that displays a badge with count from HomeBloc.
///
/// This widget uses Provider.of to safely check for HomeBloc availability and
/// BlocBuilder to automatically update the notification badge count based on
/// the HomeBloc state when available, ensuring all notification icons in the
/// app display the same count. When HomeBloc is not available in the context,
/// it displays the notification icon without a badge.
///
/// The widget follows Material Design guidelines for notification badges and
/// supports customizable onPressed callbacks for navigation.
/// {@endtemplate}
class AppNotificationButton extends StatelessWidget {
  /// {@macro app_notification_button}
  const AppNotificationButton({
    this.onPressed,
    this.iconColor,
    super.key,
  });

  /// Called when the notification button is pressed
  final VoidCallback? onPressed;

  /// Color of the notification icon (defaults to black87)
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    // Check if HomeBloc is available in the widget tree
    final homeBloc = Provider.of<HomeBloc?>(context, listen: false);

    if (homeBloc != null) {
      // HomeBloc is available, use BlocBuilder to get notification count
      return BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return _buildNotificationIcon(context, state.notificationCount);
        },
      );
    } else {
      // HomeBloc not available in this context, show notification without badge
      return _buildNotificationIcon(context, 0);
    }
  }

  /// Builds the notification icon with optional badge count
  Widget _buildNotificationIcon(BuildContext context, int notificationCount) {
    return Stack(
      children: [
        IconButton(
          icon: Icon(
            Icons.notifications_outlined,
            color: iconColor ?? Colors.black87,
          ),
          tooltip: 'Notifications',
          onPressed: onPressed ?? () {
            // TODO: Navigate to notifications screen
          },
        ),
        if (notificationCount > 0)
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
              child: Text(
                notificationCount > 99
                    ? '99+'
                    : notificationCount.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}
