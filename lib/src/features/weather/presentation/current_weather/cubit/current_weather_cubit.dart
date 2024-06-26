import 'dart:async';

import 'package:cloudy/src/core/data_result/failure.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/extensions/string_ext.dart';
import '../../../data/weather_repository.dart';
import '../../../domain/city/city.dart';
import '../../../domain/weather/weather.dart';

part 'current_weather_state.dart';

class CurrentWeatherCubit extends Cubit<CurrentWeatherState> {
  CurrentWeatherCubit({
    required WeatherRepository weatherRepository,
  })  : _weatherRepository = weatherRepository,
        super(const CurrentWeatherState());

  final WeatherRepository _weatherRepository;

  Timer? _debounce;

  Future<void> loadFeaturedCitiesWeather() async {
    emit(state.copyWith(loading: true));

    final parsedCities = featuredCities.map((e) => City.fromJson(e)).toList();
    final updatedFeaturedCities = List<City>.from(parsedCities);
    Failure? error;

    for (var city in parsedCities) {
      final result = await _weatherRepository.fetchCurrentWeatherByGeolocation(city.coordinates);

      result.fold(
        (data) {
          final index = updatedFeaturedCities.indexWhere((updateCity) => updateCity.coordinates == city.coordinates);
          updatedFeaturedCities[index] = city.copyWith(currentWeather: data);
        },
        (failure) {
          error = failure;
        },
      );
    }

    if (error != null) {
      emit(state.copyWith(
        featuredCities: parsedCities,
        loading: false,
        errorMessage: error!.message,
      ));
      return;
    }

    emit(state.copyWith(
      featuredCities: updatedFeaturedCities,
      loading: false,
    ));
  }

  Future<void> onSearchCityChanged(String cityName) async {
    if (cityName.trim().isEmpty) {
      _debounce?.cancel();

      emit(state.copyWith(
        citiesSearchResult: const [],
        currentWeatherStep: CurrentWeatherStep.initial,
        loading: false,
      ));
      return;
    }

    emit(state.copyWith(currentWeatherStep: CurrentWeatherStep.searching));

    _debounce?.cancel();
    _debounce = Timer(const Duration(seconds: 2), () async {
      if (cityName.trim().isEmpty || cityName.length < 3) {
        _debounce?.cancel();

        emit(
          state.copyWith(
            citiesSearchResult: const [],
            currentWeatherStep: CurrentWeatherStep.searchResult,
            loading: false,
          ),
        );
        return;
      }

      final result = await _weatherRepository.searchWeather(cityName.undiacritic);

      result.fold(
        (data) => emit(
          state.copyWith(
            currentWeatherStep: CurrentWeatherStep.searchResult,
            citiesSearchResult: data,
            loading: false,
          ),
        ),
        (failure) => emit(
          state.copyWith(
            currentWeatherStep: CurrentWeatherStep.searchResult,
            citiesSearchResult: [],
            loading: false,
            errorMessage: failure.message,
          ),
        ),
      );
    });
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
