import 'package:flutter/material.dart';

void main() {
  runApp(MiApp());
}

class MiApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: PantallaLogin(),
      ),
    );
  }
}

class PantallaLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200], // Fondo claro
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Padding para responsividad
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Imagen del logo en un contenedor circular
              Center(
                child: ClipOval(
                  child: Image.asset(
                    'utils/images/logo.png',  // Reemplaza con la ruta correcta de tu logo
                    height: 100,        // Tamaño ajustable de la imagen
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 30), // Espacio entre logo y campos de texto

              // Campo de usuario con solo borde inferior gris
              TextField(
                decoration: InputDecoration(
                  labelText: 'Usuario',
                  labelStyle: TextStyle(color: Color.fromRGBO(0, 51, 102, 1)), // Color del texto
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 2), // Borde gris por defecto
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 2), // Borde gris en foco
                  ),
                ),
              ),
              SizedBox(height: 10), // Espacio entre usuario y contraseña

              // Campo de contraseña con solo borde inferior gris
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  labelStyle: TextStyle(color: Color.fromRGBO(0, 51, 102, 1)), // Color del texto
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 2), // Borde gris por defecto
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 2), // Borde gris en foco
                  ),
                ),
              ),
              SizedBox(height: 20), // Espacio entre contraseña y botones

              // Botón de Ingresar con borde azul oscuro y texto blanco
              OutlinedButton(
                onPressed: () {
                  // Lógica para el login
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Color.fromRGBO(0, 51, 102, 1), width: 2), // Borde azul oscuro
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Bordes redondeados
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
                child: Text(
                  'INGRESAR',
                  style: TextStyle(
                    color: Color.fromRGBO(0, 51, 102, 1), // Color del texto azul oscuro
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 10), // Espacio entre los botones

              // Botón de Registrarse con borde azul oscuro y texto blanco
              OutlinedButton(
                onPressed: () {
                  // Lógica para el registro
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Color.fromRGBO(0, 51, 102, 1), width: 2), // Borde azul oscuro
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Bordes redondeados
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
                child: Text(
                  'REGISTRARSE',
                  style: TextStyle(
                    color: Color.fromRGBO(0, 51, 102, 1), // Color del texto azul oscuro
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
