import 'package:json_annotation/json_annotation.dart';

part 'street.g.dart';

@JsonSerializable()
class Street {
  Street(this.id, this.name);

  @JsonKey(required: true)
  final int id;

  @JsonKey(required: true)
  final String name;

  factory Street.fromJson(Map<String, dynamic> json) => _$StreetFromJson(json);
  Map<String, dynamic> toJson() => _$StreetToJson(this);
}
