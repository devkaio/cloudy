// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'city.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

City _$CityFromJson(Map<String, dynamic> json) => City(
      name: json['name'] as String,
      coordinates: Coordinates.fromJson(json['coord'] as Map<String, dynamic>),
      currentWeather: json['current'] == null
          ? null
          : Weather.fromJson(json['current'] as Map<String, dynamic>),
      forecastWeather: (json['forecast'] as List<dynamic>?)
          ?.map((e) => Weather.fromJson(e as Map<String, dynamic>))
          .toList(),
      country: _$JsonConverterFromJson<Map<String, dynamic>, String>(
          json['sys'], const _CountryNestedMapper().fromJson),
    );

Map<String, dynamic> _$CityToJson(City instance) => <String, dynamic>{
      'name': instance.name,
      'coord': instance.coordinates.toJson(),
      'current': instance.currentWeather?.toJson(),
      'forecast': instance.forecastWeather?.map((e) => e.toJson()).toList(),
      'sys': _$JsonConverterToJson<Map<String, dynamic>, String>(
          instance.country, const _CountryNestedMapper().toJson),
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);
