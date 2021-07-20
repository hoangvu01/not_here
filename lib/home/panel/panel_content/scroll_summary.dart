import 'package:flutter/material.dart';
import 'package:not_here/home/panel/panel_content/crime_list.dart';
import 'package:not_here/home/panel/panel_content/summary_chart.dart';
import 'package:not_here/web/police_api/model/crime.dart';

class ScrollListWrapper extends StatelessWidget {
  const ScrollListWrapper({
    Key? key,
    required this.crimes,
  }) : super(key: key);

  final Map<String, List<Crime>> crimes;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(
            indicatorColor: Theme.of(context).colorScheme.primaryVariant,
            tabs: [
              Tab(
                icon: Icon(
                  Icons.list,
                  color: Theme.of(context).iconTheme.color,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.category,
                  color: Theme.of(context).iconTheme.color,
                ),
              ),
            ],
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: TabBarView(
                children: [
                  CrimeList(crimes: crimes),
                  CrimeSummaryChart(crimes: crimes),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
