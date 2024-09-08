import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart';
import 'package:skytrack/views/settings.dart';
import 'package:skytrack/views/notifications.dart';
import 'package:skytrack/utils/sidebar.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final DateFormat formatter = DateFormat('E dd MMM');
    final hour = now.hour;
    final String formattedTime = DateFormat('hh:mm a').format(now);
    final String formattedDate = formatter.format(now);
    String greeting;
    String star = '';

    if (hour < 12) {
      greeting = '¡Buenos días!';
      star = 'assets/images/json/clear-day.json';
    } else if (hour < 18) {
      greeting = '¡Buenas tardes!';
    } else {
      greeting = '¡Buenas noches!';
      star = 'assets/images/json/clear-night.json';
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
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
                'assets/images/json/pointer.json', // Asegúrate de reemplazar esto con la ruta correcta a tu archivo Lottie
                width: 30, // Ajusta el tamaño según sea necesario
                height: 30,
              ),
            ],
          ),
          actions: [
            Builder(
              builder: (BuildContext context) => IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openEndDrawer(); // Open left drawer
                },
              ),
            ),
          ],
          backgroundColor: Colors.white,
          foregroundColor: const Color.fromRGBO(0, 51, 102, 1),
        ),
        endDrawer: const Sidebar(), // Usa el SidebarMenu aquí
        body: SingleChildScrollView(
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
                        style:
                            const TextStyle(fontSize: 16, color: Colors.grey),
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
                        'assets/images/thunderstorms-extreme-rain.svg',
                        '22%',
                        'Lluvia'),
                    _buildWeatherDetail(
                        'assets/images/wind.svg', '12 Km/H', 'Viento'),
                    _buildWeatherDetail(
                        'assets/images/humidity.svg', '17%', 'Humedad'),
                    _buildWeatherDetail(
                        'assets/images/thermometer-glass-celsius.svg',
                        '12°C | 38°C',
                        'Temperatura(s)'),
                  ],
                ),
                const SizedBox(height: 40),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Hoy',
                      style: TextStyle(
                          fontSize: 14,
                          color: Color.fromRGBO(0, 51, 102, 1),
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Próximos 7 días',
                      style: TextStyle(
                          fontSize: 14,
                          color: Color.fromRGBO(0, 51, 102, 1),
                          fontWeight: FontWeight.bold),
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
      ),
    );
  }

  // Function to build weather details (Lluvia, Viento, etc.)
  Widget _buildWeatherDetail(String svgUrl, String value, String label) {
    return Column(
      children: [
        SvgPicture.asset(svgUrl, width: 30, height: 30),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }

  // Function to build hourly forecast
  Widget _buildHourlyForecast(
      String time, String temperature, String lottieUrl, DateTime now) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 8.0),
      child: Column(
        children: [
          Lottie.asset(
            lottieUrl,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 8),
          Text(
            time,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          Text(
            temperature,
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
