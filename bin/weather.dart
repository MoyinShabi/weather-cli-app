// Creating a strongly-typed, immutable model Weather class to parse JSON data:
class Weather {
  final String weatherState;
  final double minTemp;
  final double maxTemp;
  final double temp;

  const Weather({
    required this.weatherState,
    required this.minTemp,
    required this.maxTemp,
    required this.temp,
  });

// Factory constructor to parse JSON data from the Weather API server:
  factory Weather.fromJson(Map<String, Object?> json) => Weather(
        weatherState: json['weather_state_name'] as String,
        minTemp: json['min_temp'] as double,
        maxTemp: json['max_temp'] as double,
        temp: json['the_temp'] as double,
      );

  @override
  String toString() => '''
Current Temp: ${temp.toStringAsFixed(0)}°C
Condition: $weatherState
Daily Min: ${minTemp.toStringAsFixed(0)}°C
Daily Max: ${maxTemp.toStringAsFixed(0)}°C
     ''';
}
