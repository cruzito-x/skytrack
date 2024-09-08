import 'package:flutter/material.dart';

class AppStyles {
  // Estilo para el tema de la aplicación
  static final ThemeData lightTheme = ThemeData(
    primarySwatch: Colors.blue,
    brightness: Brightness.light,
    appBarTheme: AppBarTheme(
      color: Colors.white,
      foregroundColor: Colors.blue[900],
      elevation: 0,
    ),
  );

  // Padding general para la página
  static const pagePadding = EdgeInsets.all(16.0);

  // Padding para las secciones
  static const sectionPadding = EdgeInsets.symmetric(vertical: 8.0);

  // Estilo para el título de las secciones
  static const TextStyle sectionTitleStyle = TextStyle(
    color: Colors.grey,
    fontWeight: FontWeight.bold,
  );

  // Estilo para los ítems de configuración
  static const TextStyle settingsItemStyle = TextStyle(
      color: Color.fromRGBO(0, 51, 102, 1),
      fontSize: 16,
      fontWeight: FontWeight.w400);
}
