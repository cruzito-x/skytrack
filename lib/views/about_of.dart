import 'package:flutter/material.dart';
import 'package:skytrack/main.dart';
import 'package:skytrack/utils/sidebar.dart';

class AboutOfPage extends StatelessWidget {
  const AboutOfPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Acerca de', style: TextStyle(fontSize: 16)),
        backgroundColor: Colors.white,
        foregroundColor: const Color.fromRGBO(0, 51, 102, 1),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,
              color: Color.fromRGBO(0, 51, 102, 1)),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const MainApp()),
            );
          },
        ),
      ),
      endDrawer: const Sidebar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Desarrolladores:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(0, 51, 102, 1),
                ),
              ),
            ),
            const SizedBox(height: 10),
            _buildDeveloperRow(
                'Abarca Henríquez, José Alexander', '25-0675-2020'),
            _buildDeveloperRow(
                'Aguilar Hernández, Esaú Alexander', '25-2937-2020'),
            _buildDeveloperRow(
                'Alvarado Flores, Daniel Alejandro', '25-1664-2020'),
            _buildDeveloperRow('Cruz Cruz, David Alejandro', '25-1306-2020'),
            const SizedBox(height: 20),
            _buildDivider(),
            const Center(
              child: Text(
                'Colaboraciones:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(0, 51, 102, 1),
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Desarrollo de UI/UX',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(0, 51, 102, 1),
                fontSize: 16,
              ),
            ),
            _buildDeveloperRow(
                'Alvarado Flores, Daniel Alejandro', '25-1664-2020'),
            _buildDeveloperRow('Cruz Cruz, David Alejandro', '25-1306-2020'),
            const SizedBox(height: 20),
            const Text(
              'Desarrollo de Base de datos',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(0, 51, 102, 1),
                fontSize: 16,
              ),
            ),
            _buildDeveloperRow(
                'Abarca Henríquez, José Alexander', '25-0675-2020'),
            _buildDeveloperRow(
                'Aguilar Hernández, Esaú Alexander', '25-2937-2020'),
            const SizedBox(height: 20),
            _buildDivider(),
            _buildInfoRow('Año:', '2024'),
            _buildInfoRow('App:', 'SkyTrack'),
            _buildInfoRow('Materia:', 'ETPS3 - I'),
            _buildInfoRow('Sección:', '01'),
            const Spacer(),
            const Center(
              child: Text(
                '© SkyTrack - 2024\nTodos los derechos reservados',
                style: TextStyle(
                  fontSize: 14,
                  color: Color.fromRGBO(0, 51, 102, 1),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeveloperRow(String name, String carnet) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            name,
            style: const TextStyle(
              color: Color.fromRGBO(0, 51, 102, 1),
            ),
            textAlign: TextAlign.left,
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            carnet,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String title, String info) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            title,
            style: const TextStyle(
              color: Color.fromRGBO(0, 51, 102, 1),
              fontSize: 16, // Tamaño regular
            ),
            textAlign: TextAlign.left,
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            info,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold, // Negrita
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return const Divider(
      color: Colors.grey,
      thickness: 1,
      height: 20,
    );
  }
}
