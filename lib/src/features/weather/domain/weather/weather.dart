import 'package:json_annotation/json_annotation.dart';

part 'weather.g.dart';

@JsonSerializable(explicitToJson: true)
class Weather {
  Weather({
    this.weatherDetails,
    this.weatherData = const [],
    this.dt,
  });

  @JsonKey(name: 'main', defaultValue: null)
  final WeatherDetails? weatherDetails;
  @JsonKey(name: 'weather')
  final List<WeatherData> weatherData;
  @JsonKey(name: 'dt', defaultValue: null)
  final int? dt;

  factory Weather.fromJson(Map<String, dynamic> json) => _$WeatherFromJson(json);
  Map<String, dynamic> toJson() => _$WeatherToJson(this);

  DateTime get date => DateTime.fromMillisecondsSinceEpoch((dt ?? 0) * 1000);

  Weather copyWith({
    WeatherDetails? weatherDetails,
    List<WeatherData>? weatherData,
    int? dt,
  }) =>
      Weather(
        weatherDetails: weatherDetails ?? this.weatherDetails,
        weatherData: weatherData ?? this.weatherData,
        dt: dt ?? this.dt,
      );
}

@JsonSerializable()
class WeatherDetails {
  WeatherDetails({
    required this.temp,
    required this.tempMax,
    required this.tempMin,
  });

  @JsonKey(name: 'temp')
  final double temp;
  @JsonKey(name: 'temp_max')
  final double tempMax;
  @JsonKey(name: 'temp_min')
  final double tempMin;

  factory WeatherDetails.fromJson(Map<String, dynamic> json) => _$WeatherDetailsFromJson(json);
  Map<String, dynamic> toJson() => _$WeatherDetailsToJson(this);

  WeatherDetails copyWith({
    double? temp,
    double? tempMax,
    double? tempMin,
  }) =>
      WeatherDetails(
        temp: temp ?? this.temp,
        tempMax: tempMax ?? this.tempMax,
        tempMin: tempMin ?? this.tempMin,
      );
}

@JsonSerializable()
class WeatherData {
  WeatherData({
    required this.main,
    required this.description,
    required this.icon,
  });

  @JsonKey(name: 'main')
  final String main;
  @JsonKey(name: 'description')
  final String description;
  @JsonKey(name: 'icon')
  final String icon;

  factory WeatherData.fromJson(Map<String, dynamic> json) => _$WeatherDataFromJson(json);
  Map<String, dynamic> toJson() => _$WeatherDataToJson(this);

  String get iconUrl => 'http://openweathermap.org/img/w/$icon.png';

  WeatherData copyWith({
    String? main,
    String? description,
    String? icon,
  }) =>
      WeatherData(
        main: main ?? this.main,
        description: description ?? this.description,
        icon: icon ?? this.icon,
      );
}
