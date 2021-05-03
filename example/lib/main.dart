import 'package:eanalytics/eanalytics.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: Home('EAnalytics Integration')));
}

class Home extends StatefulWidget {
  Home(this.title) : super();
  final String title;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    Eulerian.init('lostsolution.io', requestTrackingAuthorization: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eularian Analytics Flutter'),
      ),
      body: Center(
        child: Text(
          '🧠',
          style: TextStyle(fontSize: 100.0),
        ),
      ),
    );
  }
}
