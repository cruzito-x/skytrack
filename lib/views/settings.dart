import 'package:flutter/material.dart';
import '../styles/style.dart';
import 'package:skytrack/utils/sidebar.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppStyles.lightTheme, // Usamos el tema desde los estilos
      home: const SettingsPage(),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Configuración',
          style: TextStyle(fontSize: 16),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color.fromRGBO(0, 51, 102, 1),
      ),
      endDrawer: const Sidebar(),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Padding(
              padding: AppStyles.pagePadding, // Padding general desde estilos
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionTitle(title: 'General'),
                  SettingsItem(
                    title: 'Personalización',
                    onTap: () {
                      // Acción programable
                      print('Navegar a Personalización');
                    },
                  ),
                  SettingsItem(
                    title: 'Ubicación',
                    onTap: () {
                      // Acción programable
                      print('Navegar a Ubicación');
                    },
                  ),
                  SettingsItem(
                    title: 'Establecer unidades de medida',
                    onTap: () {
                      // Acción programable
                      print('Navegar a Cambiar unidades de medida');
                    },
                  ),
                  SettingsSwitchItem(
                    title: 'Activar notificaciones',
                    value: true,
                    onChanged: (value) {
                      // Acción programable
                      print('Activar notificaciones: $value');
                    },
                  ),
                  SettingsSwitchItem(
                    title: 'Alertas Meteorológicas',
                    value: true,
                    onChanged: (value) {
                      // Acción programable
                      print('Alertas Meteorológicas: $value');
                    },
                  ),
                  const Divider(),
                  const SectionTitle(title: 'Más'),
                  SettingsItem(
                    title: 'Estaciones Climáticas',
                    onTap: () {
                      // Acción programable
                      print('Navegar a Estaciones Climáticas');
                    },
                  ),
                  SettingsSwitchItem(
                    title: 'Modo oscuro',
                    value: false,
                    onChanged: (value) {
                      // Acción programable
                      print('Modo oscuro: $value');
                    },
                  ),
                  SettingsItem(
                    title: 'Idioma',
                    onTap: () {
                      // Acción programable
                      print('Navegar a Idioma');
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppStyles.sectionPadding, // Padding de sección desde estilos
      child: Row(
        children: [
          Text(
            title,
            style: AppStyles.sectionTitleStyle, // Estilo de título de sección
          ),
        ],
      ),
    );
  }
}

class SettingsItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const SettingsItem({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: AppStyles.settingsItemStyle, // Estilo de ítem de configuración
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap, // Acción programable
    );
  }
}

class SettingsSwitchItem extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const SettingsSwitchItem({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: AppStyles.settingsItemStyle, // Estilo de ítem con interruptor
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged, // Acción programable
        activeColor: Colors.blue,
      ),
    );
  }
}
