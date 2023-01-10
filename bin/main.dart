import 'dart:io';

import 'weather_api_client.dart';

Future<void> main(List<String> argument) async {
  if (argument.length != 1) {
    print('Syntax: dart bin/main.dart <city>');
    return;
  }
  final city = argument.first;

  // Creating an API client (an instance of the `WeatherApiClient` model class):
  final api = WeatherApiClient();

  // final locationId = await api.getLocationId(city);
  // print(locationId);

  // Error Handling:
  try {
    final weather = await api.getWeather(city);
    print(weather);
  } on WeatherApiException catch (e) {
    print(e.message);
  } on SocketException catch (_) {
    // This makes it explicit that we are only catching exceptions of this type
    print('Could not fetch data. Check your internet connection.');
  } catch (e) {
    print(e);
  }

  /*
  NOTE: The `WeatherApiClient` and `Weather` model classes are 
  well-designed and easy to use, because you can get the weather with 
  just a single method call. And they could also easily be used inside a
  Flutter weather app by importing them and hooking them up to a UI.
  */
}
