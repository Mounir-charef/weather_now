class WeatherModel {
  final String cityName;
  final String description;
  final double temperature;
  final int humidity;
  final double precipitation;
  final DateTime date;
  final List<Forecast> forecasts;

  WeatherModel({
    required this.cityName,
    required this.description,
    required this.temperature,
    required this.humidity,
    required this.precipitation,
    required this.date,
    required this.forecasts,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: json['name'],
      description: json['weather'][0]['description'],
      temperature: json['main']['temp'],
      humidity: json['main']['humidity'],
      precipitation: json['rain']?['1h'] ?? 0.0,
      date: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
      forecasts: (json['daily'] as List).map((f) => Forecast.fromJson(f)).toList(),
    );
  }
}

class Forecast {
  final DateTime date;
  final String description;
  final double temperature;

  Forecast({
    required this.date,
    required this.description,
    required this.temperature,
  });

  factory Forecast.fromJson(Map<String, dynamic> json) {
    return Forecast(
      date: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
      description: json['weather'][0]['description'],
      temperature: json['temp']['day'],
    );
  }
}
