import 'package:cloudy/src/core/data_result/data.dart';
import 'package:cloudy/src/core/dependencies/http/dio_service.dart';
import 'package:cloudy/src/features/weather/data/weather_repository.dart';
import 'package:cloudy/src/features/weather/domain/city/city.dart';
import 'package:cloudy/src/features/weather/domain/coordinates/coordinates.dart';
import 'package:cloudy/src/features/weather/domain/weather/weather.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'weather_repository_test.mocks.dart';

@GenerateMocks([DioService])
void main() {
  late MockDioService mockDioService;
  const coordinates = Coordinates(lat: 35, lon: 139);
  late WeatherRepository sut;
  final fakeWeatherSuccessfulResponse = DioReponse(
    statusCode: 200,
    body: {
      'coord': {'lon': 139, 'lat': 35},
      'weather': [
        {'id': 800, 'main': 'Clear', 'description': 'clear sky', 'icon': '01n'}
      ],
      'base': 'stations',
      'main': {'temp': 281.52, 'pressure': 1013, 'humidity': 93, 'temp_min': 280.15, 'temp_max': 283.71},
      'visibility': 10000,
      'wind': {'speed': 0.47, 'deg': 107.538},
      'clouds': {'all': 2},
      'dt': 1560350192,
      'sys': {'type': 3, 'id': 2019346, 'message': 0.0039, 'country': 'JP', 'sunrise': 1560281377, 'sunset': 1560333478},
      'timezone': 32400,
      'id': 1851632,
      'name': 'Shuzenji',
      'cod': 200
    },
  );

  final fakeCitiesSuccessfulResponse = DioReponse(
    statusCode: 200,
    body: {
      'list': [
        {
          'coord': {'lon': 139, 'lat': 35},
          'weather': [
            {'id': 800, 'main': 'Clear', 'description': 'clear sky', 'icon': '01n'}
          ],
          'base': 'stations',
          'main': {'temp': 281.52, 'pressure': 1013, 'humidity': 93, 'temp_min': 280.15, 'temp_max': 283.71},
          'visibility': 10000,
          'wind': {'speed': 0.47, 'deg': 107.538},
          'clouds': {'all': 2},
          'dt': 1560350192,
          'sys': {'type': 3, 'id': 2019346, 'message': 0.0039, 'country': 'JP', 'sunrise': 1560281377, 'sunset': 1560333478},
          'timezone': 32400,
          'id': 1851632,
          'name': 'Shuzenji',
          'cod': 200
        }
      ]
    },
  );

  final fakeForecastSuccessfulResponse = DioReponse(
    statusCode: 200,
    body: {
      'list': [
        {
          'dt': 1560350192,
          'main': {'temp': 281.52, 'temp_min': 280.15, 'temp_max': 283.71},
          'weather': [
            {'id': 800, 'main': 'Clear', 'description': 'clear sky', 'icon': '01n'}
          ]
        },
        {
          'dt': 1560350192,
          'main': {'temp': 281.52, 'temp_min': 280.15, 'temp_max': 283.71},
          'weather': [
            {'id': 800, 'main': 'Rainy', 'description': 'rainy', 'icon': '01n'}
          ]
        },
      ]
    },
  );

  setUp(() {
    mockDioService = MockDioService();
    sut = WeatherRepositoryImpl(dioService: mockDioService);
  });
  group('WeatherRepository fetchCurrentWeatherByGeolocation', () {
    test('WeatherRepository.fetchCurrentWeatherByGeolocation should return Weather when response is successful', () async {
      when(mockDioService.get(any)).thenAnswer((_) async => fakeWeatherSuccessfulResponse);

      final result = await sut.fetchCurrentWeatherByGeolocation(coordinates);

      expect(result.isSuccess, true);
      expect(result.data, isNotNull);
      expect(result.data, isA<Weather>());
      expect(result.data!.date, DateTime.fromMillisecondsSinceEpoch(1560350192 * 1000));
      expect(result.data!.weatherData, isNotEmpty);
      expect(result.data!.weatherData.first.description, 'clear sky');
      expect(result.data!.weatherData.first.icon, '01n');
      expect(result.data!.weatherData.first.main, 'Clear');
      expect(result.data!.weatherDetails, isNotNull);
      expect(result.data!.weatherDetails!.temp, 281.52);
      expect(result.data!.weatherDetails!.tempMin, 280.15);
      expect(result.data!.weatherDetails!.tempMax, 283.71);
    });

    test('WeatherRepository.fetchCurrentWeatherByGeolocation should return WeatherRepositoryException when response is not successful', () async {
      when(mockDioService.get(any)).thenAnswer((_) async => DioReponse(
            statusCode: 404,
            errorMessage: 'Not Found',
            body: {},
          ));

      final result = await sut.fetchCurrentWeatherByGeolocation(coordinates);

      expect(result.isFailure, true);
      expect(result.failure, isNotNull);
      expect(result.failure, isA<WeatherRepositoryException>());
      expect(result.failure!.message, 'Not Found');
    });

    test('WeatherRepository.fetchCurrentWeatherByGeolocation should return WeatherRepositoryException when any exception is thrown', () async {
      when(mockDioService.get(any)).thenThrow(Exception('Error'));

      final result = await sut.fetchCurrentWeatherByGeolocation(coordinates);

      expect(result.isFailure, true);
      expect(result.failure, isNotNull);
      expect(result.failure, isA<WeatherRepositoryException>());
      expect(result.failure!.message, 'An error occurred while fetching weather data');
    });
  });

  group('WeatherRepository searchWeather', () {
    test('WeatherRepository.searchWeather should return List<({City city, Weather weather}) when response is successfull', () async {
      when(mockDioService.get(any)).thenAnswer((_) async => fakeCitiesSuccessfulResponse);

      final result = await sut.searchWeather('Tokyo');

      expect(result.isSuccess, true);
      expect(result.data, isNotNull);
      expect(result.data, isA<List<({City city, Weather weather})>>());
      expect(result.data!.first.city, isA<City>());
      expect(result.data!.first.city.name, 'Shuzenji');
      expect(result.data!.first.weather, isA<Weather>());
      expect(result.data!.first.weather.date, DateTime.fromMillisecondsSinceEpoch(1560350192 * 1000));
      expect(result.data!.first.weather.weatherData, isNotEmpty);
      expect(result.data!.first.weather.weatherData.first.description, 'clear sky');
      expect(result.data!.first.weather.weatherData.first.icon, '01n');
      expect(result.data!.first.weather.weatherData.first.main, 'Clear');
      expect(result.data!.first.weather.weatherDetails, isNotNull);
      expect(result.data!.first.weather.weatherDetails!.temp, 281.52);
      expect(result.data!.first.weather.weatherDetails!.tempMin, 280.15);
      expect(result.data!.first.weather.weatherDetails!.tempMax, 283.71);
    });

    test('WeatherRepository.searchWeather should return WeatherRepositoryException when response is not successful', () async {
      when(mockDioService.get(any)).thenAnswer((_) async => DioReponse(
            statusCode: 404,
            errorMessage: 'Not Found',
            body: {},
          ));

      final result = await sut.searchWeather('Tokyo');

      expect(result.isFailure, true);
      expect(result.failure, isNotNull);
      expect(result.failure, isA<WeatherRepositoryException>());
      expect(result.failure!.message, 'Not Found');
    });

    test('WeatherRepository.searchWeather should return WeatherRepositoryException when any exception is thrown', () async {
      when(mockDioService.get(any)).thenThrow(Exception('Error'));

      final result = await sut.searchWeather('Tokyo');

      expect(result.isFailure, true);
      expect(result.failure, isNotNull);
      expect(result.failure, isA<WeatherRepositoryException>());
      expect(result.failure!.message, 'An error occurred while fetching weather data');
    });
  });

  group('WeatherRepository fetchForecastWeatherByGeolocation', () {
    test('WeatherRepository.fetchForecastWeatherByGeolocation should return List<Weather> when response is successfull', () async {
      when(mockDioService.get(any)).thenAnswer((_) async => fakeForecastSuccessfulResponse);

      final result = await sut.fetchForecastWeatherByGeolocation(coordinates);

      expect(result.isSuccess, true);
      expect(result.data, isNotNull);
      expect(result.data, isA<List<Weather>>());
      expect(result.data!.length, 2);
      expect(result.data!.first.date, DateTime.fromMillisecondsSinceEpoch(1560350192 * 1000));
      expect(result.data!.first.weatherData, isNotEmpty);
      expect(result.data!.first.weatherData.first.description, 'clear sky');
      expect(result.data!.first.weatherData.first.icon, '01n');
      expect(result.data!.first.weatherData.first.main, 'Clear');
      expect(result.data!.first.weatherDetails, isNotNull);
      expect(result.data!.first.weatherDetails!.temp, 281.52);
      expect(result.data!.first.weatherDetails!.tempMin, 280.15);
      expect(result.data!.first.weatherDetails!.tempMax, 283.71);
      expect(result.data!.last, isA<Weather>());
      expect(result.data!.last.date, DateTime.fromMillisecondsSinceEpoch(1560350192 * 1000));
      expect(result.data!.last.weatherData, isNotEmpty);
      expect(result.data!.last.weatherData.first.description, 'rainy');
      expect(result.data!.last.weatherData.first.icon, '01n');
      expect(result.data!.last.weatherData.first.main, 'Rainy');
      expect(result.data!.last.weatherDetails, isNotNull);
      expect(result.data!.last.weatherDetails!.temp, 281.52);
      expect(result.data!.last.weatherDetails!.tempMin, 280.15);
      expect(result.data!.last.weatherDetails!.tempMax, 283.71);
    });

    test('WeatherRepository.fetchForecastWeatherByGeolocation should return WeatherRepositoryException when response is not successful', () async {
      when(mockDioService.get(any)).thenAnswer((_) async => DioReponse(
            statusCode: 404,
            errorMessage: 'Not Found',
            body: {},
          ));

      final result = await sut.fetchForecastWeatherByGeolocation(coordinates);

      expect(result.isFailure, true);
      expect(result.failure, isNotNull);
      expect(result.failure, isA<WeatherRepositoryException>());
      expect(result.failure!.message, 'Not Found');
    });

    test('WeatherRepository.fetchForecastWeatherByGeolocation should return WeatherRepositoryException when any exception is thrown', () async {
      when(mockDioService.get(any)).thenThrow(Exception('Error'));

      final result = await sut.fetchForecastWeatherByGeolocation(coordinates);

      expect(result.isFailure, true);
      expect(result.failure, isNotNull);
      expect(result.failure, isA<WeatherRepositoryException>());
      expect(result.failure!.message, 'An error occurred while fetching weather data');
    });
  });
}
