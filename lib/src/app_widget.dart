import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/constants/app_constants.dart';
import 'core/dependencies/connectivity/connectivity_service.dart';
import 'core/dependencies/http/dio_service.dart';
import 'core/dependencies/local_storage/shared_preferences_service.dart';
import 'features/connection_checker/presentation/cubit/connection_checker_cubit.dart';
import 'features/connection_checker/presentation/view/connection_checker.dart';
import 'features/weather/data/weather_repository.dart';
import 'features/weather/presentation/current_weather/current_weather.dart';
import 'features/weather/presentation/forecast_weather/forecast_weather.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ConnectionCheckerCubit(connectivityService: ConnectivityService()),
      child: RepositoryProvider<WeatherRepository>(
        create: (context) => WeatherRepositoryImpl(
          dioService: DioService(
            sharedPreferencesService: SharedPreferencesService(),
            dio: Dio(
              BaseOptions(
                baseUrl: AppConstants.baseUrl,
                queryParameters: {
                  'appid': AppConstants.apiKey,
                  'units': 'metric',
                },
              ),
            ),
          ),
        ),
        child: MaterialApp(
          themeMode: ThemeMode.system,
          theme: ThemeData.light().copyWith(
            textTheme: Theme.of(context).textTheme.apply(
                  fontFamily: 'Cera',
                  bodyColor: Colors.grey.shade800,
                ),
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
            cardTheme: CardTheme(color: Colors.pink.shade100),
            expansionTileTheme: ExpansionTileThemeData(
              iconColor: Colors.pink,
              textColor: Colors.grey.shade900,
              collapsedTextColor: Colors.grey.shade900,
            ),
          ),
          darkTheme: ThemeData.dark().copyWith(
            textTheme: Theme.of(context).textTheme.apply(
                  fontFamily: 'Cera',
                  bodyColor: Colors.grey.shade300,
                ),
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.pink,
              brightness: Brightness.dark,
            ),
            cardTheme: CardTheme(color: Colors.grey.shade800),
            expansionTileTheme: ExpansionTileThemeData(
              iconColor: Colors.pink,
              textColor: Colors.grey.shade300,
              collapsedTextColor: Colors.grey.shade300,
            ),
          ),
          initialRoute: CurrentWeather.routeName,
          routes: {
            CurrentWeather.routeName: (context) => const ConnectionChecker(child: CurrentWeather()),
            ForecastWeather.routeName: (context) => const ConnectionChecker(child: ForecastWeather()),
          },
        ),
      ),
    );
  }
}
