import '../../../data/weather_repository.dart';
import '../../../domain/city/city.dart';
import '../../../domain/weather/weather.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'forecast_weather_state.dart';

class ForecastWeatherCubit extends Cubit<ForecastWeatherState> {
  ForecastWeatherCubit({
    required WeatherRepository weatherRepository,
  })  : _weatherRepository = weatherRepository,
        super(const ForecastWeatherState());

  final WeatherRepository _weatherRepository;

  Future<void> fetchForecast(City city) async {
    final result = await _weatherRepository.fetchForecastWeatherByGeolocation(city.coordinates);

    result.fold(
      (data) => emit(state.copyWith(forecast: data, loading: false)),
      (failure) => emit(state.copyWith(errorMessage: failure.message, loading: false)),
    );
  }
}
