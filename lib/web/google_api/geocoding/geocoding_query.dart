import 'dart:convert';
import 'dart:developer' as developer;

import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'package:not_here/web/google_api/geocoding/model/geocode_parts.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GoogleMapQueryService {
  final uuid = Uuid();
  late final String v4Uuid;

  GoogleMapQueryService() {
    v4Uuid = uuid.v4();
  }

  Future<List<GeoCodingAddress>> forwardGeocode(String address) async {
    final Map<String, String> queryParams = {
      'address': address,
      'components': 'country:GB',
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

  Future<List<GeoCodingAddress>> reverseGeocode(double lat, double lng) async {
    final Map<String, String> queryParams = {
      'latlng': '${lat.toString()},${lng.toString()}',
      'key': dotenv.env['GEOCODING_API_KEY']!,
    };

    print('${lat.toString()},${lng.toString()}');
    Uri url =
        Uri.https('maps.googleapis.com', '/maps/api/geocode/json', queryParams);
    developer.log("Queyring ${url.host} ${url.path}"
        " with query parameters ${url.queryParameters}");
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
}
