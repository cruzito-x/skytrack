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
          actions: [
            Builder(
              builder: (BuildContext context) => IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openEndDrawer(); // Open left drawer
                },
              ),
            ),
          ],
        ),
        endDrawer: Drawer(
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
              _buildDrawerItem(Icons.notifications, 'Alertas y notificaciones', context),
              _buildDrawerItem(Icons.feed, 'Feedback', context),
              _buildDrawerItem(Icons.settings, 'Configuración', context),
              _buildDrawerItem(Icons.info, 'Acerca de', context),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                climaSection(),
                SizedBox(height: 20),
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
          Divider(color: Colors.yellow),
          SizedBox(height: 16),
          Text(
            'Más',
            style: TextStyle(
              fontSize: 18,
              color: const Color.fromARGB(255, 124, 124, 124),
            ),
          ),
          SizedBox(height: 10),
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
          SizedBox(height: 10),
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

  // Drawer item builder
  Widget _buildDrawerItem(IconData icon, String title, BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: const Color.fromRGBO(0, 51, 102, 1)),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          color: Color.fromRGBO(0, 51, 102, 1),
        ),
      ),
      onTap: () {
        Navigator.pop(context); 
      },
    );
  }
}
