import '../../../../../core/widgets/search_list_bar.dart';
import '../../../domain/city/city.dart';
import '../../../domain/weather/weather.dart';
import '../cubit/current_weather_cubit.dart';
import '../../forecast_weather/forecast_weather.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
                  items: state.citiesSearchResult,
                  builder: (context, item) => ListTile(
                    title: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(item.city.name),
                        const SizedBox(width: 8),
                        Image.network(
                          item.city.flagUrl,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset('assets/images/offline.png');
                          },
                        ),
                      ],
                    ),
                    subtitle: Text('${item.weather.weatherDetails!.temp}°'),
                    trailing: item.weather.weatherData.firstOrNull != null ? Image.network(item.weather.weatherData.first.iconUrl) : null,
                    onTap: () {
                      context.read<CurrentWeatherCubit>().getCurrentWeather(item.city);
                    },
                  ),
                  isSearching: state.currentWeatherStep == CurrentWeatherStep.searching,
                  onChanged: context.read<CurrentWeatherCubit>().onSearchCityChanged,
                  onItemSelected: (city) => Navigator.pushNamed(
                    context,
                    ForecastWeather.routeName,
                    arguments: city,
                  ),
                ),
                Flexible(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    itemCount: state.featuredCities.length,
                    itemBuilder: (context, index) {
                      final city = state.featuredCities[index];
                      return GestureDetector(
                        onTap: () {
                          Feedback.forTap(context);
                          Navigator.pushNamed(
                            context,
                            ForecastWeather.routeName,
                            arguments: city,
                          );
                        },
                        child: Card(
                          color: Colors.amber,
                          child: Center(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(city.name),
                                    city.currentWeather?.weatherData.firstOrNull != null
                                        ? Image.network(
                                            city.currentWeather!.weatherData.first.iconUrl,
                                            errorBuilder: (context, error, stackTrace) => Image.asset(
                                              'assets/images/offline.png',
                                              height: 50,
                                            ),
                                          )
                                        : Image.asset(
                                            'assets/images/offline.png',
                                            width: 30,
                                          ),
                                  ],
                                ),
                                if (city.currentWeather == null) const Text('No data available at the moment.'),
                                if (city.currentWeather != null) ...[
                                  Text('Temperature: ${city.currentWeather?.weatherDetails?.temp}°'),
                                  Text('Min: ${city.currentWeather?.weatherDetails?.tempMin}°'),
                                  Text('Max: ${city.currentWeather?.weatherDetails?.tempMax}°'),
                                ]
                              ],
                            ),
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
