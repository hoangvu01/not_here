import 'package:flutter/material.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  final Map<IconData, String> icons = Map.of({
    Icons.local_police_outlined: "",
    Icons.location_city: "",
    Icons.location_searching: "",
    Icons.warning: "",
  });

  Widget _iconDataToWidget(MapEntry entry) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            offset: Offset(0.0, 15.0),
            color: Colors.blueGrey.shade100,
            blurRadius: 10.0,
            spreadRadius: 3.0,
          ),
        ],
        color: Colors.white,
      ),
      child: Row(
        children: [
          SizedBox(
            height: 50,
            width: 50,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.blueGrey.shade300.withOpacity(0.5),
              ),
              child: Icon(
                entry.key,
                size: 25,
                color: Colors.white,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 5),
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: Text(
              entry.value,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          flex: 2,
          child: Center(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 50),
              child: Text(
                'Are you travelling through a safe neighbourhood?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
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
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: ListView(
              children: icons.entries.map(_iconDataToWidget).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
