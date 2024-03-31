// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Weather _$WeatherFromJson(Map<String, dynamic> json) => Weather(
      weatherDetails: json['main'] == null
          ? null
          : WeatherDetails.fromJson(json['main'] as Map<String, dynamic>),
      weatherData: (json['weather'] as List<dynamic>?)
              ?.map((e) => WeatherData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      dt: json['dt'] as int?,
    );

Map<String, dynamic> _$WeatherToJson(Weather instance) => <String, dynamic>{
      'main': instance.weatherDetails?.toJson(),
      'weather': instance.weatherData.map((e) => e.toJson()).toList(),
      'dt': instance.dt,
    };

WeatherDetails _$WeatherDetailsFromJson(Map<String, dynamic> json) =>
    WeatherDetails(
      temp: (json['temp'] as num).toDouble(),
      tempMax: (json['temp_max'] as num).toDouble(),
      tempMin: (json['temp_min'] as num).toDouble(),
    );

Map<String, dynamic> _$WeatherDetailsToJson(WeatherDetails instance) =>
    <String, dynamic>{
      'temp': instance.temp,
      'temp_max': instance.tempMax,
      'temp_min': instance.tempMin,
    };

WeatherData _$WeatherDataFromJson(Map<String, dynamic> json) => WeatherData(
      main: json['main'] as String,
      description: json['description'] as String,
      icon: json['icon'] as String,
    );

Map<String, dynamic> _$WeatherDataToJson(WeatherData instance) =>
    <String, dynamic>{
      'main': instance.main,
      'description': instance.description,
      'icon': instance.icon,
    };
