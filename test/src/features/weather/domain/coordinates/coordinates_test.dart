import 'package:cloudy/src/features/weather/domain/coordinates/coordinates.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Coordinates tests', () {
    test('fromJson method should return a valid Coordinate instance with all properties deserialized correctly', () {
      final result = Coordinates.fromJson({
        'lat': -23.5505,
        'lon': -46.6333,
      });

      expect(result, isNotNull);
      expect(result.lat, -23.5505);
      expect(result.lon, -46.6333);
    });

    test('toJson method should return a valid Map<String, dynamic> instance with all properties serialized correctly', () {
      final result = const Coordinates(
        lat: -23.5505,
        lon: -46.6333,
      ).toJson();

      expect(result, isNotNull);
      expect(result['lat'], -23.5505);
      expect(result['lon'], -46.6333);
    });

    test('copyWith should return a valid Coordinate instance with all properties copied correctly ', () {
      final result = const Coordinates(
        lat: -23.5505,
        lon: -46.6333,
      ).copyWith(
        lat: -23.5505,
        lon: -46.6333,
      );

      expect(result, isNotNull);
      expect(result.lat, -23.5505);
      expect(result.lon, -46.6333);
    });

    test('copyWith should return the original values if no property is passed on', () {
      final result = const Coordinates(
        lat: -23.5505,
        lon: -46.6333,
      ).copyWith();

      expect(result, isNotNull);
      expect(result.lat, -23.5505);
      expect(result.lon, -46.6333);
    });
  });
}
