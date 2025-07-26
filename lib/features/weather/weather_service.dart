import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Weather {
  final String city;
  final double tempCelsius;
  final double tempFahrenheit;
  final String description;
  final String icon;

  Weather({
    required this.city,
    required this.tempCelsius,
    required this.tempFahrenheit,
    required this.description,
    required this.icon,
  });
}

class WeatherService {
  Future<Weather> fetchWeather(double lat, double lon) async {
    final apiKey = dotenv.env['OPENWEATHER_API_KEY'];
    final baseUrl = dotenv.env['WEATHER_API_BASE_URL'];
    final excludeParams = dotenv.env['WEATHER_API_EXCLUDE_PARAMS'];
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('API key not found. Please check your .env file.');
    }
    if (baseUrl == null || baseUrl.isEmpty) {
      throw Exception('API base URL not found. Please check your .env file.');
    }
    final urlCelsius = Uri.parse('$baseUrl?lat=$lat&lon=$lon&exclude=$excludeParams&units=metric&appid=$apiKey');
    final urlFahrenheit = Uri.parse('$baseUrl?lat=$lat&lon=$lon&exclude=$excludeParams&units=imperial&appid=$apiKey');
    final responses = await Future.wait([
      http.get(urlCelsius),
      http.get(urlFahrenheit),
    ]);
    final responseCelsius = responses[0];
    final responseFahrenheit = responses[1];
    if (responseCelsius.statusCode == 200 && responseFahrenheit.statusCode == 200) {
      final dataCelsius = json.decode(responseCelsius.body);
      final dataFahrenheit = json.decode(responseFahrenheit.body);
      return Weather(
        city: dataCelsius['timezone'] ?? 'Unknown City',
        tempCelsius: (dataCelsius['current']['temp'] as num).toDouble(),
        tempFahrenheit: (dataFahrenheit['current']['temp'] as num).toDouble(),
        description: dataCelsius['current']['weather'][0]['description'] ?? 'Unknown',
        icon: dataCelsius['current']['weather'][0]['icon'] ?? '',
      );
    } else {
      throw Exception('Failed to fetch weather data');
    }
  }
} 