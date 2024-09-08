import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../styles/style.dart';
import 'package:skytrack/utils/sidebar.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  bool _climaSevero = false;
  bool _cambiosRepentinos = false;

  final List<Map<String, String>> _alerts = [
    {
      'title': 'Tormenta severa',
      'description': 'Lluvias fuertes esperadas a partir de las 2:00 pm.',
      'lottieAsset': 'assets/images/json/storm.json',
      'time': '10:25 am',
    },
    {
      'title': 'Ola de calor',
      'description': 'Temperaturas extremas durante la tarde.',
      'lottieAsset': 'assets/images/json/hot.json',
      'time': '07:45 am',
    },
    {
      'title': 'Tormenta moderada',
      'description': 'Lluvias esperadas para la noche.',
      'lottieAsset': 'assets/images/json/rain-night.json',
      'time': '10:32 pm',
    },
    {
      'title': 'Frente frío',
      'description': 'Se espera un frente frío proveniente del sur.',
      'lottieAsset': 'assets/images/json/cold.json',
      'time': '08:25 pm',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Alertas y Notificaciones',
            style: TextStyle(fontSize: 16)),
        backgroundColor: Colors.white,
        foregroundColor: const Color.fromRGBO(0, 51, 102, 1),
      ),
      endDrawer: const Sidebar(),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _alerts.map((alert) {
                  return Column(
                    children: [
                      _buildAlertCard(alert['title']!, alert['description']!,
                          alert['lottieAsset']!, alert['time']!),
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
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Configuración de notificaciones',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                _buildSwitch('Clima severo', _climaSevero, (value) {
                  setState(() {
                    _climaSevero = value;
                  });
                }),
                const SizedBox(height: 6),
                _buildSwitch('Cambios repentinos', _cambiosRepentinos, (value) {
                  setState(() {
                    _cambiosRepentinos = value;
                  });
                }),
                const SizedBox(height: 20),
                Center(
                  // Center the button
                  child: ElevatedButton(
                    onPressed: () {
                      // Acción al presionar el botón "Guardar cambios"
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(0, 51, 102, 1),
                      foregroundColor: Colors.white,
                      alignment: Alignment.bottomCenter,
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 125),
                      textStyle:
                          const TextStyle(fontSize: 14, color: Colors.white),
                    ),
                    child: const Text('Guardar cambios'),
                  ),
                ),
              ],
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
          activeColor: Colors.blue, // Match the style from settings.dart
        ),
      ],
    );
  }
}
