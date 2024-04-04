import 'package:bloc_test/bloc_test.dart';
import 'package:cloudy/src/core/data_result/data.dart';
import 'package:cloudy/src/features/weather/data/weather_repository.dart';
import 'package:cloudy/src/features/weather/domain/city/city.dart';
import 'package:cloudy/src/features/weather/domain/coordinates/coordinates.dart';
import 'package:cloudy/src/features/weather/domain/weather/weather.dart';
import 'package:cloudy/src/features/weather/presentation/forecast_weather/cubit/forecast_weather_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockWeatherRepository extends Mock implements WeatherRepository {}

void main() {
  late WeatherRepository weatherRepository;

  group('ForecastWeatherCubit', () {
    setUpAll(() {
      registerFallbackValue(City.fromJson({
        'name': 'city name',
        'coord': {'lat': 0, 'lon': 0}
      }));
      registerFallbackValue(Coordinates.fromJson({'lat': 0, 'lon': 0}));
    });
    blocTest(
      'should emit list of weather when fetchForecast is called',
      setUp: () async {
        weatherRepository = MockWeatherRepository();

        when(() => weatherRepository.fetchForecastWeatherByGeolocation(any())).thenAnswer(
          (_) async => DataResult.success(
            [
              Weather.fromJson({
                'main': {'temp': 27.3, 'temp_min': 24.2, 'temp_max': 31.5},
                'weather': [
                  {'main': 'Cloudy', 'description': 'cloudy sky', 'icon': '01d'},
                ],
                'dt': 1618945200,
              })
            ],
          ),
        );
      },
      build: () => ForecastWeatherCubit(weatherRepository: weatherRepository),
      act: (cubit) async {
        await cubit.fetchForecast(City.fromJson({
          'name': 'city name',
          'coord': {'lat': 0, 'lon': 0}
        }));
        await untilCalled(() => weatherRepository.fetchForecastWeatherByGeolocation(any()));
      },
      expect: () => [
        isA<ForecastWeatherState>()
            .having((state) => state.loading, 'loading', true) //
            .having((state) => state.forecast, 'forecast', isNull),
        isA<ForecastWeatherState>()
            .having((state) => state.loading, 'loading', false) //
            .having((state) => state.forecast, 'forecast', isNotNull) //
            .having((state) => state.forecast!.first, 'forecast.first', isA<Weather>())
      ],
    );

    blocTest(
      'should emit errorMessage when fetchForecast fails',
      setUp: () async {
        weatherRepository = MockWeatherRepository();

        when(() => weatherRepository.fetchForecastWeatherByGeolocation(any())).thenAnswer(
          (_) async => DataResult.failure(WeatherRepositoryException('error')),
        );
      },
      build: () => ForecastWeatherCubit(weatherRepository: weatherRepository),
      act: (cubit) async {
        await cubit.fetchForecast(City.fromJson({
          'name': 'city name',
          'coord': {'lat': 0, 'lon': 0}
        }));
        await untilCalled(() => weatherRepository.fetchForecastWeatherByGeolocation(any()));
      },
      expect: () => [
        isA<ForecastWeatherState>()
            .having((state) => state.loading, 'loading', true) //
            .having((state) => state.errorMessage, 'errorMessage', isNull),
        isA<ForecastWeatherState>()
            .having((state) => state.loading, 'loading', false) //
            .having((state) => state.errorMessage, 'errorMessage', isNotNull),
      ],
    );
  });
}
