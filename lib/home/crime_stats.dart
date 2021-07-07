import 'package:flutter/material.dart';
import 'package:not_here/home/police_api/crime_data.dart';
import 'package:not_here/home/police_api/model/crime.dart';

class CrimeStats extends StatefulWidget {
  @override
  _CrimeStatsState createState() => _CrimeStatsState();
}

class _CrimeStatsState extends State<CrimeStats> {
  late Future<List<Crime>> data;

  @override
  void initState() {
    super.initState();
    data = fetchCrimeAtLocation(DateTime.now(), 51.5074, 0.1278);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: FutureBuilder(
        future: data,
        builder: (ctx, snapshot) {
          if (snapshot.hasData) {
            return Text('Done!');
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }

          // By default, show a loading spinner.
          return CircularProgressIndicator();
        },
      ),
    );
  }
}
