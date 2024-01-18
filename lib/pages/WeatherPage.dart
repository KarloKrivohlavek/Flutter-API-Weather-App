import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:untitled/models/weather_model.dart';
import 'package:untitled/services/weather_service.dart';
import 'package:flutter_animate/flutter_animate.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({Key? key}) : super(key: key);

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _weatherService = WeatherService("9ff12055b7c2365490c1029f175cac67");

  Weather? _weather;

  _fetchWeather() async {
    String cityName = await _weatherService.getCurrentCity();

    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print(e);
    }
  }

  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/sunny.json';

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/windy.json';
      case 'thunderstorm':
        return 'assets/storm.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rainy.json';
      case 'clear':
        return 'assets/sunny.json';
      default:
        return 'assets/sunny.json';
    }
  }

  @override
  void initState() {
    super.initState();

    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          Color(
            0xFFADD8E6,
          ),
          Color(
            0xFF5D3FD3,
          )
        ])),
        child: Animate(
          effects: [FadeEffect()],
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LottieBuilder.asset(
                    getWeatherAnimation(_weather?.mainCondition)),
                Text(_weather?.cityName ?? "Loading city..."),
                Text('${_weather?.temperature.round().toString()}' "C"),
                Text(_weather?.mainCondition ?? ""),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
