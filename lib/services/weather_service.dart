import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';
import 'package:flutter/foundation.dart';

class WeatherService {
  // don't rlly care if this is exposed
  final String apiKey = '5796abbde9106b7da4febfae8c44c232';

  Future<WeatherModel> fetchWeather(String city) async {
    final url =
        'https://api.openweathermap.org/data/2.5/weather?q=$city&units=metric&appid=$apiKey';

    final forecastUrl =
        'https://api.openweathermap.org/data/2.5/forecast?q=$city&units=metric&appid=$apiKey';

    final responsePromise =  http.get(Uri.parse(url));

    final forecastResponsePromise =  http.get(Uri.parse(forecastUrl));

    final response = await responsePromise;
    final forecastResponse = await forecastResponsePromise;

    if (!response.statusCode.toString().startsWith('4') && !forecastResponse.statusCode.toString().startsWith('4')) {
      final data = jsonDecode(response.body);
      final forecast = jsonDecode(forecastResponse.body);
      debugPrint(forecast.toString());

      data['daily'] = forecast['list'];

      return WeatherModel.fromJson(data);
    } else {
      debugPrint(response.body);
      debugPrint(forecastResponse.body);
      throw Exception('Failed to load weather data');
    }
  }
}