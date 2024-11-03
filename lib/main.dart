import 'package:firebase_core/firebase_core.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:skytrack/utils/sidebar.dart';
import 'package:skytrack/views/weather.dart';
import 'dart:async';

const Map<String, String> weatherLottieMap = {
  'cielo claro': 'assets/images/json/clear-day.json',
  'algo de nubes': 'assets/images/json/few-clouds.json',
  'nubes dispersas': 'assets/images/json/cloudy.json',
  'muy nuboso': 'assets/images/json/cloudy-fog.json',
  'nubes': 'assets/images/json/cloudy.json',
  'lluvia ligera': 'assets/images/json/rain.json',
  'lluvia moderada': 'assets/images/json/rain.json',
  'lluvias intensas': 'assets/images/json/rain.json',
  'tormenta': 'assets/images/json/storm.json',
  'nieve': 'assets/images/json/snow.json',
  'neblina': 'assets/images/json/mist.json',
};

class WeatherForecast {
  final String date;
  final String description;
  final String lottieFile;
  final double temperature;
  final double rain;
  final double wind;
  final int humidity;
  final double minTemp;
  final double maxTemp;

  WeatherForecast({
    required this.date,
    required this.description,
    required this.lottieFile,
    required this.temperature,
    required this.rain,
    required this.wind,
    required this.humidity,
    required this.minTemp,
    required this.maxTemp,
  });

  factory WeatherForecast.fromJson(Map<String, dynamic> json) {
    String description = json['weather'][0]['description'];
    String lottieFile =
        weatherLottieMap[description] ?? 'assets/images/json/pointer.json';
    double rain = 0;

    if (json.containsKey('rain') && json['rain']['3h'] != null) {
      rain = json['rain']['3h'];
    } else {
      rain = 0;
    }

    double wind = (json['wind']['speed'] as num).toDouble();
    int humidity = json['main']['humidity'];

    return WeatherForecast(
      date: json['dt_txt'],
      description: description,
      lottieFile: lottieFile,
      rain: rain,
      humidity: humidity,
      wind: wind,
      temperature: json['main']['temp'] - 273.15,
      minTemp: json['main']['temp_min'] - 273.15, // Convertir a Celsius
      maxTemp: json['main']['temp_max'] - 273.15, // Convertir a Celsius
    );
  }
}

