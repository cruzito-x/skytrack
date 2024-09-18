import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:http/http.dart' as http;
import 'package:skytrack/utils/sidebar.dart';

// Mapa para asociar descripciones del clima con archivos Lottie
const Map<String, String> weatherLottieMap = {
  'cielo claro': 'assets/images/json/clear-day.json',
  'algo de nubes': 'assets/images/json/few-clouds.json',
  'nubes dispersas': 'assets/images/cloudy.json',
  'muy nuboso': 'assets/images/json/cloudy-fog.json',
  'nubes': 'assets/images/json/cloudy.json',
  'lluvia ligera': 'assets/images/json/rain.json',
  'lluvia moderada': 'assets/images/json/rain.json',
  'lluvias intensas': 'assets/images/json/rain.json',
  'tormenta': 'assets/images/json/storm.json',
  'nieve': 'assets/images/json/snow.json',
  'neblina': 'assets/images/json/mist.json',
};

// Modelo de datos para el pronóstico del clima
class WeatherForecast {
  final String date;
  final String description;
  final String lottieFile;
  final double temperature;
  final double rain;
  final double wind;
  final int humidity;
  final double minTemp;
  final double maxTemp;

  WeatherForecast({
    required this.date,
    required this.description,
    required this.lottieFile,
    required this.temperature,
    required this.rain,
    required this.wind,
    required this.humidity,
    required this.minTemp,
    required this.maxTemp,
  });

  factory WeatherForecast.fromJson(Map<String, dynamic> json) {
    String description = json['weather'][0]['description'];
    String lottieFile =
        weatherLottieMap[description] ?? 'assets/images/json/pointer.json';
    double rain = 0;

    if (json.containsKey('rain') && json['rain']['3h'] != null) {
      rain = json['rain']['3h'];
    } else {
      rain = 0;
    }

    double wind = (json['wind']['speed'] as num).toDouble();
    int humidity = json['main']['humidity'];

    return WeatherForecast(
      date: json['dt_txt'],
      description: description,
      lottieFile: lottieFile,
      rain: rain,
      humidity: humidity,
      wind: wind,
      temperature: json['main']['temp'] - 273.15,
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
      'http://api.openweathermap.org/data/2.5/forecast?q=$city&cnt=7&appid=$apiKey&lang=es';

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
  final int dayIndex;

  const WeatherCard(
      {super.key, required this.forecast, required this.dayIndex});

  String getAbbreviatedDayName(String dateString) {
    DateTime date =
        DateTime.now().add(Duration(days: dayIndex)); // Día relativo al actual
    return DateFormat('E', 'es_ES').format(date); // Día abreviado
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: ListTile(
        leading: Lottie.asset(
          forecast.lottieFile,
          width: 50,
          height: 50,
        ),
        title: Text(
          '${getAbbreviatedDayName(forecast.date).substring(0, 1).toUpperCase() + getAbbreviatedDayName(forecast.date).substring(1)} - ${forecast.description.substring(0, 1).toUpperCase() + forecast.description.substring(1)}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${forecast.minTemp.toStringAsFixed(1)} °C | ${forecast.maxTemp.toStringAsFixed(1)} °C',
          style: const TextStyle(fontSize: 14),
        ),
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
  late WeatherForecast _nextDayForecast;

  @override
  void initState() {
    super.initState();
    _forecast = fetchWeatherForecast();

    initializeDateFormatting('es_ES', null).then((_) {
      _forecast = fetchWeatherForecast();
    });
  }

  String getDayName(String dateString, int dayIndex) {
    DateTime date = DateTime.now().add(Duration(days: dayIndex));
    return DateFormat('EEEE', 'es_ES').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Próximos 7 días', style: TextStyle(fontSize: 16)),
        backgroundColor: Colors.white,
        foregroundColor: const Color.fromRGBO(0, 51, 102, 1),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,
              color: Color.fromRGBO(0, 51, 102, 1)),
          onPressed: () {
            Navigator.pop(context); // Navega hacia atrás
          },
        ),
      ),
      endDrawer: const Sidebar(),
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
            final forecasts = snapshot.data!;
            _nextDayForecast = forecasts[1];

            return Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(0, 51, 102, 1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: const EdgeInsets.all(16.0),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Lottie.asset(
                            _nextDayForecast.lottieFile,
                            width: 150,
                            height: 150,
                          ),
                          const SizedBox(width: 40),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                getDayName(_nextDayForecast.date, 1)
                                        .substring(0, 1)
                                        .toUpperCase() +
                                    getDayName(_nextDayForecast.date, 1)
                                        .substring(1),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8), // Espaciado vertical
                              Text(
                                '${_nextDayForecast.minTemp.toStringAsFixed(1)}° C',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text(
                                '${(_nextDayForecast.rain * 100).round() / 100}%',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Text(
                                'Lluvia',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                '${(_nextDayForecast.wind * 100).round() / 100} m/s',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Text(
                                'Viento',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                '${_nextDayForecast.wind} m/s',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Text(
                                'Humedad',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                '${_nextDayForecast.minTemp.toStringAsFixed(1)}° C | ${_nextDayForecast.maxTemp.toStringAsFixed(1)}° C',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Text(
                                'Temperaturas',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: forecasts.length,
                    itemBuilder: (context, index) {
                      return WeatherCard(
                          forecast: forecasts[index + 1], dayIndex: index + 1);
                    },
                  ),
                ),
              ],
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
