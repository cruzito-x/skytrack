import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:skytrack/utils/sidebar.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Feedback', style: TextStyle(fontSize: 16)),
        backgroundColor: Colors.white,
        foregroundColor: const Color.fromRGBO(0, 51, 102, 1),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,
              color: Color.fromRGBO(0, 51, 102, 1)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      endDrawer: const Sidebar(),
      body: SingleChildScrollView(  // Envuelve el contenido en un ScrollView
        child: Padding(
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
              _buildPieChart(), // Pie chart section
              const SizedBox(height: 20),
              const Text(
                'Recomendaciones',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _buildRecommendations(), // Recommendation section
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSurveyOptions() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: _buildSurveyButton('Muy útil')),
            const SizedBox(width: 10),
            Expanded(child: _buildSurveyButton('Útil')),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: _buildSurveyButton('Poco útil')),
            const SizedBox(width: 10),
            Expanded(child: _buildSurveyButton('Nada útil')),
          ],
        ),
      ],
    );
  }

  Widget _buildSurveyButton(String label) {
    return SizedBox(
      height: 50, // Height for the buttons
      child: ElevatedButton(
        onPressed: () {
          // Action for each button
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.lightBlueAccent,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          textStyle: const TextStyle(fontSize: 14),
        ),
        child: Text(label),
      ),
    );
  }

  Widget _buildPieChart() {
    return SizedBox(
      height: 250, // Size of the chart
      child: PieChart(
        PieChartData(
          sections: _getPieChartSections(),
          borderData: FlBorderData(show: false),
          centerSpaceRadius: 50, // Adjusted center space
          sectionsSpace: 0, // No spacing between sections
        ),
      ),
    );
  }

  List<PieChartSectionData> _getPieChartSections() {
    return [
      PieChartSectionData(
        color: const Color(0xff0293ee),
        value: 56.3,
        title: 'Muy útil\n56.3%',
        radius: 70, // Uniform radius
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
        radius: 70, // Uniform radius
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
        radius: 70, // Uniform radius
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
        radius: 70, // Uniform radius
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ];
  }

  Widget _buildRecommendations() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildRecommendationItem('Utiliza ropa ligera durante los días calurosos'),
        _buildRecommendationItem('Recuerda cargar un paraguas durante los días nublados'),
        _buildRecommendationItem('Evita a toda costa salir durante tormentas eléctricas'),
      ],
    );
  }

  Widget _buildRecommendationItem(String recommendation) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(0, 51, 102, 1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          recommendation,
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
      ),
    );
  }
}





