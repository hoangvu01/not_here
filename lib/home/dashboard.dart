import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Dashboard extends StatelessWidget {
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
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 30.0),
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 1,
                  child: Icon(
                    Icons.search,
                  ),
                ),
                Flexible(
                  flex: 6,
                  child: TextField(
                    decoration:
                        InputDecoration(hintText: 'Town, city or postcode'),
                  ),
                ),
              ],
            ),
          ),
        ),
        Flexible(
          flex: 4,
          child: Container(),
        ),
      ],
    );
  }
}
