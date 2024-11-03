import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:skytrack/views/notifications.dart';
import 'package:skytrack/views/feedback.dart';
import 'package:skytrack/views/settings.dart';
import 'package:skytrack/views/about_of.dart';
import 'package:skytrack/main.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color.fromRGBO(0, 51, 102, 1),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.asset(
                    'utils/images/logo.png',
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'SkyTrack',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          _buildDrawerItem(Icons.sunny, 'Inicio', context),
          _buildDrawerItem(
              Icons.notifications, 'Alertas y Notificaciones', context),
          _buildDrawerItem(Icons.chat, 'Feedback', context),
          _buildDrawerItem(Icons.settings, 'Configuración', context),
          _buildDrawerItem(Icons.info, 'Acerca de', context),
          if (FirebaseAuth.instance.currentUser != null)
            _buildDrawerItem(Icons.logout_rounded, 'Cerrar Sesión', context),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: const Color.fromRGBO(0, 51, 102, 1)),
      title: Text(
        title,
        style:
            const TextStyle(fontSize: 16, color: Color.fromRGBO(0, 51, 102, 1)),
      ),
      onTap: () async {
        Navigator.of(context).pop(); // Cierra el Drawer

        if (title == 'Inicio') {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const MainApp()),
          );
        }

        if (title == 'Alertas y Notificaciones') {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const NotificationsPage()),
          );
        }

        if (title == 'Feedback') {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const FeedbackPage()),
          );
        }

        if (title == 'Configuración') {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const SettingsPage()),
          );
        }

        if (title == 'Acerca de') {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AboutOfPage()),
          );
        }

        if (title == 'Cerrar Sesión') {
          await FirebaseAuth.instance.signOut();

          // ignore: use_build_context_synchronously
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const MainApp()),
          );
        }
      },
    );
  }
}
