import 'package:json_annotation/json_annotation.dart';
import 'package:not_here/home/police_api/model/street.dart';

part 'location.g.dart';

@JsonSerializable()
class Location {
  Location(this.latitude, this.longitude, this.street);

  @JsonKey(required: true)
  final String latitude;

  @JsonKey(required: true)
  final String longitude;

  @JsonKey(required: true)
  final Street street;

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);
  Map<String, dynamic> toJson() => _$LocationToJson(this);
}
