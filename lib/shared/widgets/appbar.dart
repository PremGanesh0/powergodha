import 'package:flutter/material.dart';
import 'package:powergodha/shared/widgets/app_notification_button.dart';

AppBar PowerGodhaAppBar({
  String? title,
  List<Widget>? extraActions, // renamed to avoid confusion
  double elevation = 0,
}) {
  return AppBar(
    title: Text(title ?? 'PowerGodha'),
    elevation: elevation,
    actions: [
      // default action: search
      IconButton(
        icon: const Icon(Icons.search),
        tooltip: 'Search',
        onPressed: () {
          // Search logic here
        },
      ),
      // default action: notification
      AppNotificationButton(
        onPressed: () {
          // Notification logic
        },
      ),
      // custom actions added at the end (if any)
      if (extraActions != null) ...extraActions,
    ],
  );
}
