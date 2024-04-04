import 'package:bloc_test/bloc_test.dart';
import 'package:cloudy/src/core/constants/app_constants.dart';
import 'package:cloudy/src/core/data_result/data.dart';
import 'package:cloudy/src/features/weather/data/weather_repository.dart';
import 'package:cloudy/src/features/weather/domain/city/city.dart';
import 'package:cloudy/src/features/weather/domain/coordinates/coordinates.dart';
import 'package:cloudy/src/features/weather/domain/weather/weather.dart';
import 'package:cloudy/src/features/weather/presentation/current_weather/cubit/current_weather_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockWeatherRepository extends Mock implements WeatherRepository {}

void main() {
  late WeatherRepository weatherRepository;

  setUpAll(() {
    registerFallbackValue(const Coordinates(lat: 0, lon: 0));
  });

  group(
    'CurrentWeatherCubit',
    () {
      blocTest(
        'should emit updated featured cities when loadFeaturedCitiesWeather is called',
        setUp: () async {
          weatherRepository = MockWeatherRepository();

          final weather = Weather.fromJson({
            'coord': {'lon': 0, 'lat': 0},
            'weather': [
              {'id': 800, 'main': 'Clear', 'description': 'clear sky', 'icon': '01d'}
            ],
            'main': {'temp': 0, 'feels_like': 0, 'temp_min': 0, 'temp_max': 0, 'pressure': 0, 'humidity': 0},
            'dt': 0,
          });

          when(() => weatherRepository.fetchCurrentWeatherByGeolocation(any())).thenAnswer(
            (_) async => DataResult.success(weather),
          );
        },
        build: () => CurrentWeatherCubit(weatherRepository: weatherRepository),
        act: (cubit) async {
          await cubit.loadFeaturedCitiesWeather();

          await untilCalled(() => weatherRepository.fetchCurrentWeatherByGeolocation(any()));
        },
        expect: () => [
          isA<CurrentWeatherState>()
              .having((state) => state.loading, 'loading', true) //
              .having((state) => state.featuredCities, 'featuredCities', isEmpty),
          isA<CurrentWeatherState>()
              .having((state) => state.loading, 'loading', false) //
              .having((state) => state.featuredCities, 'featuredCities', isNotEmpty) //
              .having((state) => state.featuredCities.first.currentWeather, 'currentWeather', isA<Weather>()) //
        ],
        verify: (_) {
          verify(() => weatherRepository.fetchCurrentWeatherByGeolocation(any())).called(featuredCities.length);
        },
      );

      blocTest('should emit errorMessage when loadFeaturedCitiesWeather fails',
          setUp: () async {
            weatherRepository = MockWeatherRepository();

            when(() => weatherRepository.fetchCurrentWeatherByGeolocation(any())).thenAnswer(
              (_) async => DataResult.failure(WeatherRepositoryException('error')),
            );
          },
          build: () => CurrentWeatherCubit(weatherRepository: weatherRepository),
          act: (cubit) async {
            await cubit.loadFeaturedCitiesWeather();

            await untilCalled(() => weatherRepository.fetchCurrentWeatherByGeolocation(any()));
          },
          expect: () => [
                isA<CurrentWeatherState>()
                    .having((state) => state.loading, 'loading', true) //
                    .having((state) => state.featuredCities, 'featuredCities', isEmpty),
                isA<CurrentWeatherState>()
                    .having((state) => state.loading, 'loading', false) //
                    .having((state) => state.featuredCities, 'featuredCities', isNotEmpty) //
                    .having((state) => state.errorMessage, 'errorMessage', 'error'),
              ],
          verify: (_) {
            verify(() => weatherRepository.fetchCurrentWeatherByGeolocation(any())).called(featuredCities.length);
          });

      blocTest<CurrentWeatherCubit, CurrentWeatherState>(
        'should emit [searching, searchResult] when onSearchCityChanged is called',
        setUp: () async {
          weatherRepository = MockWeatherRepository();

          final city = City.fromJson(featuredCities.first);

          final weather = Weather.fromJson({
            'coord': {'lon': 0, 'lat': 0},
            'weather': [
              {'id': 800, 'main': 'Clear', 'description': 'clear sky', 'icon': '01d'}
            ],
            'main': {'temp': 0, 'feels_like': 0, 'temp_min': 0, 'temp_max': 0, 'pressure': 0, 'humidity': 0},
            'dt': 0,
          });

          when(() => weatherRepository.searchWeather(any())).thenAnswer(
            (_) async => DataResult.success(
              [
                (city: city, weather: weather),
              ],
            ),
          );
        },
        build: () => CurrentWeatherCubit(weatherRepository: weatherRepository),
        act: (cubit) async {
          await cubit.onSearchCityChanged('London');

          await untilCalled(() => weatherRepository.searchWeather('London'));
        },
        expect: () => [
          isA<CurrentWeatherState>()
              .having((state) => state.currentWeatherStep, 'currentWeatherStep', CurrentWeatherStep.searching) //
              .having((state) => state.citiesSearchResult, 'citiesSearchResult', isEmpty) //
              .having((state) => state.loading, 'loading', true),
          isA<CurrentWeatherState>()
              .having((state) => state.currentWeatherStep, 'currentWeatherStep', CurrentWeatherStep.searchResult) //
              .having((state) => state.loading, 'loading', false) //
              .having((state) => state.citiesSearchResult, 'citiesSearchResult', isNotEmpty)
              .having((state) => state.citiesSearchResult.first.city, 'city', isA<City>()) //
              .having((state) => state.citiesSearchResult.first.weather, 'weather', isA<Weather>()) //
        ],
        verify: (_) {
          verify(() => weatherRepository.searchWeather(any())).called(1);
        },
      );

      blocTest<CurrentWeatherCubit, CurrentWeatherState>(
        'should emit [searching, errorMessage] when onSearchCityChanged fails',
        setUp: () async {
          weatherRepository = MockWeatherRepository();

          when(() => weatherRepository.searchWeather(any())).thenAnswer(
            (_) async => DataResult.failure(WeatherRepositoryException('error')),
          );
        },
        build: () => CurrentWeatherCubit(weatherRepository: weatherRepository),
        act: (cubit) async {
          await cubit.onSearchCityChanged('London');

          await untilCalled(() => weatherRepository.searchWeather('London'));
        },
        expect: () => [
          isA<CurrentWeatherState>()
              .having((state) => state.currentWeatherStep, 'currentWeatherStep', CurrentWeatherStep.searching) //
              .having((state) => state.citiesSearchResult, 'citiesSearchResult', isEmpty) //
              .having((state) => state.loading, 'loading', true),
          isA<CurrentWeatherState>()
              .having((state) => state.currentWeatherStep, 'currentWeatherStep', CurrentWeatherStep.searchResult) //
              .having((state) => state.loading, 'loading', false) //
              .having((state) => state.errorMessage, 'errorMessage', 'error') //
              .having((state) => state.citiesSearchResult, 'citiesSearchResult', isEmpty),
        ],
        verify: (_) {
          verify(() => weatherRepository.searchWeather(any())).called(1);
        },
      );

      blocTest(
        'should emit CurrentWeatherStep.initial if cityName is empty',
        setUp: () {
          weatherRepository = MockWeatherRepository();
        },
        build: () => CurrentWeatherCubit(weatherRepository: weatherRepository),
        act: (cubit) async {
          await cubit.onSearchCityChanged('');
        },
        expect: () => [
          isA<CurrentWeatherState>()
              .having((state) => state.currentWeatherStep, 'currentWeatherStep', CurrentWeatherStep.initial) //
              .having((state) => state.citiesSearchResult, 'citiesSearchResult', isEmpty) //
              .having((state) => state.loading, 'loading', false),
        ],
        verify: (_) {
          verifyNever(() => weatherRepository.searchWeather(''));
        },
      );

      blocTest('should emit CurrentWeatherStep.initial if the cityName is less than 3 characters',
          setUp: () {
            weatherRepository = MockWeatherRepository();
          },
          build: () => CurrentWeatherCubit(weatherRepository: weatherRepository),
          act: (cubit) async {
            await cubit.onSearchCityChanged('Lo');

            await Future.delayed(const Duration(seconds: 2));
          },
          expect: () => [
                isA<CurrentWeatherState>()
                    .having((state) => state.currentWeatherStep, 'currentWeatherStep', CurrentWeatherStep.searching) //
                    .having((state) => state.citiesSearchResult, 'citiesSearchResult', isEmpty) //
                    .having((state) => state.loading, 'loading', true),
                isA<CurrentWeatherState>()
                    .having((state) => state.currentWeatherStep, 'currentWeatherStep', CurrentWeatherStep.searchResult) //
                    .having((state) => state.citiesSearchResult, 'citiesSearchResult', isEmpty) //
                    .having((state) => state.loading, 'loading', false),
              ],
          verify: (_) {
            verifyNever(() => weatherRepository.searchWeather(''));
          });
    },
  );
}
