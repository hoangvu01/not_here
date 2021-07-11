import 'dart:convert';
import 'dart:developer' as developer;

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:not_here/web/police_api/model/crime.dart';

Future<List<Crime>> fetchCrimeAtLocation(double lat, double lng,
    {int monthsCount = 6}) async {
  List<Crime> crimes = [];
  DateTime now = DateTime.now();
  var queryParams = {
    'lat': lat.toString(),
    'lng': lng.toString(),
  };

  for (int i = 0; i < 6; i++) {
    DateTime dateTime = DateTime(now.year, now.month - i);
    queryParams['date'] = DateFormat('yyyy-MM').format(dateTime);

    Uri url = Uri.https(
      'data.police.uk',
      '/api/crimes-street/crimes-at-location',
      queryParams,
    );

    developer.log("Queyring ${url.host} ${url.path}"
        " with query parameters ${url.queryParameters}");
    final response = await http.get(url);

    switch (response.statusCode) {
      case 200:
        Iterable list = jsonDecode(response.body);
        list.forEach((e) => crimes.add(Crime.fromJson(e)));
        break;

      case 404:
        break;

      default:
        developer.log(
          "Fetch failure for URL ${url.toString()}, "
          "status code: ${response.statusCode}, "
          "body: ${response.body}",
          level: 4,
        );
    }
  }
  return crimes;
}
