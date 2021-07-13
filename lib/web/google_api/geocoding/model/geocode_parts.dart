import 'package:json_annotation/json_annotation.dart';

part 'geocode_parts.g.dart';

@JsonSerializable()
class GeoCodingLocation {
  GeoCodingLocation(this.lat, this.lng);

  final double lat;
  final double lng;

  factory GeoCodingLocation.fromJson(Map<String, dynamic> json) =>
      _$GeoCodingLocationFromJson(json);
  Map<String, dynamic> toJson() => _$GeoCodingLocationToJson(this);
}

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class GeoCodingGeometry {
  GeoCodingGeometry(this.location, this.locationType);

  final GeoCodingLocation location;
  final String locationType;

  factory GeoCodingGeometry.fromJson(Map<String, dynamic> json) =>
      _$GeoCodingGeometryFromJson(json);
  Map<String, dynamic> toJson() => _$GeoCodingGeometryToJson(this);
}

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class GeoCodingAddress {
  GeoCodingAddress(this.geometry, this.formattedAddress, this.types);

  final String formattedAddress;
  final GeoCodingGeometry geometry;
  final List<String>? types;

  factory GeoCodingAddress.fromJson(Map<String, dynamic> json) =>
      _$GeoCodingAddressFromJson(json);
  Map<String, dynamic> toJson() => _$GeoCodingAddressToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GeoCodingResponse {
  GeoCodingResponse(this.results, this.status);

  final List<GeoCodingAddress> results;
  final String status;

  factory GeoCodingResponse.fromJson(Map<String, dynamic> json) =>
      _$GeoCodingResponseFromJson(json);
  Map<String, dynamic> toJson() => _$GeoCodingResponseToJson(this);
}
