import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../domain/city/city.dart';
import '../../../../domain/weather/weather.dart';

class SearchResultListTile extends StatelessWidget {
  const SearchResultListTile({
    super.key,
    required this.item,
    this.onTap,
    this.isLoading = true,
  });

  final ({Weather weather, City city}) item;
  final VoidCallback? onTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return ListTile(
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
      trailing: CachedNetworkImage(
        imageUrl: item.weather.weatherData.first.iconUrl,
        placeholder: (context, url) => Image.asset('assets/images/cloud-placeholder.png'),
        errorWidget: (context, url, error) => Image.asset('assets/images/cloud-placeholder.png'),
      ),
      onTap: onTap != null
          ? () {
              Feedback.forTap(context);
              onTap!();
            }
          : () {},
    );
  }
}
