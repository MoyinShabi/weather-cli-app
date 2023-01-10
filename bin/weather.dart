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
  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'] as String,
      weatherState: json['weather'][0]['main'] as String,
      weatherDescription: json['weather'][0]['description'] as String,
      temp: json['main']['temp'] as double,
      feel: json['main']['feels_like'] as double,
      maxTemp: json['main']['temp_max'] as double,
      minTemp: json['main']['temp_min'] as double,
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
