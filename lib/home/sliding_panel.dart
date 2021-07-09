import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:not_here/home/crime_stats.dart';

class CrimePanel extends StatefulWidget {
  final String address;

  const CrimePanel({Key? key, required this.address}) : super(key: key);

  @override
  _CrimePanelState createState() => _CrimePanelState();
}

class _CrimePanelState extends State<CrimePanel> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
      decoration: BoxDecoration(
        color: Colors.lightBlue.shade50,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 20,
          ),
        ],
      ),
      child: Column(children: [
        Divider(
          height: 20,
          color: Colors.grey,
          thickness: 2,
          indent: 150,
          endIndent: 150,
        ),
        Flexible(
          flex: 1,
          child: Container(
            margin: const EdgeInsets.all(20),
            child: Text(
              widget.address,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
        ),
        Flexible(
          flex: 2,
          child: Placeholder(),
        ),
        Flexible(
          flex: 3,
          child: CrimeListView(address: widget.address),
        ),
      ]),
    );
  }
}
