import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/extensions/datetime_ext.dart';
import '../../../../../core/extensions/string_ext.dart';
import '../../../domain/city/city.dart';
import '../cubit/forecast_weather_cubit.dart';

class ForecastWeatherView extends StatelessWidget {
  const ForecastWeatherView({super.key});

  @override
  Widget build(BuildContext context) {
    final city = ModalRoute.of(context)!.settings.arguments as City;

    return Scaffold(
      appBar: AppBar(title: Text(city.name)),
      body: BlocBuilder<ForecastWeatherCubit, ForecastWeatherState>(
        builder: (context, state) {
          if (state.errorMessage != null) {
            return Center(
              child: Text(state.errorMessage!),
            );
          } else if (state.forecast != null) {
            List<DateTime> dates = [];
            DateTime currentDate;
            DateTime previousDate = state.forecast!.first.date;
            bool isSameDay = false;

            if (state.forecast!.isEmpty) return const Text('No forecast at the moment');

            for (var w in state.forecast!) {
              currentDate = w.date;

              if (currentDate.day != previousDate.day) {
                isSameDay = false;
                previousDate = currentDate;
              } else {
                isSameDay = true;
              }

              if (!isSameDay) {
                dates.add(currentDate);
              }
            }

            return ListView.builder(
              physics: const ClampingScrollPhysics(),
              itemCount: dates.length,
              itemBuilder: (context, index) {
                final item = state.forecast!.firstWhere((weather) => weather.date.day == dates[index].day);

                final tempMax = state.forecast!
                    .where((weather) => weather.date.day == dates[index].day)
                    .map((e) => e.weatherDetails!.tempMax)
                    .reduce((current, next) => current > next ? current : next);

                final tempMin = state.forecast!
                    .where((weather) => weather.date.day == dates[index].day)
                    .map((e) => e.weatherDetails!.tempMin)
                    .reduce((current, next) => current < next ? current : next);

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: ExpansionTile(
                      shape: const RoundedRectangleBorder(),
                      expandedAlignment: Alignment.centerLeft,
                      title: Text(
                        item.date.formattedMMMEd,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                      subtitle: Text(item.weatherData.first.description.toTitleCase),
                      leading: item.weatherData.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: item.weatherData.first.iconUrl,
                              placeholder: (context, url) => Image.asset('assets/images/cloud-placeholder.png'),
                              errorWidget: (context, url, error) => Image.asset('assets/images/cloud-placeholder.png'),
                            )
                          : Image.asset('assets/images/cloud-placeholder.png'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '$tempMax °C',
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                '$tempMin °C',
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 8),
                        ],
                      ),
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: state.forecast!
                                .where((w) => w.date.day == item.date.day)
                                .map((e) => Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text('${e.weatherDetails!.temp}°'),
                                        CachedNetworkImage(
                                          imageUrl: e.weatherData.first.iconUrl,
                                          placeholder: (context, url) => Image.asset('assets/images/cloud-placeholder.png'),
                                          errorWidget: (context, url, error) => Image.asset('assets/images/cloud-placeholder.png'),
                                        ),
                                        Text('${e.date.hour}:00'),
                                      ],
                                    ))
                                .toList(),
                          ),
                        ),
                      ]),
                );
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
        },
      ),
    );
  }
}
