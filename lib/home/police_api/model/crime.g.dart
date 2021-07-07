// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'crime.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Crime _$CrimeFromJson(Map<String, dynamic> json) {
  return Crime(
    json['category'] as String,
    json['location_type'] as String,
    Location.fromJson(json['location'] as Map<String, dynamic>),
    _fromJsonYearMonth(json['month'] as String),
  );
}

Map<String, dynamic> _$CrimeToJson(Crime instance) => <String, dynamic>{
      'category': instance.category,
      'location_type': instance.locationType,
      'location': instance.location.toJson(),
      'month': _toJsonYearMonth(instance.month),
    };
