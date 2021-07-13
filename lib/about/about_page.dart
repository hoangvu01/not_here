import 'package:flutter/material.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          flex: 2,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 50),
          ),
        ),
        Flexible(
          flex: 1,
          child: Container(),
        ),
        Flexible(
          flex: 4,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
          ),
        ),
      ],
    );
  }
}
