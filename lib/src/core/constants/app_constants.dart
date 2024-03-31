abstract class AppConstants {
  static const String baseUrl = String.fromEnvironment('BASE_URL');
  static const String apiKey = String.fromEnvironment('API_KEY');
}

const featuredCities = <Map<String, dynamic>>[
  {
    'name': 'Silverstone',
    'coord': {'lat': 52.073273, 'lon': -1.014818},
  },
  {
    'name': 'São Paulo',
    'coord': {'lat': -23.5475, 'lon': -46.6361},
  },
  {
    'name': 'Melbourne',
    'coord': {'lat': -37.840935, 'lon': 144.946457},
  },
  {
    'name': 'Monte Carlo',
    'coord': {'lat': 43.740070, 'lon': 7.426644},
  },
];
