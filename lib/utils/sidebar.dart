import 'package:flutter/material.dart';
import 'package:skytrack/views/notifications.dart';
import 'package:skytrack/views/widget.dart';
import 'package:skytrack/views/settings.dart';
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
                // Imagen con bordes redondeados
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
                  'Skytrack',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          _buildDrawerItem(Icons.home, 'Home', context),
          _buildDrawerItem(
              Icons.notifications, 'Alertas y notificaciones', context),
          _buildDrawerItem(Icons.widgets, 'Widgets', context),
          _buildDrawerItem(Icons.feed, 'Feedback', context),
          _buildDrawerItem(Icons.settings, 'Configuración', context),
          _buildDrawerItem(Icons.info, 'Acerca de', context),
        ],
      ),
    );
  }

  // Drawer item builder para navegación
  Widget _buildDrawerItem(IconData icon, String title, BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: const Color.fromRGBO(0, 51, 102, 1)),
      title: Text(
        title,
        style:
            const TextStyle(fontSize: 16, color: Color.fromRGBO(0, 51, 102, 1)),
      ),
      onTap: () {
        Navigator.of(context).pop(); // Cierra el Drawer

        if (title == 'Home') {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const MainApp()),
          );
        }

        if (title == 'Alertas y notificaciones') {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const NotificationsPage()),
          );
        }

        if (title == 'Widgets') {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const WidgetPage()),
          );
        }

        if (title == 'Configuración') {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const SettingsPage()),
          );
        }
        // Agrega otras rutas aquí si es necesario
      },
    );
  }
}
