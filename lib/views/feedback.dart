import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:skytrack/utils/sidebar.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  String selectedOption = '';
  final TextEditingController _commentController = TextEditingController();
  bool _isFirebaseInitialized = false;

  @override
  void initState() {
    super.initState();
    initializeFirebase();
  }

  Future<void> initializeFirebase() async {
    await Firebase.initializeApp();
    setState(() {
      _isFirebaseInitialized = true;
    });
  }

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
      body: _isFirebaseInitialized
          ? buildContent()
          : const Center(
              child:
                  CircularProgressIndicator()), // Muestra un indicador de carga hasta que Firebase se inicialice
    );
  }

  Widget buildContent() {
    return SingleChildScrollView(
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
            _buildPieChart(),
            const SizedBox(height: 20),
            const Text(
              'Recomendaciones',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildRecommendations(),
          ],
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
            Expanded(child: _buildSurveyButton('Muy útil', 1)),
            const SizedBox(width: 10),
            Expanded(child: _buildSurveyButton('Útil', 2)),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: _buildSurveyButton('Poco útil', 3)),
            const SizedBox(width: 10),
            Expanded(child: _buildSurveyButton('Nada útil', 4)),
          ],
        ),
      ],
    );
  }

  Widget _buildSurveyButton(String label, int value) {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          selectedOption = label;
          _showFeedbackModal(value);
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

  void _showFeedbackModal(int utilidadValue) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(16),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Bríndanos tu opinión',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.grey),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '¿Por qué nuestra app te parece $selectedOption?',
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _commentController,
                maxLength: 150,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Escribe aquí tu comentario...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                await _saveFeedbackToFirestore(utilidadValue);
                // ignore: use_build_context_synchronously
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(0, 51, 102, 1),
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              ),
              child: const Text(
                'Enviar comentarios',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveFeedbackToFirestore(int utilidadValue) async {
    if (!_isFirebaseInitialized) return;

    final String comentario = _commentController.text;
    final Map<String, dynamic> feedbackData = {
      'id_usuario': 1,
      'utilidad': utilidadValue,
      'comentario': comentario,
    };

    try {
      await FirebaseFirestore.instance
          .collection('comentarios')
          .add(feedbackData);
      _commentController.clear();
      // Show success toast
      Fluttertoast.showToast(
        msg: "Comentario añadido correctamente",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } catch (e) {
      // Show error toast
      Fluttertoast.showToast(
        msg: "Ha ocurrido un problema al guardar el comentario",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  Widget _buildPieChart() {
    return SizedBox(
      height: 250,
      child: PieChart(
        PieChartData(
          sections: _getPieChartSections(),
          borderData: FlBorderData(show: false),
          centerSpaceRadius: 50,
          sectionsSpace: 0,
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
        radius: 70,
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
        radius: 70,
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
        radius: 70,
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
        radius: 70,
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
        _buildRecommendationItem(
            'Utiliza ropa ligera durante los días calurosos'),
        _buildRecommendationItem(
            'Recuerda cargar un paraguas durante los días nublados'),
        _buildRecommendationItem(
            'Evita a toda costa salir durante tormentas eléctricas'),
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
