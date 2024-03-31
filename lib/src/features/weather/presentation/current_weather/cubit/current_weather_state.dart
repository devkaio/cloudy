part of 'current_weather_cubit.dart';

enum CurrentWeatherStep {
  initial,
  searching,
  searchResult,
  failedSearch,
}

class CurrentWeatherState {
  const CurrentWeatherState({
    this.weather,
    this.errorMessage,
    this.featuredCities = const [],
    this.loading = true,
    this.currentWeatherStep = CurrentWeatherStep.initial,
    this.citiesSearchResult = const [],
  });

  final Weather? weather;
  final String? errorMessage;
  final List<City> featuredCities;
  final bool loading;
  final CurrentWeatherStep currentWeatherStep;
  final List<({City city, Weather weather})> citiesSearchResult;

  CurrentWeatherState copyWith({
    Weather? weather,
    String? errorMessage,
    List<City>? featuredCities,
    bool? loading,
    CurrentWeatherStep? currentWeatherStep,
    List<({City city, Weather weather})>? citiesSearchResult,
  }) {
    return CurrentWeatherState(
      weather: weather ?? this.weather,
      errorMessage: errorMessage ?? this.errorMessage,
      featuredCities: featuredCities ?? this.featuredCities,
      loading: loading ?? this.loading,
      currentWeatherStep: currentWeatherStep ?? this.currentWeatherStep,
      citiesSearchResult: citiesSearchResult ?? this.citiesSearchResult,
    );
  }
}
