import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart';
import 'package:skytrack/utils/sidebar.dart';
import 'package:skytrack/views/weather.dart';
import 'dart:async';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool _isLoading = true;
  Timer? _timer;
  String formattedTime = '';
  String formattedDate = '';

  @override
  void initState() {
    super.initState();
    _loadData();
    _startClock();
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancela el Timer cuando el widget se destruye
    super.dispose();
  }

  void _startClock() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        final now = DateTime.now();
        formattedTime = DateFormat('hh:mm a').format(now);
        formattedDate = DateFormat('E dd MMM').format(now);
      });
    });
  }

  Future<void> _loadData() async {
    await Future.delayed(
        const Duration(seconds: 3)); // Simula una carga de datos
    setState(() {
      _isLoading = false; // Datos cargados, cambia el estado
    });
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final hour = now.hour;
    String greeting;
    String star = '';

    if (hour < 12) {
      greeting = '¡Buenos días!';
      star = 'assets/images/json/clear-day.json';
    } else if (hour < 18) {
      greeting = '¡Buenas tardes!';
      star = 'assets/images/json/clear-day.json';
    } else {
      greeting = '¡Buenas noches!';
      star = 'assets/images/json/clear-night.json';
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(width: 8), // Espacio entre el Lottie y el texto
            const Text(
              'San Salvador, SV',
              style: TextStyle(fontSize: 14),
            ),
            Lottie.asset(
              'assets/images/json/pointer.json',
              width: 30,
              height: 30,
            ),
          ],
        ),
        actions: [
          Builder(
            builder: (BuildContext context) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openEndDrawer(); // Open end drawer
              },
            ),
          ),
        ],
        backgroundColor: Colors.white,
        foregroundColor: const Color.fromRGBO(0, 51, 102, 1),
      ),
      endDrawer: const Sidebar(),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Color.fromRGBO(0, 51, 102, 1),
                ),
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Row(children: [
                        Text(
                          greeting,
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(0, 51, 102, 1),
                          ),
                        ),
                        Lottie.asset(
                          star,
                          width: 36,
                          height: 36,
                        ),
                      ]),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Column(
                        children: [
                          Lottie.asset(
                            'assets/images/json/clear-day.json',
                            width: 206,
                            height: 206,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '$formattedDate | $formattedTime',
                            style: const TextStyle(
                                fontSize: 16, color: Colors.grey),
                          ),
                          const Text(
                            '25° C',
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(0, 51, 102, 1),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildWeatherDetail(
                            'assets/images/json/storm.json', '22%', 'Lluvia'),
                        _buildWeatherDetail('assets/images/json/wind.json',
                            '12 Km/H', 'Viento'),
                        _buildWeatherDetail('assets/images/json/humidity.json',
                            '17%', 'Humedad'),
                        _buildWeatherDetail('assets/images/json/hot.json',
                            '12°C | 38°C', 'Temperatura'),
                      ],
                    ),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Hoy',
                          style: TextStyle(
                              fontSize: 14,
                              color: Color.fromRGBO(0, 51, 102, 1),
                              fontWeight: FontWeight.bold),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const WeatherForecastList()),
                            );
                          },
                          child: const Text(
                            'Próximos 7 días',
                            style: TextStyle(
                                fontSize: 14,
                                color: Color.fromRGBO(0, 51, 102, 1),
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 120,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          _buildHourlyForecast('12:00 am', '33° C',
                              'assets/images/json/cloudy.json', now),
                          _buildHourlyForecast('4:00 am', '30° C',
                              'assets/images/json/rain.json', now),
                          _buildHourlyForecast('8:00 am', '27° C',
                              'assets/images/json/storm.json', now),
                          _buildHourlyForecast('12:00 pm', '25° C',
                              'assets/images/json/clear-day.json', now),
                          _buildHourlyForecast('04:00 pm', '22° C',
                              'assets/images/json/clear-night.json', now),
                          _buildHourlyForecast('08:00 pm', '22° C',
                              'assets/images/json/cloudy.json', now),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  // Function to build weather details (Lluvia, Viento, etc.)
  Widget _buildWeatherDetail(String lottiePath, String value, String label) {
    return Column(
      children: [
        Lottie.asset(lottiePath, width: 40, height: 40),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 16)),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  // Function to build hourly forecast
  Widget _buildHourlyForecast(
      String time, String temp, String lottiePath, DateTime now) {
    final forecastTime = _parseTime(time);
    if (forecastTime == null) {
      return Container(); // Maneja el caso donde no se puede analizar el tiempo
    }

    // Ajusta la fecha del tiempo pronosticado para el caso de horas después de medianoche
    final forecastDateTime = forecastTime.isBefore(now)
        ? forecastTime.add(const Duration(days: 1))
        : forecastTime;

    // Verifica si el pronóstico está dentro de las próximas 4 horas
    final isFuture = forecastDateTime.isAfter(now);
    final isInNext4Hours =
        forecastDateTime.isBefore(now.add(const Duration(hours: 4)));

    // El color debe marcar la próxima tarjeta dentro de las siguientes 4 horas
    final isCurrent = isFuture && isInNext4Hours;

    return Container(
      width: 90,
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.only(right: 8.0),
      decoration: BoxDecoration(
        color:
            isCurrent ? const Color.fromRGBO(0, 51, 102, 1) : Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            time,
            style: TextStyle(
              fontSize: 14,
              color: isCurrent
                  ? Colors.white
                  : const Color.fromRGBO(0, 51, 102, 1),
            ),
          ),
          Lottie.asset(
            lottiePath,
            width: 50,
            height: 50,
          ),
          Text(
            temp,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isCurrent
                  ? Colors.white
                  : const Color.fromRGBO(0, 51, 102, 1),
            ),
          ),
        ],
      ),
    );
  }

  DateTime? _parseTime(String time) {
    try {
      final parts = time.split(' ');
      final hourMinute = parts[0].split(':');
      final hour = int.parse(hourMinute[0]);
      final minute = int.parse(hourMinute[1]);
      final period = parts.length > 1 ? parts[1] : '';

      if (period == 'pm' && hour < 12) {
        return DateTime.now().copyWith(hour: hour + 12, minute: minute);
      } else if (period == 'am' && hour == 12) {
        return DateTime.now().copyWith(hour: 0, minute: minute);
      } else {
        return DateTime.now().copyWith(hour: hour, minute: minute);
      }
    } catch (e) {
      return null;
    }
  }
}
