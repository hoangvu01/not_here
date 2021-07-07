import 'package:flutter/material.dart';

class SearchBox extends StatefulWidget {
  @override
  _SearchBoxState createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
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
      child: Container(
        padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
        child: TextField(
          decoration: InputDecoration(
              icon: Icon(Icons.search),
              border: UnderlineInputBorder(),
              hintText: 'Town, city or postcode'),
        ),
      ),
    );
  }
}
