import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(width: 8), // Espacio entre el Lottie y el texto
            Text(
              'Configuración',
              style: TextStyle(fontSize: 14),
            )
          ],
        ),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            const Text('No notifications yet.'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate back to the main screen
                Navigator.popUntil(
                  context,
                  (route) =>
                      route.isFirst, // Go back to the first route (main screen)
                );
              },
              child: const Text('View All Notifications'),
            ),
          ],
        ),
      ),
    );
  }
}
