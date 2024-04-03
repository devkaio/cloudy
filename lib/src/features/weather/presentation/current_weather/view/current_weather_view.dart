import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/widgets/search_list_bar.dart';
import '../../../domain/city/city.dart';
import '../../../domain/weather/weather.dart';
import '../../forecast_weather/forecast_weather.dart';
import '../cubit/current_weather_cubit.dart';

class CurrentWeatherView extends StatefulWidget {
  const CurrentWeatherView({super.key});

  @override
  State<CurrentWeatherView> createState() => _CurrentWeatherViewState();
}

class _CurrentWeatherViewState extends State<CurrentWeatherView> {
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
                  builder: (context, item) => ListTile(
                    title: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(item.city.name),
                        const SizedBox(width: 8),
                        CachedNetworkImage(
                          imageUrl: item.city.flagUrl,
                          placeholder: (context, url) => Image.asset('assets/images/flag-placeholder.jpg'),
                          errorWidget: (context, url, error) => Image.asset('assets/images/flag-placeholder.jpg'),
                        )
                      ],
                    ),
                    subtitle: Text('${item.weather.weatherDetails!.temp}°'),
                    trailing: item.weather.weatherData.firstOrNull != null ? Image.network(item.weather.weatherData.first.iconUrl) : null,
                    onTap: () => Navigator.popAndPushNamed(
                      context,
                      ForecastWeather.routeName,
                      arguments: item.city,
                    ),
                  ),
                  isLoading: state.currentWeatherStep == CurrentWeatherStep.searching,
                  hasData: state.currentWeatherStep == CurrentWeatherStep.searchResult && state.citiesSearchResult.isEmpty,
                  onChanged: context.read<CurrentWeatherCubit>().onSearchCityChanged,
                ),
                Flexible(
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: state.featuredCities.length,
                    itemBuilder: (context, index) {
                      final city = state.featuredCities[index];
                      return Card(
                        elevation: 0,
                        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                        child: ListTile(
                          minVerticalPadding: 16.0,
                          onTap: () {
                            Feedback.forTap(context);
                            Navigator.pushNamed(
                              context,
                              ForecastWeather.routeName,
                              arguments: city,
                            );
                          },
                          leading: city.currentWeather != null && city.currentWeather!.weatherData.isNotEmpty
                              ? CachedNetworkImage(
                                  imageUrl: city.currentWeather!.weatherData.first.iconUrl,
                                  placeholder: (context, url) => Image.asset('assets/images/cloud-placeholder.png'),
                                  errorWidget: (context, url, error) => Image.asset('assets/images/cloud-placeholder.png'),
                                )
                              : Image.asset('assets/images/cloud-placeholder.png'),
                          title: Text(
                            city.name,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              if (city.currentWeather?.weatherDetails != null)
                                Text(
                                  '${city.currentWeather?.weatherDetails?.temp} °C',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              if (city.currentWeather != null && city.currentWeather!.weatherData.isNotEmpty)
                                Text(
                                  '${city.currentWeather?.weatherData.first.main}',
                                  style: const TextStyle(fontSize: 12),
                                )
                            ],
                          ),
                        ),
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
