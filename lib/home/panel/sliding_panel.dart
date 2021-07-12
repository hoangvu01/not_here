import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:not_here/home/panel/neighbourhood_details.dart';
import 'package:not_here/home/panel/scroll_list/scroll_summary.dart';
import 'package:not_here/web/google_api/geocoding/geocoding_query.dart';
import 'package:not_here/web/google_api/geocoding/model/geocode_parts.dart';
import 'package:not_here/web/police_api/crime_query.dart';
import 'package:not_here/web/police_api/force_query.dart';
import 'package:not_here/web/police_api/model/crime.dart';
import 'package:not_here/web/police_api/model/neighbourhood.dart';

class CrimePanelData {
  final String address;

  CrimePanelData(this.address);
}

class CrimePanel extends StatefulWidget {
  final CrimePanelData data;

  const CrimePanel({required Key key, required this.data}) : super(key: key);

  @override
  _CrimePanelState createState() => _CrimePanelState();
}

class _CrimePanelState extends State<CrimePanel> {
  /// The future contains address and coordinates of the locations that match
  /// the text in the search bar
  late final Future<List<GeoCodingAddress>> _geoAddresses;

  /// The future contains details about the neighbourhood from the address
  /// in the search box
  late final Future<NeighbourhoodForceData> _force;

  /// The snapshot contains a list of list of crimes grouped by
  /// crime categories as the key
  late final Future<Map<String, List<Crime>>> _crimes;

  @override
  void initState() {
    super.initState();
    _initInternalData();
  }

  void _initInternalData() async {
    print("Initialising...");
    _geoAddresses = _initGeoAddresses();
    _force = _initForce();
    _crimes = _initCrimeFutures();
  }

  Future<List<GeoCodingAddress>> _initGeoAddresses() async {
    return fetchCoordinates(widget.data.address);
  }

  Future<NeighbourhoodForceData> _initForce() async {
    List<GeoCodingAddress> matches = await _geoAddresses;
    GeoCodingAddress topMatch = matches.first;
    GeoCodingLocation topMatchLocation = topMatch.geometry.location;
    LocateNeighbourhood neighbourhood = await fetchLocationAuthority(
      topMatchLocation.lat,
      topMatchLocation.lng,
    );

    return fetchForceData(neighbourhood.force);
  }

  Future<Map<String, List<Crime>>> _initCrimeFutures() async {
    if (widget.data.address.isEmpty) {
      return Map();
    }
    List<GeoCodingAddress> matches = await _geoAddresses;
    GeoCodingLocation location = matches.first.geometry.location;
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
          child: FutureBuilder(
            future: _force,
            builder: (ctx, snapshot) {
              if (snapshot.hasData) {
                return NeighbourhoodContacts(
                    snapshot.data as NeighbourhoodForceData);
              }

              return Center(child: CircularProgressIndicator());
            },
          ),
        ),
        Expanded(
          flex: 5,
          child: FutureBuilder(
            future: _crimes,
            builder: (ctx, snapshot) {
              if (snapshot.hasData) {
                return Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  child: ScrollListWrapper(
                    crimes: snapshot.data as Map<String, List<Crime>>,
                  ),
                );
              }

              return Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ]),
    );
  }
}
