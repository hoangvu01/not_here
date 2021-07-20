import 'package:not_here/home/panel/panel_content/crime_list_card.dart';
import 'package:not_here/web/police_api/model/crime.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class CrimeList extends StatefulWidget {
  const CrimeList({
    Key? key,
    required this.crimes,
  }) : super(key: key);

  /// A List where each key is crime category and the value is a list of crimes
  /// in that category, sorted in descending order of time.
  final Map<String, List<Crime>> crimes;

  @override
  _CrimeListState createState() => _CrimeListState();
}

class _CrimeListState extends State<CrimeList> {
  Widget _buildCrimeList() {
    List<List<Crime>> crimesList = widget.crimes.values.toList();
    crimesList
      ..sort((xs, ys) => ys.length.compareTo(xs.length))
      ..forEach((elem) => elem.sortBy((e) => e.month));

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      itemCount: crimesList.length,
      itemBuilder: (BuildContext ctx, int index) =>
          CrimeListCard(crimes: crimesList[index]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 2, 15, 15),
      child: _buildCrimeList(),
    );
  }
}
