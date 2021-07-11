import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:not_here/home/panel/crime_list.dart';
import 'package:not_here/web/google_api/geocoding/geocoding_query.dart';
import 'package:not_here/web/google_api/geocoding/model/geocode_parts.dart';
import 'package:not_here/web/police_api/crime_query.dart';
import 'package:not_here/web/police_api/model/crime.dart';

class CrimePanelData {
  final String address;

  CrimePanelData(this.address);
}

class CrimePanel extends StatefulWidget {
  final CrimePanelData data;

  const CrimePanel({Key? key, required this.data}) : super(key: key);

  @override
  _CrimePanelState createState() => _CrimePanelState();
}

class _CrimePanelState extends State<CrimePanel> {
  /// The snapshot contains a list of list of crimes grouped by
  /// crime categories as the key
  late final Future<Map<String, List<Crime>>> _crimes;

  @override
  void initState() {
    super.initState();
    _crimes = _initCrimeFutures();
  }

  Future<Map<String, List<Crime>>> _initCrimeFutures() async {
    if (widget.data.address.isEmpty) {
      return Map();
    }
    List<GeoCodingAddress> addressFuture =
        await fetchCoordinates(widget.data.address);
    GeoCodingLocation location = addressFuture.first.geometry.location;
    List<Crime> rawCrimes =
        await fetchCrimeAtLocation(location.lat, location.lng);
    Map<String, List<Crime>> groupedCrimes =
        groupBy(rawCrimes, (Crime crime) => crime.category);

    return groupedCrimes;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor,
            blurRadius: 20,
          ),
        ],
      ),
      child: Column(children: [
        Divider(
          height: 20,
          color: Theme.of(context).dividerColor,
          thickness: 2,
          indent: 150,
          endIndent: 150,
        ),
        Flexible(
          flex: 1,
          child: Container(
            margin: const EdgeInsets.all(20),
            child: Text(
              widget.data.address,
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
          child: FutureBuilder(
            future: _crimes,
            builder: (ctx, snapshot) {
              if (snapshot.hasData) {
                return CrimeList(
                    crimes: snapshot.data as Map<String, List<Crime>>);
              }

              return Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ]),
    );
  }
}
