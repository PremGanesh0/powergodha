import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:powergodha/shared/theme.dart';

/// {@template contact_us_page}
/// A page that displays contact information for PowerGodha.
///
/// This page shows various ways to contact the organization, including:
/// * Phone number
/// * Email address
/// * WhatsApp contact
///
/// Each contact method is presented as a card with an icon, title, and
/// content. Users can tap on each contact method to initiate the appropriate
/// action (call, email, WhatsApp).
///
/// The page follows Material Design guidelines and uses responsive layout
/// through ScreenUtil for consistency across different device sizes.
/// {@endtemplate}
class ContactUsPage extends StatelessWidget {
  /// {@macro contact_us_page}
  const ContactUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Us'),
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
              _buildContactCard(
                context,
                'Customer Support',
                'Our support team is available Monday through Saturday, 9 AM to 6 PM.',
                [
                  _ContactItem(
                    icon: Icons.phone,
                    title: 'Call Us',
                    content: '+91 98765 43210',
                    onTap: () {
                      // Launch phone dialer
                      _showSnackBar(context, 'Launching phone dialer...');
                    },
                    trailingIcon: Icons.call_made,
                  ),
                  _ContactItem(
                    icon: Icons.email,
                    title: 'Email Us',
                    content: 'support@powergodha.com',
                    onTap: () {
                      // Launch email client
                      _showSnackBar(context, 'Opening email client...');
                    },
                    trailingIcon: Icons.open_in_new,
                  ),
                  _ContactItem(
                    icon: Icons.chat,
                    title: 'WhatsApp',
                    content: '+91 98765 43210',
                    onTap: () {
                      // Launch WhatsApp
                      _showSnackBar(context, 'Opening WhatsApp...');
                    },
                    trailingIcon: Icons.open_in_new,
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              _buildContactCard(
                context,
                'Business Inquiries',
                'For partnerships, media inquiries, or business opportunities:',
                [
                  _ContactItem(
                    icon: Icons.email,
                    title: 'Email',
                    content: 'business@powergodha.com',
                    onTap: () {
                      // Launch email client
                      _showSnackBar(context, 'Opening email client...');
                    },
                    trailingIcon: Icons.open_in_new,
                  ),
                  _ContactItem(
                    icon: Icons.phone,
                    title: 'Call',
                    content: '+91 98765 43211',
                    onTap: () {
                      // Launch phone dialer
                      _showSnackBar(context, 'Launching phone dialer...');
                    },
                    trailingIcon: Icons.call_made,
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              _buildAddressSection(context),
              SizedBox(height: 24.h),
              _buildFeedbackSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Contact Us',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        SizedBox(height: 8.h),
        Text(
          'We\'re here to help. Reach out to us through any of the channels below, and our team will assist you as soon as possible.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      ],
    );
  }

  Widget _buildContactCard(
    BuildContext context,
    String title,
    String description,
    List<_ContactItem> contactItems,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTypography.radiusMedium.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            SizedBox(height: 8.h),
            Text(
              description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 16.h),
            ...contactItems.map((item) => _buildContactItemTile(context, item)),
          ],
        ),
      ),
    );
  }

  Widget _buildContactItemTile(BuildContext context, _ContactItem item) {
    return InkWell(
      onTap: item.onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                item.icon,
                size: 24.r,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.content,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: item.content));
                          _showSnackBar(context, '${item.content} copied to clipboard');
                        },
                        child: Icon(
                          Icons.copy,
                          size: 16.r,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(
              item.trailingIcon,
              size: 16.r,
              color: Theme.of(context).colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressSection(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTypography.radiusMedium.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Visit Us',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            SizedBox(height: 16.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    Icons.location_on,
                    size: 24.r,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'PowerGodha Headquarters',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        '123 Agritech Park, Sector 15\nTech Hub, Pune 411057\nMaharashtra, India',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      SizedBox(height: 8.h),
                      OutlinedButton.icon(
                        icon: const Icon(Icons.map),
                        label: const Text('View Map'),
                        onPressed: () {
                          // Open map
                          _showSnackBar(context, 'Opening map...');
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Theme.of(context).colorScheme.primary,
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 8.h,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedbackSection(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            'Have suggestions or feedback?',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
          SizedBox(height: 8.h),
          ElevatedButton.icon(
            icon: const Icon(Icons.feedback),
            label: const Text('Send Feedback'),
            onPressed: () {
              // Open feedback form
              _showSnackBar(context, 'Opening feedback form...');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              padding: EdgeInsets.symmetric(
                horizontal: 24.w,
                vertical: 12.h,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  /// Creates a [MaterialPageRoute] for navigating to the [ContactUsPage].
  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const ContactUsPage());
  }
}

/// A data class representing a contact item with an icon, title, content, and action.
class _ContactItem {
  final IconData icon;
  final String title;
  final String content;
  final VoidCallback onTap;
  final IconData trailingIcon;

  _ContactItem({
    required this.icon,
    required this.title,
    required this.content,
    required this.onTap,
    required this.trailingIcon,
  });
}
