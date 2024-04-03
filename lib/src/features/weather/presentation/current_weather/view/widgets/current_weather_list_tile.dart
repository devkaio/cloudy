import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:redacted/redacted.dart';

import '../../../../domain/city/city.dart';

class CurrentWeatherListTile extends StatelessWidget {
  const CurrentWeatherListTile({
    super.key,
    required this.city,
    this.onTap,
    this.isLoading = true,
  });

  final City city;
  final VoidCallback? onTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        minVerticalPadding: 16.0,
        onTap: onTap != null
            ? () {
                Feedback.forTap(context);
                onTap!();
              }
            : () {},
        leading: CachedNetworkImage(
          imageUrl: city.currentWeather?.weatherData.first.iconUrl ?? '',
          placeholder: (context, url) => Image.asset('assets/images/cloud-placeholder.png').redacted(
            context: context,
            redact: isLoading,
          ),
          errorWidget: (context, url, error) => Image.asset('assets/images/cloud-placeholder.png').redacted(
            context: context,
            redact: isLoading,
          ),
        ),
        title: Text(
          city.name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ).redacted(context: context, redact: isLoading),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (city.currentWeather == null && !isLoading)
              const Text(
                '-- °C',
                style: TextStyle(fontSize: 16),
              ),
            if (isLoading)
              const Text(
                '-- °C',
                style: TextStyle(fontSize: 16),
              ).redacted(context: context, redact: true),
            if (city.currentWeather?.weatherDetails?.temp != null)
              Text(
                '${city.currentWeather?.weatherDetails?.temp} °C',
                style: const TextStyle(fontSize: 16),
              ).redacted(context: context, redact: isLoading),
            if (isLoading)
              const Text(
                '-- °C',
                style: TextStyle(fontSize: 16),
              ).redacted(context: context, redact: true),
            if (city.currentWeather?.weatherData.first.main != null)
              Text(
                '${city.currentWeather?.weatherData.first.main}',
                style: const TextStyle(fontSize: 12),
              ).redacted(context: context, redact: isLoading),
          ],
        ),
      ),
    );
  }
}
