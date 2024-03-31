import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/weather_repository.dart';
import 'cubit/current_weather_cubit.dart';
import 'view/current_weather_view.dart';

class CurrentWeather extends StatelessWidget {
  const CurrentWeather({super.key});

  static const routeName = '/current-weather';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CurrentWeatherCubit(
        weatherRepository: RepositoryProvider.of<WeatherRepository>(context),
      )..loadFeaturedCitiesWeather(),
      child: const CurrentWeatherView(),
    );
  }
}
