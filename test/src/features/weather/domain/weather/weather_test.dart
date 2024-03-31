import 'package:cloudy/src/features/weather/domain/weather/weather.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Map<String, dynamic> weather;

  group('City.toJson tests', () {
    setUp(() {
      weather = {
        'main': {
          'temp': 27.3,
          'temp_min': 24.2,
          'temp_max': 31.5,
        },
        'weather': [
          {
            'main': 'Cloudy',
            'description': 'cloudy sky',
            'icon': '01d',
          },
        ],
        'dt': 1618945200,
      };
    });

    test(
      'Weather.fromJson should return a valid City instance with all properties deserialized correctly',
      () {
        final result = Weather.fromJson(weather);
        expect(result, isNotNull);
        expect(result.dt, 1618945200);
        expect(result.weatherDetails, isNotNull);
        expect(result.weatherDetails!.temp, 27.3);
        expect(result.weatherDetails!.tempMax, 31.5);
        expect(result.weatherDetails!.tempMin, 24.2);
        expect(result.weatherData, isNotEmpty);
        expect(result.weatherData.first.main, 'Cloudy');
        expect(result.weatherData.first.description, 'cloudy sky');
        expect(result.weatherData.first.icon, '01d');
      },
    );

    test(
      'Weather.toJson should return a valid Map<String, dynamic> instance with all properties serialized correctly',
      () {
        final result = Weather.fromJson(weather).toJson();
        expect(result, isNotNull);
        expect(result['dt'], 1618945200);
        expect(result['main'], isNotNull);
        expect(result['main']['temp'], 27.3);
        expect(result['main']['temp_min'], 24.2);
        expect(result['main']['temp_max'], 31.5);
        expect(result['weather'], isNotEmpty);
        expect(result['weather'].first['main'], 'Cloudy');
        expect(result['weather'].first['description'], 'cloudy sky');
        expect(result['weather'].first['icon'], '01d');
      },
    );

    test(
      'Weather.copyWith should return a valid City instance with all properties copied correctly',
      () {
        final weatherInstance = Weather.fromJson(weather);
        final result = weatherInstance.copyWith(
          dt: 1618125200,
          weatherDetails: WeatherDetails(
            temp: 25.3,
            tempMin: 22.2,
            tempMax: 29.5,
          ),
          weatherData: [
            WeatherData(
              main: 'Sunny',
              description: 'sunny sky',
              icon: '01d',
            ),
          ],
        );

        expect(result, isNotNull);
        expect(result.dt, 1618125200);
        expect(result.weatherDetails, isNotNull);
        expect(result.weatherDetails!.temp, 25.3);
        expect(result.weatherDetails!.tempMax, 29.5);
        expect(result.weatherDetails!.tempMin, 22.2);
        expect(result.weatherData, isNotEmpty);
        expect(result.weatherData.first.main, 'Sunny');
        expect(result.weatherData.first.description, 'sunny sky');
        expect(result.weatherData.first.icon, '01d');
      },
    );

    test('Weater.date should return the timestamp to milliseconds since epoch', () {
      final result = Weather.fromJson(weather);
      expect(result.date, DateTime.fromMillisecondsSinceEpoch(1618945200 * 1000));
    });

    test('WeatherData.iconUrl should return the correct url based on WeatherData.icon', () {
      final result = WeatherData(main: 'Cloudy', description: 'cloudy sky', icon: '01d');
      expect(result.iconUrl, 'http://openweathermap.org/img/w/01d.png');
    });
  });
}
