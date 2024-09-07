import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final hour = now.hour;
    String greeting;

    if (hour < 12) {
      greeting = '¡Buenos días!';
    } else if (hour < 18) {
      greeting = '¡Buenas tardes!';
    } else {
      greeting = '¡Buenas noches!';
    }

    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('San Salvador, SV', style: TextStyle(fontSize: 14)),
          actions: [
            Builder(
              builder: (BuildContext context) => IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openEndDrawer(); // Opens the end drawer
                },
              ),
            ),
          ],
          backgroundColor: Colors.white,
          foregroundColor: const Color.fromRGBO(0, 51, 102, 1),
        ),
        endDrawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(0, 51, 102, 1),
                ),
                child: Text(
                  'Skytrack',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.home,
                    color: Color.fromRGBO(0, 51, 102, 1)),
                title: const Text('Home',
                    style: TextStyle(
                        fontSize: 16, color: Color.fromRGBO(0, 51, 102, 1))),
                onTap: () {
                  Navigator.pop(context); // Close the drawer
                },
              ),
              ListTile(
                leading: const Icon(Icons.notifications,
                    color: Color.fromRGBO(0, 51, 102, 1)),
                title: const Text('Alertas y notificaciones',
                    style: TextStyle(
                        fontSize: 16, color: Color.fromRGBO(0, 51, 102, 1))),
                onTap: () {
                  Navigator.pop(context); // Close the drawer
                },
              ),
              ListTile(
                leading: const Icon(Icons.feed,
                    color: Color.fromRGBO(0, 51, 102, 1)),
                title: const Text('Feedback',
                    style: TextStyle(
                        fontSize: 16, color: Color.fromRGBO(0, 51, 102, 1))),
                onTap: () {
                  Navigator.pop(context); // Close the drawer
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings,
                    color: Color.fromRGBO(0, 51, 102, 1)),
                title: const Text('Configuración',
                    style: TextStyle(
                        fontSize: 16, color: Color.fromRGBO(0, 51, 102, 1))),
                onTap: () {
                  Navigator.pop(context); // Close the drawer
                },
              ),
              ListTile(
                leading: const Icon(Icons.info,
                    color: Color.fromRGBO(0, 51, 102, 1)),
                title: const Text('Acerca de',
                    style: TextStyle(
                        fontSize: 16, color: Color.fromRGBO(0, 51, 102, 1))),
                onTap: () {
                  Navigator.pop(context); // Close the drawer
                },
              ),
            ],
          ),
        ),
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
                    SvgPicture.asset(
                      'assets/images/clear-day.svg',
                      width: 36,
                      height: 36,
                    ),
                  ]),
                ),
                const SizedBox(height: 20),
                // Weather icon, date and temperature
                Center(
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        'assets/images/partly-cloudy-day-fog.svg',
                        width: 206,
                        height: 206,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Vie. 16 Ago. | 10:20 AM',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
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
                // Weather details (Rain, Wind, Humidity, Temperature)
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
                // Text for the 7-day forecast
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
                // Today's forecast (5 hourly forecast)
                SizedBox(
                  height: 120,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildHourlyForecast('12:00 mn', '33° C',
                          'assets/images/partly-cloudy-day-fog.svg', now),
                      _buildHourlyForecast('4:00 am', '30° C',
                          'assets/images/partly-cloudy-day-fog.svg', now),
                      _buildHourlyForecast('8:00 am', '27° C',
                          'assets/images/partly-cloudy-day-fog.svg', now),
                      _buildHourlyForecast('12:00 md', '25° C',
                          'assets/images/partly-cloudy-day-fog.svg', now),
                      _buildHourlyForecast('04:00 pm', '22° C',
                          'assets/images/partly-cloudy-day-fog.svg', now),
                      _buildHourlyForecast('08:00 pm', '22° C',
                          'assets/images/partly-cloudy-day-fog.svg', now),
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
        Text(value, style: const TextStyle(fontSize: 16)),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  // Function to build hourly forecast
  Widget _buildHourlyForecast(
      String time, String temp, String svgPath, DateTime now) {
    final forecastTime = _parseTime(time);
    final isCurrent = forecastTime != null &&
        (forecastTime.isAfter(now.subtract(const Duration(hours: 4))) &&
            forecastTime.isBefore(now.add(const Duration(hours: 4))));

    return Container(
      width: 90,
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.only(right: 8.0), // Ensure spacing between cards
      decoration: BoxDecoration(
        color:
            isCurrent ? const Color.fromRGBO(0, 51, 102, 1) : Colors.grey[200],
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
          const SizedBox(height: 4),
          SvgPicture.asset(
            svgPath,
            width: 50,
            height: 50,
          ),
          const SizedBox(height: 4),
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
