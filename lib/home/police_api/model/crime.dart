import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:not_here/home/police_api/model/location.dart';

part 'crime.g.dart';

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class Crime {
  Crime(this.category, this.locationType, this.location, this.month);

  final String category;

  final String locationType;

  final Location location;

  @JsonKey(fromJson: _fromJsonYearMonth, toJson: _toJsonYearMonth)
  final DateTime month;

  factory Crime.fromJson(Map<String, dynamic> json) => _$CrimeFromJson(json);
  Map<String, dynamic> toJson() => _$CrimeToJson(this);
}

DateTime _fromJsonYearMonth(String dt) => DateFormat('yyyy-MM').parse(dt);
String _toJsonYearMonth(DateTime dt) => DateFormat('yyyy-MM').format(dt);
