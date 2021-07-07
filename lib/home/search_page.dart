import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:not_here/home/crime_stats.dart';
import 'package:not_here/home/search_box.dart';

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          flex: 3,
          child: Center(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 50, vertical: 10.0),
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
          flex: 2,
          child: SearchBox(),
        ),
        Flexible(
          flex: 8,
          child: CrimeStats(),
        ),
        Flexible(
          flex: 1,
          child: Container(),
        )
      ],
    );
  }
}
