import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:skytrack/main.dart';
import 'package:skytrack/utils/sidebar.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'dart:convert';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  bool _climaSevero = false;
  bool _cambiosRepentinos = false;
  bool _isLoading = true;
  Position? _currentPosition;

  final List<Map<String, String>> _alerts = [];

  @override
  void initState() {
    super.initState();
    _fetchUserLocation();
  }

  Future<void> _fetchUserLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
      }

      _currentPosition = await Geolocator.getCurrentPosition();
      fetchNotifications();
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  Future<void> fetchNotifications() async {
    setState(() {
      _isLoading = true;
    });

    final List<Map<String, String>> newAlerts = [];

    try {
      if (_currentPosition != null) {
        final lat = _currentPosition!.latitude;
        final lon = _currentPosition!.longitude;
        final earthquakeResponse = await http.get(
          Uri.parse(
              'https://earthquake.usgs.gov/fdsnws/event/1/query?format=geojson&latitude=$lat&longitude=$lon&maxradius=500&limit=10'),
        );

        if (earthquakeResponse.statusCode == 200) {
          final earthquakeData = json.decode(earthquakeResponse.body);
          for (var feature in earthquakeData['features']) {
            final properties = feature['properties'];
            final earthquakeAlert = {
              'title': 'Terremoto ${properties['mag']}M',
              'description':
                  'Ubicación: ${properties['place']}, Profundidad: ${feature['geometry']['coordinates'][2]} km',
              'lottieAsset': 'assets/images/json/earthquake.json',
              'time': DateTime.fromMillisecondsSinceEpoch(properties['time'])
                  .toLocal()
                  .toString(),
            }.map((key, value) => MapEntry(
                key,
                value
                    .toString())); // Asegurarse de que todos los valores sean Strings

            if (_cambiosRepentinos) {
              newAlerts.add(earthquakeAlert);
            }
          }
        }
      }

      if (_currentPosition != null) {
        final weatherResponse = await http.get(
          Uri.parse(
              'https://api.tomorrow.io/v4/weather/alerts?location=${_currentPosition!.latitude},${_currentPosition!.longitude}'),
          headers: {'apikey': 'R5nrdr3rI9QrAy3IjB5w3psC0BkubPIS'},
        );
        if (weatherResponse.statusCode == 200) {
          final weatherData = json.decode(weatherResponse.body);
          for (var alert in weatherData['alerts']) {
            final weatherAlert = {
              'title': alert['headline'],
              'description': alert['description'],
              'lottieAsset': 'assets/images/json/weather-alert.json',
              'time': alert['start'].toString(),
            }.map((key, value) => MapEntry(key, value.toString()));

            if (_climaSevero) {
              newAlerts.add(weatherAlert);
            }
          }
        }
      }
    } catch (e) {
      print("Error fetching notifications: $e");
    }

    setState(() {
      _isLoading = false;
      _alerts.clear();
      _alerts.addAll(newAlerts.take(15));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Alertas y Notificaciones',
            style: TextStyle(fontSize: 16)),
        backgroundColor: Colors.white,
        foregroundColor: const Color.fromRGBO(0, 51, 102, 1),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,
              color: Color.fromRGBO(0, 51, 102, 1)),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const MainApp()),
            );
          },
        ),
      ),
      endDrawer: const Sidebar(),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Color.fromRGBO(0, 51, 102, 1),
                    ),
                  )
                : _alerts.isEmpty
                    ? const Center(
                        child: Text("No hay datos para mostrar",
                            style: TextStyle(fontSize: 16)),
                      )
                    : SingleChildScrollView(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _alerts.map((alert) {
                            return Column(
                              children: [
                                _buildAlertCard(
                                    alert['title']!,
                                    alert['description']!,
                                    alert['lottieAsset']!,
                                    alert['time']!),
                                const SizedBox(height: 16.0),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            child: const Divider(),
          ),
          const SizedBox(height: 2),
          const Padding(
            padding: EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // children: [
              //   const Text('Configuración de notificaciones',
              //       style:
              //           TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              //   const SizedBox(height: 8),
              //   _buildSwitch('Clima severo', _climaSevero, (value) {
              //     setState(() {
              //       _climaSevero = value;
              //       fetchNotifications();
              //     });
              //   }),
              //   const SizedBox(height: 6),
              //   _buildSwitch('Cambios repentinos', _cambiosRepentinos, (value) {
              //     setState(() {
              //       _cambiosRepentinos = value;
              //       fetchNotifications();
              //     });
              //   }),
              //   const SizedBox(height: 20),
              //   Center(
              //     child: ElevatedButton(
              //       onPressed: () {
              //         // Save notification preferences action
              //       },
              //       style: ElevatedButton.styleFrom(
              //         backgroundColor: const Color.fromRGBO(0, 51, 102, 1),
              //         foregroundColor: Colors.white,
              //         alignment: Alignment.bottomCenter,
              //         padding: const EdgeInsets.symmetric(
              //             vertical: 16, horizontal: 125),
              //         textStyle:
              //             const TextStyle(fontSize: 14, color: Colors.white),
              //       ),
              //       child: const Text('Guardar cambios'),
              //     ),
              //   ),
              // ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertCard(
      String title, String description, String lottieAsset, String time) {
    return Card(
      elevation: 2.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Lottie.asset(lottieAsset,
                    width: 40, height: 40), // Lottie animation
                const SizedBox(width: 16.0),
                Text(title,
                    style: const TextStyle(
                        fontSize: 18.0,
                        color: Color.fromRGBO(0, 51, 102, 1),
                        fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8.0),
            Text(description,
                style: const TextStyle(color: Color.fromRGBO(0, 51, 102, 1))),
            const SizedBox(height: 8.0),
            Align(
              alignment: Alignment.bottomRight,
              child: Text('Emitido: $time',
                  style: const TextStyle(
                      fontSize: 14.0, color: Color.fromRGBO(0, 51, 102, 1))),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitch(String label, bool value, ValueChanged<bool> onChanged) {
    return Row(
      children: [
        Text(label, style: const TextStyle(fontSize: 16.0)),
        const Spacer(),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.blue,
        ),
      ],
    );
  }
}