// Función para obtener los datos del pronóstico del clima
Future<List<WeatherForecast>> fetchWeatherForecast(String city) async {
  const apiKey =
      '0ca7fb8919814e59836c2f5d2c86d168'; // Reemplaza con tu clave API
  final url =
      'http://api.openweathermap.org/data/2.5/forecast?q=$city&cnt=7&appid=$apiKey&lang=es';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final List<dynamic> list = data['list'];
    return list.map((json) => WeatherForecast.fromJson(json)).toList();
  } else {
    throw Exception('Error al obtener datos del clima');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool _isLoading = true;
  Timer? _timer;
  String formattedTime = '';
  String formattedDate = '';
  WeatherForecast? _currentlyForecast;
  String _location = 'Obteniendo ubicación...';
  List<WeatherForecast>? _hourlyForecasts;

  @override
  void initState() {
    super.initState();
    _determinePosition();
    _startClock();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _determinePosition() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permiso denegado
        setState(() {
          _location = 'Ubicación no disponible';
        });
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition(
        // ignore: deprecated_member_use
        desiredAccuracy: LocationAccuracy.high);

    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    String city = placemarks[0].locality ?? 'Ubicación desconocida';
    String country = placemarks[0].country ?? '';
    setState(() {
      _location = '$city, $country';
    });

    _loadWeatherData(city);
  }

  Future<void> _loadWeatherData(String city) async {
    try {
      final forecastList = await fetchWeatherForecast(city);
      final hourlyForecasts = <WeatherForecast>[];

      for (var forecast in forecastList) {
        final forecastTime = DateTime.parse(forecast.date);
        final hour = forecastTime.hour;

        if ([0, 3, 6, 9, 12, 15, 18, 21].contains(hour)) {
          hourlyForecasts.add(forecast);
        }
      }

      setState(() {
        _hourlyForecasts = hourlyForecasts;
        _currentlyForecast = forecastList.first;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      throw Exception('Error al cargar los datos del clima');
    }
  }

  void _startClock() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        final now = DateTime.now();
        formattedTime = DateFormat('hh:mm a').format(now);
        formattedDate = DateFormat('E dd MMM').format(now);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final hour = now.hour;
    String greeting;
    String star = '';

    if (hour < 12) {
      greeting = '¡Buenos días!';
      star = 'assets/images/json/clear-day.json';
    } else if (hour < 18) {
      greeting = '¡Buenas tardes!';
      star = 'assets/images/json/clear-day.json';
    } else {
      greeting = '¡Buenas noches!';
      star = 'assets/images/json/clear-night.json';
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(width: 8),
            Text(
              _location,
              style: const TextStyle(fontSize: 14),
            ),
            Lottie.asset(
              'assets/images/json/pointer.json',
              width: 30,
              height: 30,
            ),
          ],
        ),
        actions: [
          Builder(
            builder: (BuildContext context) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            ),
          ),
        ],
        backgroundColor: Colors.white,
        foregroundColor: const Color.fromRGBO(0, 51, 102, 1),
      ),
      endDrawer: const Sidebar(),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Color.fromRGBO(0, 51, 102, 1),
                ),
              ),
            )
          : _currentlyForecast == null
              ? const Center(
                  child: Text('No se pudieron cargar los datos del clima'))
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Row(children: [
                            Text(
                              greeting,
                              style: const TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(0, 51, 102, 1),
                              ),
                            ),
                            Lottie.asset(
                              star,
                              width: 36,
                              height: 36,
                            ),
                          ]),
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: Column(
                            children: [
                              Lottie.asset(
                                _currentlyForecast!.lottieFile,
                                width: 206,
                                height: 206,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '$formattedDate | $formattedTime',
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.grey),
                              ),
                              Text(
                                '${_currentlyForecast!.temperature.toStringAsFixed(1)}° C',
                                style: const TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(0, 51, 102, 1),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildWeatherDetail('assets/images/json/storm.json',
                                '${_currentlyForecast!.rain} mm', 'Lluvia'),
                            _buildWeatherDetail('assets/images/json/wind.json',
                                '${_currentlyForecast!.wind} m/s', 'Viento'),
                            _buildWeatherDetail(
                                'assets/images/json/humidity.json',
                                '${_currentlyForecast!.humidity}%',
                                'Humedad'),
                            _buildWeatherDetail(
                                'assets/images/json/hot.json',
                                '${_currentlyForecast!.minTemp.toStringAsFixed(1)}° C | ${_currentlyForecast!.maxTemp.toStringAsFixed(1)}° C',
                                'Temperatura'),
                          ],
                        ),
                        const SizedBox(height: 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Hoy',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const WeatherForecastList()),
                                );
                              },
                              child: const Text(
                                'Próximos 7 días',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Color.fromRGBO(0, 51, 102, 1),
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 120,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _hourlyForecasts?.length ?? 0,
                            itemBuilder: (context, index) {
                              final forecast = _hourlyForecasts![index];
                              final forecastTime =
                                  DateTime.parse(forecast.date);
                              final time =
                                  DateFormat('h:mm a').format(forecastTime);
                              final temp =
                                  '${forecast.temperature.toStringAsFixed(1)}° C';
                              return _buildHourlyForecast(
                                  time, temp, forecast.lottieFile, now);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildWeatherDetail(String lottiePath, String value, String label) {
    return Column(
      children: [
        Lottie.asset(lottiePath, width: 40, height: 40),
        const SizedBox(height: 4),
        Text(value,
            style: const TextStyle(
                fontSize: 16, color: Color.fromRGBO(0, 51, 102, 1))),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _buildHourlyForecast(
      String time, String temp, String lottiePath, DateTime now) {
    final forecastTime = DateFormat('h:mm a').parse(time);
    final isCurrentInterval = _isCurrentInterval(forecastTime, now);

    return Container(
      width: 90,
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.only(right: 8.0),
      decoration: BoxDecoration(
        color: isCurrentInterval
            ? const Color.fromRGBO(0, 51, 102, 1)
            : Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            time,
            style: TextStyle(
              fontSize: 14,
              color: isCurrentInterval
                  ? Colors.white
                  : const Color.fromRGBO(0, 51, 102, 1),
            ),
          ),
          Lottie.asset(
            lottiePath,
            width: 50,
            height: 50,
          ),
          Text(
            temp,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isCurrentInterval
                  ? Colors.white
                  : const Color.fromRGBO(0, 51, 102, 1),
            ),
          ),
        ],
      ),
    );
  }

  bool _isCurrentInterval(DateTime forecastTime, DateTime now) {
    final startHour = forecastTime.hour;
    final endHour = (startHour + 3) % 24;

    return (now.hour >= startHour && now.hour < endHour) ||
        (startHour > endHour && (now.hour >= startHour || now.hour < endHour));
  }
}
