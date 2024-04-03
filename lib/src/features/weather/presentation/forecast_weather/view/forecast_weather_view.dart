import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/city/city.dart';
import '../cubit/forecast_weather_cubit.dart';
import 'widgets/forecast_weather_list_tile.dart';

class ForecastWeatherView extends StatelessWidget {
  const ForecastWeatherView({super.key});

  @override
  Widget build(BuildContext context) {
    final city = ModalRoute.of(context)!.settings.arguments as City;
    final initialData = List.generate(5, (index) => index);

    return Scaffold(
      appBar: AppBar(title: Text(city.name)),
      body: BlocBuilder<ForecastWeatherCubit, ForecastWeatherState>(
        builder: (context, state) {
          if (state.loading) {
            return ListView.builder(
              physics: const ClampingScrollPhysics(),
              itemCount: initialData.length,
              itemBuilder: (context, index) {
                return ForecastWeatherListTile(
                  index: index,
                  isLoading: state.loading,
                );
              },
            );
          }

          if (state.forecast != null && state.forecast!.isEmpty) {
            return const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  'There is not avaiable forecast data at the moment. Please try again later.',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          List<DateTime> dates = [];
          DateTime currentDate;
          DateTime previousDate = state.forecast!.first.date;
          bool isSameDay = false;

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
              return ForecastWeatherListTile(
                index: index,
                dates: dates,
                forecast: state.forecast!,
                isLoading: state.loading,
              );
            },
          );
        },
      ),
    );
  }
}
