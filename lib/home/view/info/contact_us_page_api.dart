import 'package:flutter/material.dart';

/// {@template contact_us_page}
/// A page that displays contact us information from the API.
///
/// This page shows contact information including phone number, email address,
/// and physical address with appropriate icons and interactive functionality.
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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // Header text
            Center(
              child: Text(
                'Get in Touch',
                style: Theme.of(
                  context,
                ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 8),

            Center(
              child: Text(
                "We'd love to hear from you. Contact us using the information below.",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
              ),
            ),

            const SizedBox(height: 40),

            // Phone number row
            _buildContactRow(
              icon: Icons.phone,
              title: 'Phone',
              subtitle: '+91 98765 43210',
              onTap: () {
                // TODO: Implement phone call functionality
              },
            ),

            const SizedBox(height: 24),

            // Email row
            _buildContactRow(
              icon: Icons.email,
              title: 'Email',
              subtitle: 'support@powergodha.com',
              onTap: () {
                // TODO: Implement email functionality
              },
            ),

            const SizedBox(height: 24),

            // Address row
            _buildContactRow(
              icon: Icons.location_on,
              title: 'Address',
              subtitle: '123 Dairy Farm Street\nMilk City, Dairy State 12345\nIndia',
              onTap: () {
                // TODO: Implement map functionality
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a contact information row with icon, title, and subtitle
  Widget _buildContactRow({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Icon container
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: Colors.green, size: 24),
            ),

            const SizedBox(width: 16),

            // Title and subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(
                    subtitle, style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                ],
              ),
            ),

            // Arrow icon
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }


  /// Route method for navigation
  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const ContactUsPage());
  }
}
