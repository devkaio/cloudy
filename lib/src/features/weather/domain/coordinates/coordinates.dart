import 'package:json_annotation/json_annotation.dart';

part 'coordinates.g.dart';

@JsonSerializable()
class Coordinates {
  const Coordinates({
    required this.lat,
    required this.lon,
  });

  @JsonKey(name: 'lat')
  final double lat;
  @JsonKey(name: 'lon')
  final double lon;

  factory Coordinates.fromJson(Map<String, dynamic> json) => _$CoordinatesFromJson(json);
  Map<String, dynamic> toJson() => _$CoordinatesToJson(this);

  Coordinates copyWith({
    double? lat,
    double? lon,
  }) =>
      Coordinates(
        lat: lat ?? this.lat,
        lon: lon ?? this.lon,
      );
}
