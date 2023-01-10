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
  static const baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  // Method to request (make an API call) for the Location ID (an integer) of a city:
  Future<int> getLocationId(String city) async {
    final locationUrl = Uri.parse(
        '$baseUrl?q=$city&appid=883b470dbb34979476b0ffb3031ec25a&units=metric');
    /* Location url to get data from the API. Converting the string
    literal into a `Uri` object that will be used to make a request with 
    the "http" package. */

    final locationResponse = await http.get(locationUrl);
    /* This requests some data from the server using `locationUrl`, and awaits for a
    response. When the future completes, then we have the response data
    that we need stored in `locationResponse`. */

    /* Checking the status code to make sure that it is `200`, because 
    this will tell us if the server sent back a successful response: */
    if (locationResponse.statusCode != 200) {
      throw WeatherApiException('Error getting locationID for city: $city');
    }
    // print(locationResponse.body); // A Map as a String literal

    /* Extracting the Location ID from the response data (locationResponse) 
   if the status code is `200`: */
    final locationJson =
        jsonDecode(locationResponse.body) as Map<String, dynamic>;
    /* What the `jsonDecode()` function does is to take the response
    body, which is some JSON data (Map) as a `String`, and convert it 
    to a Dart JSON object (Map) that we can use to retrieve the data we need.*/

    // print(locationJson);
    // A `Map` containing various key-value pairs

    // Error handling:
    if (locationJson.isEmpty) {
      throw WeatherApiException('No location found for: $city');
    }
    return locationJson['id'] as int;
    /* Location ID. We access the value of the "Location ID" in the `locationJson`
     Map using its key, `id`.*/
  }

  // Method to request for the weather of the gotten Location ID:
  Future<Weather> fetchWeather(int locationId) async {
    // Parsing the Url to a Uri object:
    final weatherUrl = Uri.parse(
        '$baseUrl?id=$locationId&appid=883b470dbb34979476b0ffb3031ec25a&units=metric');

    // Getting the response data from the server:
    final weatherResponse = await http.get(weatherUrl);

    // Error Handling:
    if (weatherResponse.statusCode != 200) {
      throw WeatherApiException(
          'Error getting weather for location $locationId');
    }

    // print(weatherResponse.body);
    // JSON data (a Map) as a `String` which contains many different parameters

    // Parsing the String to a JSON object:
    final weatherJson =
        jsonDecode(weatherResponse.body) as Map<String, dynamic>;

    // Error handling:
    if (weatherJson.isEmpty) {
      throw WeatherApiException(
          'Weather data not available for locationId: $locationId');
    }

    // Passing the weather JSON data as an argument:
    // return Weather.fromJson(requiredWeatherData);
    return Weather.fromJson(weatherJson);
  }

  // Method to finally get the weather from both results:
  Future<Weather> getWeather(String city) async {
    final locationId = await getLocationId(city);
    return fetchWeather(locationId);
  }
}
