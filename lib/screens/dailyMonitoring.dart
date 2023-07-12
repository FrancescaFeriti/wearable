
import 'package:flutter/material.dart';
import 'package:flow1_prova/screens/homePage.dart';

class DailyMonitoring extends StatefulWidget {
  const DailyMonitoring({Key? key}) : super(key: key);
  static const routename = 'DailyMonitoring';

  @override
  _stateDailyMonitoring createState() => _stateDailyMonitoring();

}

class _stateDailyMonitoring extends State<DailyMonitoring> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Monitoring Page'),
      ),
      floatingActionButton: FloatingActionButton(
         child: const Icon(Icons.home_filled),
        onPressed: () => _backHome(context)
      ),
    );
  }

  void _backHome(BuildContext context) {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const HomePage()));
  }

}