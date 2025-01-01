import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import './services/weather_service.dart';
import './models/weather_model.dart';

void main() => runApp(WeatherApp());

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue),
      home: WeatherScreen(),
    );
  }
}

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final TextEditingController _controller = TextEditingController();
  WeatherModel? _weatherData;
  bool _isLoading = false;

  final WeatherService _weatherService = WeatherService();

  void _fetchWeather() async {
    setState(() => _isLoading = true);
    try {
      final data = await _weatherService.fetchWeather(_controller.text);
      setState(() => _weatherData = data);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching weather: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              onSubmitted: (_) => _fetchWeather(),
              decoration: InputDecoration(
                labelText: 'Enter city name (e.g., London)',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _fetchWeather,
                ),
              ),
            ),
            if (_isLoading)
              Center(child: CircularProgressIndicator())
            else if (_weatherData != null)
              Expanded(
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Text(
                      _weatherData!.cityName,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Image.network(
                      'https://openweathermap.org/img/wn/${_weatherData!.icon}@2x.png',
                    ),
                    Text(
                      _weatherData!.description.toUpperCase(),
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      'Temperature: ${_weatherData!.temperature}°C',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Humidity: ${_weatherData!.humidity}%',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 20),
                    Text(
                      '7-Day Forecast',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _weatherData!.dailyForecasts.length,
                        itemBuilder: (context, index) {
                          final forecast = _weatherData!.dailyForecasts[index];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(
                                  DateFormat('EEE')
                                      .format(forecast.date)
                                      .toUpperCase(),
                                ),
                                Image.network(
                                  'https://openweathermap.org/img/wn/${forecast.icon}@2x.png',
                                  height: 50,
                                ),
                                Text('${forecast.temperature}°C'),
                                Text(forecast.description),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }
}

