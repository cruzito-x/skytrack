import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:skytrack/utils/sidebar.dart';

class FeedbackPage extends StatefulWidget {
  // Cambiado de SurveyPage a FeedbackPage
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() =>
      _FeedbackPageState(); // Cambiado de _SurveyPageState a _FeedbackPageState
}

class _FeedbackPageState extends State<FeedbackPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title:
            const Text('Comunidad y feedback', style: TextStyle(fontSize: 16)),
        backgroundColor: Colors.white,
        foregroundColor: const Color.fromRGBO(0, 51, 102, 1),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,
              color: Color.fromRGBO(0, 51, 102, 1)),
          onPressed: () {
            Navigator.pop(context); // Navega hacia atrás
          },
        ),
      ),
      endDrawer: const Sidebar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Encuesta rápida',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              '¿Qué tan útil encuentras la app?',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            _buildSurveyOptions(),
            const SizedBox(height: 20),
            const Text(
              'Nuestros usuarios opinan',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _buildPieChart(), // Añadimos el gráfico circular
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSurveyOptions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildSurveyButton('Muy útil'),
        _buildSurveyButton('Útil'),
        _buildSurveyButton('Poco útil'),
        _buildSurveyButton('Nada útil'),
      ],
    );
  }

  Widget _buildSurveyButton(String label) {
    return ElevatedButton(
      onPressed: () {
        // Acción para cada botón
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.lightBlueAccent,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        textStyle: const TextStyle(fontSize: 14),
      ),
      child: Text(label),
    );
  }

  Widget _buildPieChart() {
    return PieChart(
      PieChartData(
        sections: _getPieChartSections(),
        borderData: FlBorderData(show: false),
        centerSpaceRadius: 40, // Espacio en el centro del gráfico
        sectionsSpace: 2, // Espacio entre las secciones del gráfico
      ),
    );
  }

  List<PieChartSectionData> _getPieChartSections() {
    return [
      PieChartSectionData(
        color: const Color(0xff0293ee),
        value: 56.3,
        title: 'Muy útil\n56.3%',
        radius: 60,
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      PieChartSectionData(
        color: const Color(0xfff8b250),
        value: 25.1,
        title: 'Útil\n25.1%',
        radius: 50,
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      PieChartSectionData(
        color: const Color(0xffff5182),
        value: 12.7,
        title: 'Poco útil\n12.7%',
        radius: 50,
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      PieChartSectionData(
        color: const Color(0xff13d38e),
        value: 7.7,
        title: 'Nada útil\n7.7%',
        radius: 40,
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ];
  }
}
