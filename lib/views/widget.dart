import 'package:flutter/material.dart';
import 'package:skytrack/utils/sidebar.dart';

class WidgetPage extends StatelessWidget {
  const WidgetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Widgets', style: TextStyle(fontSize: 16)),
          backgroundColor: Colors.white,
          foregroundColor: const Color.fromRGBO(0, 51, 102, 1),
        ),
        endDrawer: const Sidebar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                climaSection(),
                const SizedBox(height: 20),
                botonesMas(),
              ],
            ),
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
          const Text(
            'Clima',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(0, 51, 102, 1),
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: List.generate(4, (index) {
              return Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    'assets/images/image $index.png',
                    fit: BoxFit.cover,
                  ),
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
      padding: const EdgeInsets.only(top: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(color: Colors.yellow),
          const SizedBox(height: 16),
          const Text(
            'Más',
            style: TextStyle(
              fontSize: 18,
              color: Color.fromARGB(255, 124, 124, 124),
            ),
          ),
          const SizedBox(height: 10),
          ListTile(
            title: const Text(
              'Pronóstico extendido',
              style: TextStyle(
                color: Color.fromRGBO(0, 51, 102, 1),
                fontSize: 16,
              ),
            ),
            trailing: const Icon(Icons.arrow_forward_ios,
                color: Color.fromRGBO(0, 51, 102, 1)),
            onTap: () {
              // Acción cuando el botón es presionado
            },
          ),
          const SizedBox(height: 10),
          ListTile(
            title: const Text(
              'Temas adicionales',
              style: TextStyle(
                color: Color.fromRGBO(0, 51, 102, 1),
                fontSize: 16,
              ),
            ),
            trailing: const Icon(Icons.arrow_forward_ios,
                color: Color.fromRGBO(0, 51, 102, 1)),
            onTap: () {
              // Acción cuando el botón es presionado
            },
          ),
        ],
      ),
    );
  }

  // Drawer item builder
}
