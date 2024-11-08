import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:skytrack/main.dart';
import 'package:skytrack/utils/login.dart';
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
  final List<int> _ratingsCount = [0, 0, 0, 0];

  @override
  void initState() {
    super.initState();
    initializeFirebase();
  }

  Future<void> initializeFirebase() async {
    setState(() => _isFirebaseInitialized = false);
    await Firebase.initializeApp();
    setState(() => _isFirebaseInitialized = true);
    await fetchFeedbackData();
  }

  Future<void> fetchFeedbackData() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('comentarios').get();
      for (var doc in snapshot.docs) {
        int? utilidad = doc['utilidad'];
        if (utilidad != null && utilidad >= 1 && utilidad <= 4) {
          _ratingsCount[utilidad - 1]++;
        }
      }
      setState(() {});
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error fetching feedback data",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
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
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const MainApp()),
            );
          },
        ),
      ),
      endDrawer: const Sidebar(),
      body: _isFirebaseInitialized
          ? buildContent()
          : const Center(child: CircularProgressIndicator()),
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
        onPressed: () async {
          User? user = FirebaseAuth.instance.currentUser;
          if (user == null) {
            _showLoginModal();
          } else {
            selectedOption = label;
            _showFeedbackModal(value);
          }
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

  void _showLoginModal() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0), // Esquinas redondeadas
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0), // Esquinas redondeadas
            ),
            child: SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.7,
              child: Column(
                children: [
                  AppBar(
                    title: const Text('Inicia Sesión o Regístrate',
                        style: TextStyle(fontSize: 16)),
                    backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
                    automaticallyImplyLeading:
                        false, // Oculta la flecha de regreso
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                  const Expanded(
                    child:
                        Login(), // Asegúrate de que Login() sea un widget expandible
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showFeedbackModal(int utilidadValue) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(16),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Bríndanos tu opinión',
                style: TextStyle(fontSize: 16),
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
              const SizedBox(height: 15),
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
    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      Fluttertoast.showToast(
        msg: "Por favor, inicia sesión para enviar comentarios.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }

    final String comentario = _commentController.text;
    final Map<String, dynamic> feedbackData = {
      'utilidad': utilidadValue,
      'comentario': comentario,
    };

    try {
      // Verificar si el usuario ya tiene un comentario
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('comentarios')
          .where('uid', isEqualTo: user.uid)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        String docId = querySnapshot.docs[0].id;
        await FirebaseFirestore.instance
            .collection('comentarios')
            .doc(docId)
            .update(feedbackData);
        Fluttertoast.showToast(
          msg: "Comentario actualizado correctamente",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: const Color.fromARGB(225, 154, 255, 154),
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        feedbackData['uid'] = user.uid; // Agregar uid para nuevos comentarios
        await FirebaseFirestore.instance
            .collection('comentarios')
            .add(feedbackData);
        Fluttertoast.showToast(
          msg: "Comentario enviado correctamente",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: const Color.fromARGB(225, 154, 255, 154),
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }

      _commentController.clear();
      await fetchFeedbackData();
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error al enviar el comentario: $e",
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
    int totalResponses = _ratingsCount.reduce((a, b) => a + b);
    totalResponses = totalResponses > 0 ? totalResponses : 1;
    return [
      PieChartSectionData(
        color: const Color(0xff0293ee),
        value: (_ratingsCount[0] / totalResponses * 100).toDouble(),
        title:
            'Muy útil\n${(_ratingsCount[0] / totalResponses * 100).toStringAsFixed(1)}%',
        radius: 70,
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      PieChartSectionData(
        color: const Color(0xff13d38e),
        value: (_ratingsCount[1] / totalResponses * 100).toDouble(),
        title:
            'Útil\n${(_ratingsCount[1] / totalResponses * 100).toStringAsFixed(1)}%',
        radius: 70,
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      PieChartSectionData(
        color: const Color(0xfff8b250),
        value: (_ratingsCount[2] / totalResponses * 100).toDouble(),
        title:
            'Poco útil\n${(_ratingsCount[2] / totalResponses * 100).toStringAsFixed(1)}%',
        radius: 70,
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      PieChartSectionData(
        color: const Color(0xffff5182),
        value: (_ratingsCount[3] / totalResponses * 100).toDouble(),
        title:
            'Nada útil\n${(_ratingsCount[3] / totalResponses * 100).toStringAsFixed(1)}%',
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
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}
