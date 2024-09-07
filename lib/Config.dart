import 'package:flutter/material.dart';
import 'style.dart'; // Importamos los estilos separados

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Configuraciones',
      theme: AppStyles.lightTheme, // Usamos el tema desde los estilos
      home: SettingsPage(),
    );
  }
}

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configuraciones'),
        leading: Icon(Icons.settings),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Padding(
              padding: AppStyles.pagePadding, // Padding general desde estilos
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionTitle(title: 'General'),
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
                    title: 'Cambiar unidades de medida',
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
                  Divider(),
                  SectionTitle(title: 'Más'),
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

  const SectionTitle({required this.title});

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

  const SettingsItem({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: AppStyles.settingsItemStyle, // Estilo de ítem de configuración
      ),
      trailing: Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap, // Acción programable
    );
  }
}

class SettingsSwitchItem extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const SettingsSwitchItem({
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
