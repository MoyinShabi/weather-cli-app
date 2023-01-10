// This file contains all the Networking Logic for the application.
import 'dart:convert';

import 'package:http/http.dart' as http;
/* `import as` defines a common identifier to be used when calling
functions/methods inside the package. */

import 'weather.dart';

// Custom Exception class for Weather API client:
class WeatherApiException implements Exception {
  final String message;

  const WeatherApiException(this.message);
}

class WeatherApiClient {
  static const baseUrl = 'www.metaweather.com';
  // Making our first request which is for the Location ID:
  Future<int> getLocationId(String city) async {
    final locationUrl =
        Uri.https(baseUrl, '/api/location/search/', {'query': city});
    /* Location url to get data from the API. Converting the string
    literal into a `Uri` object that will be used to make a request with 
    the "http" package. */

    final locationResponse = await http.get(locationUrl);
    /* This requests some data from the `locationUrl`, and awaits for a
    response. When the future completes, then we have the response data
    that we need (`locationResponse`). */

    /* Checking the status code to make sure that it is `200`, because 
    this will tell us if the server sent back a successful response: */
    if (locationResponse.statusCode != 200) {
      throw WeatherApiException('Error getting locationID for city: $city');
    }
    // print(locationResponse.body);

    /* Extracting the Location ID from the response data if the status
    code is `200`: */
    final locationJson = jsonDecode(locationResponse.body) as List;
    /* What the `jsonDecode()` function does is to take the response
    body, which is a List of JSON data (Map) as a `String`, and convert it 
    to a Dart JSON object (List) that we can use to retrieve the data we need.*/
    // print(locationJson);
    // A `List` of results containing a `Map` of key-value pairs

    // Error handling:
    if (locationJson.isEmpty) {
      throw WeatherApiException('No location found for: $city');
    }
    return locationJson.first['woeid'] as int;
    /* Location ID. We get the first (and only) item in the `locationJson`  
    list which is a `Map`, and access the value of the "Location ID" from  
    its key, `woeid`. */
  }

  // Making our second request which is for the weather of the gotten Location ID:
  Future<Weather> fetchWeather(int locationId) async {
    final weatherUrl = Uri.https(baseUrl, '/location/$locationId/');
    final weatherResponse = await http.get(weatherUrl);
    if (weatherResponse.statusCode != 200) {
      throw WeatherApiException(
          'Error getting weather for location $locationId');
    }
    // print(weatherResponse.body);
    // JSON data (a Map) as a `String` which contains many different parameters
    final weatherJson = jsonDecode(weatherResponse.body);
    // Parsed JSON object (Map) from String
    final consolidatedWeather = weatherJson['consolidated_weather'] as List;
    // Because the value of the key, `'consolidated_weather'` is a `List` of `Map`s

    // Error handling:
    if (consolidatedWeather.isEmpty) {
      throw WeatherApiException(
          'Weather data not available for locationId: $locationId');
    }
    return Weather.fromJson(consolidatedWeather[0]);
    /* Passing the weather data for "today" as an argument which is the
    first item in the List, and a Map */
  }

  // Method to finally get the weather from both results:
  Future<Weather> getWeather(String city) async {
    final locationId = await getLocationId(city);
    return fetchWeather(locationId);
  }
}
