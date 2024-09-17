import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;

// Modelo de datos para el pronóstico del clima
class WeatherForecast {
  final String date;
  final String description;
  final String iconUrl;
  final double minTemp;
  final double maxTemp;

  WeatherForecast({
    required this.date,
    required this.description,
    required this.iconUrl,
    required this.minTemp,
    required this.maxTemp,
  });

  factory WeatherForecast.fromJson(Map<String, dynamic> json) {
    return WeatherForecast(
      date: json['dt_txt'],
      description: json['weather'][0]['description'],
      iconUrl:
          'http://openweathermap.org/img/wn/${json['weather'][0]['icon']}.png',
      minTemp: json['main']['temp_min'] - 273.15, // Convertir a Celsius
      maxTemp: json['main']['temp_max'] - 273.15, // Convertir a Celsius
    );
  }
}

// Función para obtener los datos del pronóstico del clima
Future<List<WeatherForecast>> fetchWeatherForecast() async {
  const apiKey =
      '0ca7fb8919814e59836c2f5d2c86d168'; // Reemplaza con tu clave API
  const city = 'San Salvador';
  const url =
      'http://api.openweathermap.org/data/2.5/forecast?q=$city&cnt=7&appid=$apiKey';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final List<dynamic> list = data['list'];
    return list.map((json) => WeatherForecast.fromJson(json)).toList();
  } else {
    throw Exception('Error al obtener datos del clima');
  }
}

// Widget para mostrar una tarjeta del pronóstico del clima
class WeatherCard extends StatelessWidget {
  final WeatherForecast forecast;

  const WeatherCard({super.key, required this.forecast});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: ListTile(
        leading: SvgPicture.network(
          forecast.iconUrl,
          width: 50,
          height: 50,
        ),
        title: Text(forecast.date),
        subtitle: Text(
            '${forecast.description} - Min: ${forecast.minTemp.toStringAsFixed(1)}°C, Max: ${forecast.maxTemp.toStringAsFixed(1)}°C'),
      ),
    );
  }
}

// Pantalla principal que muestra la lista de pronósticos del clima
class WeatherForecastList extends StatefulWidget {
  const WeatherForecastList({super.key});

  @override
  _WeatherForecastListState createState() => _WeatherForecastListState();
}

class _WeatherForecastListState extends State<WeatherForecastList> {
  late Future<List<WeatherForecast>> _forecast;

  @override
  void initState() {
    super.initState();
    _forecast = fetchWeatherForecast();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pronóstico del Clima'),
      ),
      body: FutureBuilder<List<WeatherForecast>>(
        future: _forecast,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay datos disponibles'));
          } else {
            return ListView(
              children: snapshot.data!
                  .map((forecast) => WeatherCard(forecast: forecast))
                  .toList(),
            );
          }
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    title: 'Weather Forecast App',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: const WeatherForecastList(),
  ));
}
