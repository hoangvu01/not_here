import 'package:json_annotation/json_annotation.dart';

part 'neighbourhood.g.dart';

@JsonSerializable()
class LocateNeighbourhood {
  LocateNeighbourhood(this.force, this.neighbourhood);

  @JsonKey(required: true)
  final String force;

  @JsonKey(required: true)
  final String neighbourhood;

  factory LocateNeighbourhood.fromJson(Map<String, dynamic> json) =>
      _$LocateNeighbourhoodFromJson(json);
  Map<String, dynamic> toJson() => _$LocateNeighbourhoodToJson(this);
}

@JsonSerializable()
class NeibourhoodForceEngagement {
  NeibourhoodForceEngagement(this.url, this.description, this.title, this.type);

  @JsonKey(required: true)
  final String url;

  @JsonKey(required: true)
  final String? description;

  @JsonKey(required: true)
  final String title;

  @JsonKey(required: true)
  final String? type;

  factory NeibourhoodForceEngagement.fromJson(Map<String, dynamic> json) =>
      _$NeibourhoodForceEngagementFromJson(json);
  Map<String, dynamic> toJson() => _$NeibourhoodForceEngagementToJson(this);
}

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class NeighbourhoodForceData {
  NeighbourhoodForceData(this.description, this.url, this.engagementMethods,
      this.telephone, this.id, this.name);

  @JsonKey(required: true)
  final String? description;

  @JsonKey(required: true)
  final String url;

  @JsonKey(required: true)
  final String telephone;

  @JsonKey(required: true)
  final List<NeibourhoodForceEngagement> engagementMethods;

  @JsonKey(required: true)
  final String id;

  @JsonKey(required: true)
  final String name;

  factory NeighbourhoodForceData.fromJson(Map<String, dynamic> json) =>
      _$NeighbourhoodForceDataFromJson(json);
  Map<String, dynamic> toJson() => _$NeighbourhoodForceDataToJson(this);
}
