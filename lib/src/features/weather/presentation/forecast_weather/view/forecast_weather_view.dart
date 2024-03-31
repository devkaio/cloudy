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
                final item = state.forecast!.firstWhere((weather) => weather.date == dates[index]);

                return ExpansionTile(
                    expandedAlignment: Alignment.centerLeft,
                    title: Text(item.date.formattedMMMEd),
                    subtitle: Text(item.weatherData.first.description.toTitleCase),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.network(item.weatherData.first.iconUrl),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('${item.weatherDetails?.tempMax}°'),
                            Text('${item.weatherDetails?.tempMin}°'),
                          ],
                        ),
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
                                      Image.network(e.weatherData.first.iconUrl),
                                      Text('${e.date.hour}:00'),
                                    ],
                                  ))
                              .toList(),
                        ),
                      ),
                    ]);
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
