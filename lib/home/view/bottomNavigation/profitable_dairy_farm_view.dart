import 'package:flutter/material.dart';

class ProfitableDiaryFarmView extends StatelessWidget{
  const ProfitableDiaryFarmView({super.key});

  static Route<void> route() {
    return MaterialPageRoute(builder: (_) => const ProfitableDiaryFarmView());
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Hello'
        ),
      ),
    );
  }
}