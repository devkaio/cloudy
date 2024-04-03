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
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: ListTile(
        minVerticalPadding: 16.0,
        onTap: onTap != null
            ? () {
                Feedback.forTap(context);
                onTap!();
              }
            : () {},
        leading: city.currentWeather != null && city.currentWeather!.weatherData.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: city.currentWeather!.weatherData.first.iconUrl,
                imageBuilder: (context, imageProvider) => Image(image: imageProvider).redacted(
                  context: context,
                  redact: isLoading,
                ),
                placeholder: (context, url) => Image.asset('assets/images/cloud-placeholder.png').redacted(
                  context: context,
                  redact: isLoading,
                ),
                errorWidget: (context, url, error) => Image.asset('assets/images/cloud-placeholder.png').redacted(
                  context: context,
                  redact: isLoading,
                ),
              )
            : Image.asset('assets/images/cloud-placeholder.png').redacted(
                context: context,
                redact: isLoading,
              ),
        title: Text(
          city.name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ).redacted(context: context, redact: isLoading),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${city.currentWeather?.weatherDetails?.temp} °C',
              style: const TextStyle(fontSize: 16),
            ).redacted(
              context: context,
              redact: isLoading,
            ),
            Text(
              '${city.currentWeather?.weatherData.first.main}',
              style: const TextStyle(fontSize: 12),
            ).redacted(
              context: context,
              redact: isLoading,
            )
          ],
        ),
      ),
    );
  }
}
