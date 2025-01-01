import 'package:flutter/material.dart';
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
      appBar: AppBar(title: Text('Weather App')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              onSubmitted: (_) => _fetchWeather(),
              decoration: InputDecoration(
                labelText: 'Enter city name',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _fetchWeather,
                ),
              ),
            ),
            if (_isLoading) CircularProgressIndicator(),
            if (_weatherData != null) ...[
              SizedBox(height: 20),
              Text(
                _weatherData!.cityName,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                'Temperature: ${_weatherData!.temperature}°C',
                style: TextStyle(fontSize: 18),
              ),
              Text('Humidity: ${_weatherData!.humidity}%'),
              Text('Precipitation: ${_weatherData!.precipitation} mm'),
            ],
          ],
        ),
      ),
    );
  }
}
