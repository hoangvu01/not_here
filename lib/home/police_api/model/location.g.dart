// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Location _$LocationFromJson(Map<String, dynamic> json) {
  $checkKeys(json, requiredKeys: const ['latitude', 'longitude', 'street']);
  return Location(
    json['latitude'] as String,
    json['longitude'] as String,
    Street.fromJson(json['street'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$LocationToJson(Location instance) => <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'street': instance.street,
    };
