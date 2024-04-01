import 'package:cloudy/src/features/weather/domain/city/city.dart';
import 'package:cloudy/src/features/weather/domain/coordinates/coordinates.dart';
import 'package:cloudy/src/features/weather/domain/weather/weather.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Map<String, dynamic> city;

  group('City.toJson tests', () {
    setUp(() {
      city = {
        'name': 'São Paulo',
        'sys': {'country': 'BR'},
        'coord': {
          'lat': -23.5505,
          'lon': -46.6333,
        },
        'current': {
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
          'dt': 1711828408,
        },
        'forecast': [
          {
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
            'dt': 1712001208,
          },
        ],
      };
    });

    test('City.fromJson should return a valid City instance with all properties deserialized correctly', () {
      final result = City.fromJson(city);
      expect(result, isNotNull);
      expect(result.name, 'São Paulo');
      expect(result.country, 'BR');
      expect(result.coordinates, isNotNull);
      expect(result.coordinates.lat, -23.5505);
      expect(result.coordinates.lon, -46.6333);
      expect(result.currentWeather, isNotNull);
      expect(result.currentWeather!.dt, 1711828408);
      expect(result.currentWeather!.weatherDetails, isNotNull);
      expect(result.currentWeather!.weatherDetails!.temp, 27.3);
      expect(result.currentWeather!.weatherDetails!.tempMax, 31.5);
      expect(result.currentWeather!.weatherDetails!.tempMin, 24.2);
      expect(result.currentWeather!.weatherData, isNotEmpty);
      expect(result.currentWeather!.weatherData.first.main, 'Cloudy');
      expect(result.currentWeather!.weatherData.first.description, 'cloudy sky');
      expect(result.currentWeather!.weatherData.first.icon, '01d');
      expect(result.forecastWeather, isNotEmpty);
      expect(result.forecastWeather!.first.dt, 1712001208);
      expect(result.forecastWeather!.first.weatherDetails, isNotNull);
    });

    test('City.toJson should return a valid Map<String, dynamic> instance with all properties serialized correctly', () {
      final result = City.fromJson(city).toJson();
      expect(result, isNotNull);
      expect(result['name'], 'São Paulo');
      expect(result['sys']['country'], 'BR');
      expect(result['coord'], isNotNull);
      expect(result['coord']['lat'], -23.5505);
      expect(result['coord']['lon'], -46.6333);
      expect(result['current'], isNotNull);
      expect(result['current']['dt'], 1711828408);
      expect(result['current']['main'], isNotNull);
      expect(result['current']['main']['temp'], 27.3);
      expect(result['current']['main']['temp_min'], 24.2);
      expect(result['current']['main']['temp_max'], 31.5);
      expect(result['current']['weather'], isNotEmpty);
      expect(result['current']['weather'].first['main'], 'Cloudy');
      expect(result['current']['weather'].first['description'], 'cloudy sky');
      expect(result['current']['weather'].first['icon'], '01d');
      expect(result['forecast'], isNotEmpty);
      expect(result['forecast'].first['dt'], 1712001208);
      expect(result['forecast'].first['main'], isNotNull);
    });

    test('flagUrl should return the correct url based on the country', () {
      final result = City.fromJson(city);
      expect(result.flagUrl, 'https://openweathermap.org/images/flags/br.png');
    });

    test('City.copyWith should return a valid City instance with all properties copied correctly', () {
      final result = City.fromJson(city).copyWith(
        name: 'Paris',
        coordinates: const Coordinates(lat: 48.8566, lon: 2.3522),
        currentWeather: Weather(
          dt: 1712001208,
          weatherDetails: WeatherDetails(temp: 27.3, tempMin: 24.2, tempMax: 31.5),
          weatherData: [
            WeatherData(main: 'Cloudy', description: 'cloudy sky', icon: '01d'),
          ],
        ),
        forecastWeather: [
          Weather(
            dt: 1711828408,
            weatherDetails: WeatherDetails(temp: 27.3, tempMin: 24.2, tempMax: 31.5),
            weatherData: [
              WeatherData(main: 'Cloudy', description: 'cloudy sky', icon: '01d'),
            ],
          ),
        ],
      );
      expect(result, isNotNull);
      expect(result.name, 'Paris');
      expect(result.coordinates, isNotNull);
      expect(result.coordinates.lat, 48.8566);
      expect(result.coordinates.lon, 2.3522);
      expect(result.currentWeather, isNotNull);
      expect(result.currentWeather!.dt, 1712001208);
      expect(result.currentWeather!.weatherDetails, isNotNull);
      expect(result.currentWeather!.weatherDetails!.temp, 27.3);
      expect(result.currentWeather!.weatherDetails!.tempMax, 31.5);
      expect(result.currentWeather!.weatherDetails!.tempMin, 24.2);
      expect(result.currentWeather!.weatherData, isNotEmpty);
      expect(result.currentWeather!.weatherData.first.main, 'Cloudy');
      expect(result.currentWeather!.weatherData.first.description, 'cloudy sky');
      expect(result.currentWeather!.weatherData.first.icon, '01d');
      expect(result.forecastWeather, isNotEmpty);
      expect(result.forecastWeather!.first.dt, 1711828408);
      expect(result.forecastWeather!.first.weatherDetails, isNotNull);
    });

    test('City.copyWith should return original values if no property is passed on', () {
      final result = City.fromJson(city).copyWith();
      expect(result, isNotNull);
      expect(result.name, 'São Paulo');
      expect(result.coordinates, isNotNull);
      expect(result.coordinates.lat, -23.5505);
      expect(result.coordinates.lon, -46.6333);
      expect(result.currentWeather, isNotNull);
      expect(result.currentWeather!.dt, 1711828408);
      expect(result.currentWeather!.weatherDetails, isNotNull);
      expect(result.currentWeather!.weatherDetails!.temp, 27.3);
      expect(result.currentWeather!.weatherDetails!.tempMax, 31.5);
      expect(result.currentWeather!.weatherDetails!.tempMin, 24.2);
      expect(result.currentWeather!.weatherData, isNotEmpty);
      expect(result.currentWeather!.weatherData.first.main, 'Cloudy');
      expect(result.currentWeather!.weatherData.first.description, 'cloudy sky');
      expect(result.currentWeather!.weatherData.first.icon, '01d');
      expect(result.forecastWeather, isNotEmpty);
      expect(result.forecastWeather!.first.dt, 1712001208);
      expect(result.forecastWeather!.first.weatherDetails, isNotNull);
    });
  });
}
