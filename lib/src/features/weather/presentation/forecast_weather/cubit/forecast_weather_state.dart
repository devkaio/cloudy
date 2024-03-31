part of 'forecast_weather_cubit.dart';

class ForecastWeatherState {
  const ForecastWeatherState({
    this.forecast,
    this.errorMessage,
    this.loading = true,
  });

  final List<Weather>? forecast;
  final String? errorMessage;
  final bool loading;

  ForecastWeatherState copyWith({
    List<Weather>? forecast,
    String? errorMessage,
    bool? loading,
  }) {
    return ForecastWeatherState(forecast: forecast ?? this.forecast, errorMessage: errorMessage ?? this.errorMessage, loading: loading ?? this.loading);
  }
}
