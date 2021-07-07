import 'dart:convert';
import 'dart:developer' as developer;

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:not_here/home/police_api/model/crime.dart';

Future<List<Crime>> fetchCrimeAtLocation(
    DateTime datetime, double lat, double lng) async {
  final queryParams = {
    'lat': lat.toString(),
    'lng': lng.toString(),
    'month': DateFormat('yyyy-MM').format(datetime),
  };
  Uri url = Uri.https(
      'data.police.uk', '/api/crimes-street/crimes-at-location', queryParams);

  final response = await http.get(url);
  if (response.statusCode == 200) {
    Iterable list = jsonDecode(response.body);
    return List<Crime>.from(list.map((e) => Crime.fromJson(e))).toList();
  } else {
    developer.log(
        "Fetch failure, status code: ${response.statusCode}, body: ${response.body}",
        level: 4);
    throw Exception('Failure to fetch data');
  }
}
