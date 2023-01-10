// A strongly-typed, immutable model Weather class to parse JSON data:
class Weather {
  final String cityName;
  final String weatherState;
  final String weatherDescription;
  final double temp;
  final double feel;
  final double maxTemp;
  final double minTemp;

  const Weather({
    required this.cityName,
    required this.weatherState,
    required this.weatherDescription,
    required this.temp,
    required this.feel,
    required this.maxTemp,
    required this.minTemp,
  });

// Factory constructor to parse JSON data from the Weather API server:
  factory Weather.fromJson(Map<String, Object?> json) {
    final weatherDescriptionData =
        json['weather_description'] as Map<String, Object?>;

    final tempData = json['temp_info'] as Map<String, Object?>;

    return Weather(
      cityName: json['city'] as String,
      weatherState: weatherDescriptionData['main'] as String,
      weatherDescription: weatherDescriptionData['description'] as String,
      temp: tempData['temp'] as double,
      feel: tempData['feels_like'] as double,
      maxTemp: tempData['temp_max'] as double,
      minTemp: tempData['temp_min'] as double,
    );
  }

  @override
  String toString() => '''
---$cityName---
Current Temp: ${temp.toStringAsFixed(0)}°C. Feels like ${feel.toStringAsFixed(0)}°C
Condition: $weatherState ($weatherDescription)
H: ${maxTemp.toStringAsFixed(0)}°C  L: ${minTemp.toStringAsFixed(0)}°C
''';
}
