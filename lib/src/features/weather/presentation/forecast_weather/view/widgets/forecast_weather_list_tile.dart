import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:redacted/redacted.dart';

import '../../../../../../core/extensions/datetime_ext.dart';
import '../../../../../../core/extensions/string_ext.dart';
import '../../../../domain/weather/weather.dart';

class ForecastWeatherListTile extends StatefulWidget {
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
  State<ForecastWeatherListTile> createState() => _ForecastWeatherListTileState();
}

class _ForecastWeatherListTileState extends State<ForecastWeatherListTile> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.forecast.firstWhereOrNull((weather) => weather.date.day == widget.dates[widget.index].day);

    double? tempMax;

    if (widget.forecast.isNotEmpty) {
      tempMax = widget.forecast
          .where((weather) => weather.date.day == widget.dates[widget.index].day)
          .map((e) => e.weatherDetails!.tempMax)
          .reduce((current, next) => current > next ? current : next);
    }

    double? tempMin;
    if (widget.forecast.isNotEmpty) {
      tempMin = widget.forecast
          .where((weather) => weather.date.day == widget.dates[widget.index].day)
          .map((e) => e.weatherDetails!.tempMin)
          .reduce((current, next) => current < next ? current : next);
    }
    return Card(
      child: ExpansionTile(
          onExpansionChanged: widget.isLoading ? null : (value) => setState(() => expanded = value),
          title: Text(
            item?.date.formattedMMMEd ?? DateTime.now().formattedMMMEd,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ).redacted(context: context, redact: widget.isLoading),
          subtitle: Text(item?.weatherData.first.description.toTitleCase ?? 'placeholder').redacted(
            context: context,
            redact: widget.isLoading,
          ),
          leading: CachedNetworkImage(
            imageUrl: item?.weatherData.first.iconUrl ?? '',
            placeholder: (context, url) => Image.asset('assets/images/cloud-placeholder.png').redacted(
              context: context,
              redact: widget.isLoading,
            ),
            errorWidget: (context, url, error) => Image.asset('assets/images/cloud-placeholder.png').redacted(
              context: context,
              redact: widget.isLoading,
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
                    redact: widget.isLoading,
                  ),
                  Text(
                    '$tempMin °C',
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ).redacted(
                    context: context,
                    redact: widget.isLoading,
                  ),
                ],
              ),
              const SizedBox(width: 8),
              expanded ? const Icon(Icons.expand_less) : const Icon(Icons.expand_more),
            ],
          ),
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: widget.forecast
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
