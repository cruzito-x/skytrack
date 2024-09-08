import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:skytrack/main.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            const Text('No notifications yet.'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle notification tap
                // Example: Navigate to a notification detail page
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const MainApp()));
              },
              child: const Text('View All Notifications'),
            )
          ],
        ),
      ),
    );
  }
}
