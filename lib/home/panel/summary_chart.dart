import 'package:flutter/material.dart';
import 'package:not_here/web/police_api/model/crime.dart';

class CrimeSummaryChart extends StatefulWidget {
  const CrimeSummaryChart({Key? key, required this.crimes}) : super(key: key);

  final Map<String, List<Crime>> crimes;

  @override
  _CrimeSummaryChartState createState() => _CrimeSummaryChartState();
}

class _CrimeSummaryChartState extends State<CrimeSummaryChart> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
