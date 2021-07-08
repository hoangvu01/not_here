import 'dart:developer' as developer;

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
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: Offset(0.0, 5.0),
            color: Colors.blueGrey.shade100,
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
            flex: 2,
            child: Container(
              width: 50,
              height: 50,
              margin: const EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(
                color: Colors.blue.shade100.withOpacity(0.5),
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue.shade100.withOpacity(0.5),
              ),
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
    required this.address,
  }) : super(key: key);

  final String address;

  @override
  _CrimeListViewState createState() => _CrimeListViewState();
}

class _CrimeListViewState extends State<CrimeListView> {
  Future<List<Crime>> _getCrimeFutures() async {
    if (widget.address.isNotEmpty) {
      List<GeoCodingAddress> addressFuture =
          await fetchCoordinates(widget.address);
      GeoCodingLocation location = addressFuture.first.geometry.location;
      return fetchCrimeAtLocation(location.lat, location.lng);
    }
    return Future.value([]);
  }

  Widget _buildCrimeList(List<Crime> crimes) {
    Map<String, List<Crime>> groupByCategory =
        groupBy(crimes, (Crime crime) => crime.category);

    List<List<Crime>> sortedCrimeByOccurences = groupByCategory.values.toList();
    sortedCrimeByOccurences.sort((xs, ys) => ys.length.compareTo(xs.length));
    sortedCrimeByOccurences.forEach((elem) => elem.sortBy((e) => e.month));

    return ListView.builder(
      padding: const EdgeInsets.all(5),
      itemCount: sortedCrimeByOccurences.length,
      itemBuilder: (BuildContext ctx, int index) {
        List<Crime> categorisedCrimes = sortedCrimeByOccurences[index];

        return CrimeCategoryView(crimes: categorisedCrimes);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30.0),
      child: FutureBuilder(
        future: _getCrimeFutures(),
        builder: (ctx, snapshot) {
          if (snapshot.hasData) {
            return _buildCrimeList(snapshot.data as List<Crime>);
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }

          // By default, show a loading spinner.
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
