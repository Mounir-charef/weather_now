class WeatherModel {
  final String cityName;
  final String description;
  final num temperature;
  final num humidity;
  final String icon;
  final List<Forecast> dailyForecasts;

  WeatherModel({
    required this.cityName,
    required this.description,
    required this.temperature,
    required this.humidity,
    required this.icon,
    required this.dailyForecasts,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: '${json['name']}, ${json['sys']['country']}',
      description: json['weather'][0]['description'],
      temperature: json['main']['temp'] ,
      humidity: json['main']['humidity'],
      icon: json['weather'][0]['icon'],
      dailyForecasts: (json['daily'] as List)
          .map((daily) => Forecast.fromJson(daily))
          .toList(),
    );
  }
}

class Forecast {
  final DateTime date;
  final num temperature;
  final String description;
  final String icon;

  Forecast({
    required this.date,
    required this.temperature,
    required this.description,
    required this.icon,
  });

  factory Forecast.fromJson(Map<String, dynamic> json) {
    return Forecast(
      date: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
      temperature: json['main']['temp'],
      description: json['weather'][0]['description'],
      icon: json['weather'][0]['icon'],
    );
  }
}
