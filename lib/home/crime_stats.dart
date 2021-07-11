import 'package:intl/intl.dart';
import 'package:not_here/web/google_api/geocoding/geocoding_query.dart';
import 'package:not_here/web/google_api/geocoding/model/geocode_parts.dart';
import 'package:not_here/web/police_api/crime_query.dart';
import 'package:not_here/web/police_api/model/crime.dart';
import 'package:recase/recase.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class CrimeCategoryView extends StatefulWidget {
  const CrimeCategoryView({
    Key? key,
    required this.crimes,
  }) : super(key: key);

  final List<Crime> crimes;

  @override
  _CrimeCategoryViewState createState() => _CrimeCategoryViewState();
}

class _CrimeCategoryViewState extends State<CrimeCategoryView> {
  Widget _buildIcon(List<List<Crime>> crimes) {
    switch (crimes[0].length.compareTo(crimes[1].length)) {
      case 1:
        return Icon(Icons.arrow_upward);

      case -1:
        return Icon(Icons.arrow_downward);

      default:
        return Icon(Icons.horizontal_rule);
    }
  }

  Widget _buildSuffixWidget() {
    Map<DateTime, List<Crime>> crimesGroupByMonth =
        widget.crimes.groupListsBy((Crime e) => e.month);

    List<List<Crime>> sortedCrimesByMonth = crimesGroupByMonth.values
        .sorted((a, b) => b.first.month.compareTo(a.first.month));

    if (sortedCrimesByMonth.length > 1) {
      int comp = sortedCrimesByMonth[0]
          .length
          .compareTo(sortedCrimesByMonth[1].length);

      switch (comp) {
        case 1:
          return Row(
            children: [
              Icon(Icons.arrow_upward, color: Colors.redAccent),
              Text(
                "${sortedCrimesByMonth.first.length}",
                style: TextStyle(color: Colors.redAccent),
              ),
            ],
          );

        case -1:
          return Row(
            children: [
              Icon(Icons.arrow_downward, color: Colors.greenAccent),
              Text(
                "${sortedCrimesByMonth.first.length}",
                style: TextStyle(color: Colors.greenAccent),
              ),
            ],
          );
      }
    }

    return Row(
      children: [
        Icon(
          Icons.horizontal_rule,
        ),
        Text("${sortedCrimesByMonth.first.length}"),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      height: 90,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).colorScheme.onBackground,
        boxShadow: [
          BoxShadow(
            offset: Offset(0.0, 5.0),
            color: Theme.of(context).shadowColor,
            blurRadius: 5.0,
            spreadRadius: 1.0,
          ),
        ],
      ),
      child: Row(
        children: [
          Flexible(
            flex: 4,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 6),
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Column(
                children: [
                  Flexible(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        ReCase(widget.crimes.first.category).titleCase,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "${widget.crimes.last.location.street.name} "
                        "in ${DateFormat('MM-yyyy').format(widget.crimes.last.month)}",
                        style: TextStyle(
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Center(
              child: _buildSuffixWidget(),
            ),
          ),
        ],
      ),
    );
  }
}

class CrimeListView extends StatefulWidget {
  const CrimeListView({
    Key? key,
    required this.crimes,
  }) : super(key: key);

  /// A List where each key is crime category and the value is a list of crimes
  /// in that category, sorted in descending order of time.
  final Map<String, List<Crime>> crimes;

  @override
  _CrimeListViewState createState() => _CrimeListViewState();
}

class _CrimeListViewState extends State<CrimeListView> {
  Widget _buildCrimeList() {
    List<List<Crime>> crimesList = widget.crimes.values.toList();
    crimesList
      ..sort((xs, ys) => ys.length.compareTo(xs.length))
      ..forEach((elem) => elem.sortBy((e) => e.month));

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
      itemCount: crimesList.length,
      itemBuilder: (BuildContext ctx, int index) =>
          CrimeCategoryView(crimes: crimesList[index]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _buildCrimeList(),
    );
  }
}
