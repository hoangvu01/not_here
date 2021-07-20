import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:not_here/web/police_api/model/crime.dart';
import 'package:recase/recase.dart';

class CrimeListCard extends StatefulWidget {
  const CrimeListCard({
    Key? key,
    required this.crimes,
  }) : super(key: key);

  final List<Crime> crimes;

  @override
  _CrimeListCardState createState() => _CrimeListCardState();
}

class _CrimeListCardState extends State<CrimeListCard> {
  Widget _buildSuffixWidget() {
    Map<DateTime, List<Crime>> crimesGroupByMonth =
        groupBy(widget.crimes, (Crime e) => e.month);

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
                        style: Theme.of(context).textTheme.headline3,
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
                        style: Theme.of(context).textTheme.bodyText2,
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
