import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/weather_repository.dart';
import '../../domain/city/city.dart';
import 'cubit/forecast_weather_cubit.dart';
import 'view/forecast_weather_view.dart';

class ForecastWeather extends StatelessWidget {
  const ForecastWeather({super.key});

  static const routeName = '/forecast-weather';

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as City;

    return BlocProvider(
      create: (context) => ForecastWeatherCubit(
        weatherRepository: RepositoryProvider.of<WeatherRepository>(context),
      )..fetchForecast(args),
      child: const ForecastWeatherView(),
    );
  }
}
