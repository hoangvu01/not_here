import 'dart:math';

import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:not_here/web/police_api/model/crime.dart';

class CrimeSummaryChart extends StatefulWidget {
  const CrimeSummaryChart({Key? key, required this.crimes}) : super(key: key);

  final Map<String, List<Crime>> crimes;

  @override
  _CrimeSummaryChartState createState() => _CrimeSummaryChartState();
}

class CrimeSegment {
  final String category;
  final int count;

  CrimeSegment(this.category, this.count);
}

class _CrimeSummaryChartState extends State<CrimeSummaryChart> {
  final List<charts.Series<CrimeSegment, String>> seriesList = [];

  @override
  void initState() {
    super.initState();

    _initSeries();
  }

  void _initSeries({int maxSegmentCount: 5}) {
    List<CrimeSegment> series = [];
    widget.crimes.forEach((k, v) => series.add(CrimeSegment(k, v.length)));

    if (series.length > maxSegmentCount) {
      series.sort((x, y) => y.count - x.count);

      List<CrimeSegment> seriesToAggregate =
          series.sublist(maxSegmentCount - 1, series.length);

      CrimeSegment aggregate = seriesToAggregate
          .reduce((a, b) => CrimeSegment("other", a.count + b.count));

      series.removeRange(maxSegmentCount - 1, series.length);
      series.add(aggregate);
    }

    int totalCount = series.fold(0, (x, c) => x + c.count);

    seriesList.add(charts.Series<CrimeSegment, String>(
      id: 'Crimes Summary',
      domainFn: (CrimeSegment cs, _) => cs.category,
      measureFn: (CrimeSegment cs, _) => cs.count,
      colorFn: (CrimeSegment cs, _) => charts.ColorUtil.fromDartColor(
          Theme.of(context)
              .colorScheme
              .primary
              .withOpacity(cs.count / totalCount)),
      labelAccessorFn: (CrimeSegment cs, _) => cs.category,
      data: series,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return charts.PieChart<String>(
      seriesList,
      animate: true,
      defaultRenderer: charts.ArcRendererConfig(
        arcWidth: 20,
        startAngle: 4 / 5 * pi,
        arcLength: 7 / 5 * pi,
        arcRendererDecorators: [
          charts.ArcLabelDecorator(),
        ],
      ),
    );
  }
}
