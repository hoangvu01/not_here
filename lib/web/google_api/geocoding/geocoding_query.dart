import 'dart:convert';
import 'dart:developer' as developer;

import 'package:http/http.dart' as http;
import 'package:not_here/web/google_api/geocoding/model/geocode_parts.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<List<GeoCodingAddress>> fetchCoordinates(String address) async {
  final Map<String, String> queryParams = {
    'address': address,
    'key': dotenv.env['GEOCODING_API_KEY']!,
  };

  Uri url =
      Uri.https('maps.googleapis.com', '/maps/api/geocode/json', queryParams);

  final response = await http.get(url);
  if (response.statusCode == 200) {
    final json = jsonDecode(response.body);
    GeoCodingResponse res = GeoCodingResponse.fromJson(json);
    return res.results;
  } else {
    developer.log(
        "Failure to fetch results from Geocoding API,"
        "status code: ${response.statusCode}, body: ${response.body}",
        level: 4);
    throw Exception('Failure to fetch data');
  }
}
