import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:redacted/redacted.dart';

import '../../../../../../core/extensions/datetime_ext.dart';
import '../../../../../../core/extensions/string_ext.dart';
import '../../../../domain/weather/weather.dart';

class ForecastWeatherListTile extends StatelessWidget {
  const ForecastWeatherListTile({
    super.key,
    this.dates = const [],
    this.forecast = const [],
    required this.index,
    this.isLoading = true,
  });

  final List<DateTime> dates;
  final List<Weather> forecast;
  final int index;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final item = forecast.firstWhereOrNull((weather) => weather.date.day == dates[index].day);

    double? tempMax;

    if (forecast.isNotEmpty) {
      tempMax = forecast.where((weather) => weather.date.day == dates[index].day).map((e) => e.weatherDetails!.tempMax).reduce((current, next) => current > next ? current : next);
    }

    double? tempMin;
    if (forecast.isNotEmpty) {
      tempMin = forecast.where((weather) => weather.date.day == dates[index].day).map((e) => e.weatherDetails!.tempMin).reduce((current, next) => current < next ? current : next);
    }
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: ExpansionTile(
          shape: const RoundedRectangleBorder(),
          expandedAlignment: Alignment.centerLeft,
          title: Text(
            item?.date.formattedMMMEd ?? DateTime.now().formattedMMMEd,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ).redacted(context: context, redact: isLoading),
          subtitle: Text(item?.weatherData.first.description.toTitleCase ?? 'placeholder').redacted(
            context: context,
            redact: isLoading,
          ),
          leading: CachedNetworkImage(
            imageUrl: item?.weatherData.first.iconUrl ?? '',
            placeholder: (context, url) => Image.asset('assets/images/cloud-placeholder.png').redacted(
              context: context,
              redact: isLoading,
            ),
            errorWidget: (context, url, error) => Image.asset('assets/images/cloud-placeholder.png').redacted(
              context: context,
              redact: isLoading,
            ),
          ),
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
                  ).redacted(
                    context: context,
                    redact: isLoading,
                  ),
                  Text(
                    '$tempMin °C',
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ).redacted(
                    context: context,
                    redact: isLoading,
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
                children: forecast
                    .where((w) => w.date.day == item?.date.day)
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
  }
}
