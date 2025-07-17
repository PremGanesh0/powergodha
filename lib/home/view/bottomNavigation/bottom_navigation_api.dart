import 'package:flutter/material.dart';
import 'package:powergodha/home/widgets/build_card.dart';

import '../../../shared/api/api_models.dart';
import '../../../shared/services/bottom_navigation_service.dart';

class BottomNavigationPage extends StatefulWidget{
  final int page;

  const BottomNavigationPage({required this.page ,super.key});

  @override
  State<BottomNavigationPage> createState() => _BottomNavigationPageState();

  static Route<void> route(int page){
    return MaterialPageRoute
      (builder: (_) => BottomNavigationPage(page: page)
    );
  }
}

class _BottomNavigationPageState extends State<BottomNavigationPage> {
  bool showMore = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cards'),
      ),
      //API call
      body: FutureBuilder<List<ProfitableDairyFarmingData>>(
          future: BottomNavigationService().getDataBottomNavigation(widget.page),
          builder: (context, snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              return const Center(child: CircularProgressIndicator());
            }

            if(snapshot.hasError){
              return Text(snapshot.error.toString());
            }

            if(snapshot.hasData && snapshot.data != null){
              return _buildScreen(snapshot.data!);
            }

            return const Center(child: Text('No content available'));
          }
      ),
    );
  }

  Widget _buildScreen(List<ProfitableDairyFarmingData> items){
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: Colors.green[100],
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20)
              )
          ),
          child: Text(
            'Profitable Dairy Farming',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.green[700],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: ListView.separated(
              itemCount: items.length,
              itemBuilder: (context, index){
                final item = items[index];
                return BuildCard(
                    item: item,
                );
              },
              separatorBuilder: (context,index) => const SizedBox(height: 20),
          ),
        ),
      ],
    );
  }
}
