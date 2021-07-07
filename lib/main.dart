import 'package:flutter/material.dart';
import 'package:not_here/home/dashboard.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Not Here!',
      theme: ThemeData(
        fontFamily: 'Montserrat',
        scaffoldBackgroundColor: Colors.lightBlue.shade50,
      ),
      home: Scaffold(
        body: SafeArea(child: Dashboard()),
      ),
    );
  }
}
