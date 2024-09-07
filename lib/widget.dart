import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: Text('Widgets'),
          backgroundColor: Colors.white,
          foregroundColor: const Color.fromRGBO(0, 51, 102, 1),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0), // Margen de 10 px
            child: Column(
              children: [
                encabezado(),
                SizedBox(height: 20), // Añade más espacio entre encabezado y sección de clima
                climaSection(),
                SizedBox(height: 20), // Más espacio entre clima y botones
                botonesMas(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Encabezado
  Widget encabezado() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.yellow, width: 2),
        ),
      ),
      child: Center(
        child: Text(
          'Widgets',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: const Color.fromRGBO(0, 51, 102, 1),
          ),
        ),
      ),
    );
  }

  // Sección Clima
  Widget climaSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Clima',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: const Color.fromRGBO(0, 51, 102, 1),
            ),
          ),
          SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: List.generate(4, (index) {
              return Card(
                elevation: 4,
                child: Image.asset(
                  'assets/images/image $index.png', // Asegúrate de agregar tus imágenes en esta ruta
                  fit: BoxFit.cover,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  // Botones "Más"
  Widget botonesMas() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(color: Colors.yellow),
          Text(
            'Más',
            style: TextStyle(
              fontSize: 18,
              color: const Color.fromARGB(255, 124, 124, 124),
            ),
          ),
          SizedBox(height: 10), // Espacio entre el título 'Más' y el primer botón
          ListTile(
            title: Text(
              'Pronóstico extendido',
              style: TextStyle(
                color: const Color.fromRGBO(0, 51, 102, 1),
                fontSize: 16,
              ),
            ),
            trailing: Icon(Icons.arrow_forward_ios, color: const Color.fromRGBO(0, 51, 102, 1)),
            onTap: () {
              // Acción cuando el botón es presionado
            },
          ),
          SizedBox(height: 10), // Más espacio entre botones
          ListTile(
            title: Text(
              'Temas adicionales',
              style: TextStyle(
                color: const Color.fromRGBO(0, 51, 102, 1),
                fontSize: 16,
              ),
            ),
            trailing: Icon(Icons.arrow_forward_ios, color: const Color.fromRGBO(0, 51, 102, 1)),
            onTap: () {
              // Acción cuando el botón es presionado
            },
          ),
        ],
      ),
    );
  }
}
