import 'package:flutter/material.dart';
import 'package:powergodha/home/view/premium/on_tap_buy_premium.dart';

import '../../../app/app_routes.dart';

class PremiumScreen extends StatelessWidget {
  const PremiumScreen({super.key});

  static Route<void> route() {
    return MaterialPageRoute(builder: (_) => const PremiumScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Premium Options')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            _buildCard(
              onTap: (){
                Navigator.of(context).pushNamed(AppRoutes.buyPremium);
              },
              title: 'Powergotha Premium ORB',
              color: Colors.green,
              bulletColor: Colors.green,
              points: const [
                'Access all reports - all the time, without any restrictions.',
                'Pdf reports - Download by email',
                'Notifications integrated with your daily records to keep your Dairy farm on track',
                'SMS notifications',
                'Special offer/discounts integrated with other Powergotha products',
                'Guaranteed Access to all future premium updates.',
              ],
              footer:
                  'With Powergotha Online Record Book Premium, your Farm is on sure path to progress and profit.',
              buttonText: 'Buy Premium now',
            ),
            const SizedBox(height: 20),
            _buildCard(
              onTap: (){
                Navigator.of(context).pushNamed(AppRoutes.dailyRecords);
              },
              title: 'Powergotha Aadhar ORB',
              header:
                  "Not ready to board the ship yet, We've got you covered. You get your Dairy farm going even with our Aadhaar version of ORB.",
              color: Colors.blueAccent,
              bulletColor: Colors.blue,
              points: const [
                'No payment needed ever.',
                'Free forever, Access to all daily reports and all daily record questions.',
                'Reports can be viewed for past 7 days',
                'Discount on Aadhaar milking machine',
                'Special offers/discounts to app users',
                'All articles, knowledge, how-to about dairy goat and poultry.',
              ],
              footer: 'Make most of our versatile app, write records now.',
              buttonText: 'Write Records',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required Color color,
    required Color bulletColor,
    required List<String> points,
    required String footer,
    required String buttonText,
    required VoidCallback onTap,
    String? header,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Center(
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                if (header != null && header.isNotEmpty) ...[
                  Center(
                    child: Text(
                      header,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                Center(
                  child: Text(
                    'What you get?',
                    style: TextStyle(
                      fontSize: 18,
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ...points.map(
                  (point) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildPoint(text: point, color: bulletColor),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  footer,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: onTap,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: color,
                  ),
                  child: Text(
                    buttonText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPoint({required String text, required Color color}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 10,
          height: 10,
          margin: const EdgeInsets.only(top: 6),
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        const SizedBox(width: 10),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 15))),
      ],
    );
  }
}
