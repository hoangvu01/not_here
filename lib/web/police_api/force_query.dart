import 'dart:convert';
import 'dart:developer' as developer;

import 'package:http/http.dart' as http;
import 'package:not_here/web/police_api/model/neighbourhood.dart';

Future<LocateNeighbourhood> fetchLocationAuthority(
  double lat,
  double lng,
) async {
  final queryParams = {
    'q': '51.5161528999,0.0215639',
  };

  Uri url = Uri.https(
    'data.police.uk',
    '/api/locate-neighbourhood',
    queryParams,
  );

  developer.log("Queyring ${url.host} ${url.path}"
      " with query parameters ${url.queryParameters}");
  final response = await http.get(url);

  switch (response.statusCode) {
    case 200:
      final json = jsonDecode(response.body);
      return LocateNeighbourhood.fromJson(json);

    case 404:
      // Throw specific exception here
      break;

    default:
      developer.log(
        "Fetch failure for URL ${url.toString()}, "
        "status code: ${response.statusCode}, "
        "body: ${response.body}",
        level: 4,
      );
  }
  throw Exception('Failed to fetch data');
}

Future<NeighbourhoodForceData> fetchForceData(String force) async {
  Uri url = Uri.https('data.police.uk', '/api/forces/$force');

  developer.log("Queyring ${url.host} ${url.path}"
      " with query parameters ${url.queryParameters}");
  final response = await http.get(url);

  switch (response.statusCode) {
    case 200:
      final json = jsonDecode(response.body);
      return NeighbourhoodForceData.fromJson(json);

    case 404:
      // Throw specific exception here
      break;

    default:
      developer.log(
        "Fetch failure for URL ${url.toString()}, "
        "status code: ${response.statusCode}, "
        "body: ${response.body}",
        level: 4,
      );
  }
  throw Exception('Failed to fetch data');
}
