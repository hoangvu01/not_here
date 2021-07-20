import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:not_here/web/police_api/model/crime.dart';

class CrimeSummaryChart extends StatefulWidget {
  const CrimeSummaryChart({Key? key, required this.crimes}) : super(key: key);

  final Map<String, List<Crime>> crimes;

  @override
  _CrimeSummaryChartState createState() => _CrimeSummaryChartState();
}

class CrimeSeriesPoint {
  final DateTime date;
  final int count;

  CrimeSeriesPoint(this.date, this.count);
}

class CrimeSeries {
  final String category;
  final List<CrimeSeriesPoint> points;

  CrimeSeries(this.category, this.points);
}

class _CrimeSummaryChartState extends State<CrimeSummaryChart> {
  final List<charts.Series<CrimeSeriesPoint, DateTime>> seriesList = [];

  @override
  void initState() {
    super.initState();
    _initSeries();
  }

  void _initSeries({int maxSegmentCount = 4}) {
    List<CrimeSeries> series = [];

    List<List<Crime>> sortedCrimes =
        widget.crimes.values.sortedBy<num>((e) => e.length);
    sortedCrimes.removeRange(0, max(sortedCrimes.length - maxSegmentCount, 0));

    sortedCrimes.forEach((ctg) {
      Map<DateTime, List<Crime>> groupByMonths =
          groupBy(ctg, (Crime c) => c.month);

      List<CrimeSeriesPoint> dataPoints = [];
      groupByMonths.forEach((month, crimes) {
        dataPoints.add(CrimeSeriesPoint(month, crimes.length));
      });
      series.add(CrimeSeries(ctg.first.category, dataPoints));
    });

    series.asMap().forEach((i, serie) {
      seriesList.add(
        charts.Series<CrimeSeriesPoint, DateTime>(
            id: serie.category,
            domainFn: (pt, _) => pt.date,
            measureFn: (pt, _) => pt.count,
            colorFn: (_, __) => charts.ColorUtil.fromDartColor(
                  Theme.of(context)
                      .colorScheme
                      .primaryVariant
                      .withOpacity((i + 1) / maxSegmentCount),
                ),
            data: serie.points),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: charts.TimeSeriesChart(
        seriesList,
        defaultRenderer: charts.BarRendererConfig<DateTime>(),
        animate: true,
        domainAxis: charts.DateTimeAxisSpec(
          renderSpec: charts.GridlineRendererSpec(
            labelStyle: charts.TextStyleSpec(
              color: charts.ColorUtil.fromDartColor(
                Theme.of(context).textTheme.bodyText1!.color!,
              ),
            ),
          ),
        ),
        primaryMeasureAxis: charts.NumericAxisSpec(
          renderSpec: charts.GridlineRendererSpec(
            labelStyle: charts.TextStyleSpec(
              color: charts.ColorUtil.fromDartColor(
                Theme.of(context).textTheme.bodyText1!.color!,
              ),
            ),
          ),
        ),
        behaviors: [
          charts.SeriesLegend(
            position: charts.BehaviorPosition.bottom,
            horizontalFirst: true,
            desiredMaxColumns: 2,
            entryTextStyle: charts.TextStyleSpec(
              color: charts.ColorUtil.fromDartColor(
                Theme.of(context).textTheme.bodyText1!.color!,
              ),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
