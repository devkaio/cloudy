import 'package:json_annotation/json_annotation.dart';

import '../coordinates/coordinates.dart';
import '../weather/weather.dart';

part 'city.g.dart';

@JsonSerializable(explicitToJson: true)
class City {
  City({
    required this.name,
    required this.coordinates,
    this.currentWeather,
    this.forecastWeather,
    this.country,
  });

  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'coord')
  final Coordinates coordinates;
  @JsonKey(name: 'current', defaultValue: null)
  final Weather? currentWeather;
  @JsonKey(name: 'forecast', defaultValue: null)
  final List<Weather>? forecastWeather;
  @_CountryNestedMapper()
  @JsonKey(name: 'sys', defaultValue: null)
  final String? country;

  factory City.fromJson(Map<String, dynamic> json) => _$CityFromJson(json);
  Map<String, dynamic> toJson() => _$CityToJson(this);

  String get flagUrl => 'https://openweathermap.org/images/flags/${country?.toLowerCase() ?? 'br'}.png';

  City copyWith({
    String? name,
    Coordinates? coordinates,
    Weather? currentWeather,
    List<Weather>? forecastWeather,
  }) =>
      City(
        name: name ?? this.name,
        coordinates: coordinates ?? this.coordinates,
        currentWeather: currentWeather ?? this.currentWeather,
        forecastWeather: forecastWeather ?? this.forecastWeather,
      );
}

// https://github.com/google/json_serializable.dart/issues/490#issuecomment-1029511220
class _CountryNestedMapper extends JsonConverter<String, Map<String, dynamic>> {
  const _CountryNestedMapper();

  @override
  String fromJson(Map<String, dynamic> json) => json['country'] as String;

  @override
  Map<String, dynamic> toJson(String object) => {'country': object};
}
