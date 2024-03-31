import '../../../core/data_result/data.dart';
import '../../../core/dependencies/http/dio_service.dart';
import '../domain/city/city.dart';
import '../domain/coordinates/coordinates.dart';
import '../domain/weather/weather.dart';

abstract class WeatherRepository {
  Future<DataResult<Weather, Failure>> fetchCurrentWeatherByGeolocation(Coordinates coordinates);

  Future<DataResult<List<({City city, Weather weather})>, Failure>> searchWeather(String cityName);

  Future<DataResult<List<Weather>, Failure>> fetchForecastWeatherByGeolocation(Coordinates coordinates);
}

class WeatherRepositoryImpl implements WeatherRepository {
  WeatherRepositoryImpl({
    required DioService dioService,
  }) : _dioService = dioService;

  final DioService _dioService;
  @override
  Future<DataResult<Weather, Failure>> fetchCurrentWeatherByGeolocation(Coordinates coordinates) async {
    try {
      final response = await _dioService.get('/weather?lat=${coordinates.lat}&lon=${coordinates.lon}');

      if (response.statusCode != null && (response.statusCode! < 200 || response.statusCode! >= 300)) {
        throw WeatherRepositoryException(response.errorMessage);
      }
      return DataResult.success(Weather.fromJson(response.body));
    } on WeatherRepositoryException catch (e) {
      return DataResult.failure(e);
    } catch (e) {
      return DataResult.failure(WeatherRepositoryException('An error occurred while fetching weather data'));
    }
  }

  @override
  Future<DataResult<List<({City city, Weather weather})>, Failure>> searchWeather(String cityName) async {
    try {
      final response = await _dioService.get('/find?q=$cityName');

      if (response.statusCode != null && (response.statusCode! < 200 || response.statusCode! >= 300)) {
        throw WeatherRepositoryException(response.errorMessage);
      }

      final citiesWithWeather = (response.body['list'] as List).map((e) => (city: City.fromJson(e), weather: Weather.fromJson(e))).toList();

      return DataResult.success(citiesWithWeather);
    } on WeatherRepositoryException catch (e) {
      return DataResult.failure(e);
    } catch (e) {
      return DataResult.failure(WeatherRepositoryException('An error occurred while fetching weather data'));
    }
  }

  @override
  Future<DataResult<List<Weather>, Failure>> fetchForecastWeatherByGeolocation(Coordinates coordinates) async {
    try {
      final response = await _dioService.get('/forecast?lat=${coordinates.lat}&lon=${coordinates.lon}');
      if (response.statusCode != null && (response.statusCode! < 200 || response.statusCode! >= 300)) {
        throw WeatherRepositoryException(response.errorMessage);
      }

      final weather = (response.body['list'] as List).map((e) => Weather.fromJson(e)).toList();

      return DataResult.success(weather);
    } on WeatherRepositoryException catch (e) {
      return DataResult.failure(e);
    } catch (e) {
      return DataResult.failure(WeatherRepositoryException('An error occurred while fetching weather data'));
    }
  }
}
