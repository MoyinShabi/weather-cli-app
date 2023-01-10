import 'dart:io';

import 'weather_api_client.dart';

Future<void> main(List<String> args) async {
  if (args.length != 1) {
    print('Syntax: dart bin/main.dart <city>');
    return;
  }
  final city = args.first;
  // Creating an API client (an instance of the `WeatherApiClient` model class):
  final api = WeatherApiClient();
/*   final locationId = await api.getLocationId(city);
  print(locationId); */
  try {
    final weather = await api.getWeather(city);
    print(weather);
  } on WeatherApiException catch (e) {
    print(e.message);
    // This makes it explicit that we are only catching exceptions of this type.
  } on SocketException catch (_) {
    print('Could not fetch data. Check your internet connection.');
  } catch (e) {
    print(e);
  }
  /* The program is more robust now because it handles all possible 
  failure scenarios that we can encounter when we make the api call.
  
  NOTE: The bottom line is that if you want to write production-ready code,
  you need to think about all possible cases where things may go wrong.
  - And you can create your own exception classes to carry more meaningful 
  information about failure conditions in your own code.

  NOTE: The `WeatherApiClient` and `Weather` model classes are 
  well-designed and easy to use, because you can get the weather with 
  just a single method call. And they could also easily be used inside a
  Flutter weather app by importing them and hooking them up to a UI.
  */
}
