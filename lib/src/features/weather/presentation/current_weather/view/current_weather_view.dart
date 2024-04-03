import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/widgets/search_list_bar.dart';
import '../../../domain/city/city.dart';
import '../../../domain/coordinates/coordinates.dart';
import '../../../domain/weather/weather.dart';
import '../../forecast_weather/forecast_weather.dart';
import '../cubit/current_weather_cubit.dart';
import 'widgets/current_weather_list_tile.dart';
import 'widgets/search_result_list_tile.dart';

class CurrentWeatherView extends StatefulWidget {
  const CurrentWeatherView({super.key});

  @override
  State<CurrentWeatherView> createState() => _CurrentWeatherViewState();
}

class _CurrentWeatherViewState extends State<CurrentWeatherView> {
  final initialData = List.generate(4, (index) => index);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurrentWeatherCubit, CurrentWeatherState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('cloudy'),
            centerTitle: true,
          ),
          body: RefreshIndicator.adaptive(
            onRefresh: context.read<CurrentWeatherCubit>().loadFeaturedCitiesWeather,
            child: Column(
              children: [
                SearchListBar<({City city, Weather weather})>(
                  searchHintText: 'Type a city name to search...',
                  items: state.citiesSearchResult,
                  builder: (context, item) => SearchResultListTile(
                    item: item,
                    onTap: () {
                      Navigator.popAndPushNamed(
                        context,
                        ForecastWeather.routeName,
                        arguments: item.city,
                      );
                    },
                    isLoading: state.currentWeatherStep == CurrentWeatherStep.searching,
                  ),
                  isLoading: state.currentWeatherStep == CurrentWeatherStep.searching,
                  hasData: state.currentWeatherStep == CurrentWeatherStep.searchResult && state.citiesSearchResult.isEmpty,
                  onChanged: context.read<CurrentWeatherCubit>().onSearchCityChanged,
                ),
                Flexible(
                  child: state.loading
                      ? ListView.builder(
                          itemCount: initialData.length,
                          itemBuilder: (context, index) => CurrentWeatherListTile(
                            city: City(
                              name: 'Loading...',
                              coordinates: const Coordinates(lat: 0, lon: 0),
                            ),
                            isLoading: state.loading,
                          ),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: state.featuredCities.length,
                          itemBuilder: (context, index) {
                            final city = state.featuredCities[index];

                            return CurrentWeatherListTile(
                              city: city,
                              onTap: () => Navigator.pushNamed(
                                context,
                                ForecastWeather.routeName,
                                arguments: city,
                              ),
                              isLoading: state.loading,
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
