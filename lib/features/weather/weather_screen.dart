import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'weather_service.dart';
import '../auth/auth_controller.dart';
import '../auth/login_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  Weather? weather;
  String? error;
  bool isLoading = false;

  void executeLogout() {
    final container = ProviderScope.containerOf(context, listen: false);
    container.read(authControllerProvider.notifier).logout();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  Future<void> fetchWeather() async {
    setState(() {
      isLoading = true;
      error = null;
    });
    try {
      final position = await _getCurrentPosition();
      final result = await WeatherService().fetchWeather(position.latitude, position.longitude);
      setState(() {
        weather = result;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  Future<Position> _getCurrentPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied.');
    }
    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : error != null
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Error: $error', style: const TextStyle(color: Colors.red)),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: fetchWeather,
                        child: const Text('Try Again'),
                      ),
                    ],
                  )
                : weather == null
                    ? ElevatedButton(
                        onPressed: fetchWeather,
                        child: const Text('Get Weather'),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 24.0),
                                  child: LayoutBuilder(
                                    builder: (context, constraints) {
                                      final double logoSize = constraints.maxWidth < 400 ? 100 : 160;
                                      return SvgPicture.asset(
                                        'assets/images/logo.svg',
                                        width: logoSize,
                                        height: logoSize,
                                      );
                                    },
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.network(
                                      'https://openweathermap.org/img/wn/${weather!.icon}@4x.png',
                                      width: 80,
                                      height: 80,
                                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.wb_cloudy, size: 80),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Center(
                                  child: Text(
                                    weather!.description,
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).cardColor,
                                          borderRadius: BorderRadius.circular(16),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withAlpha((0.12 * 255).round()),
                                              blurRadius: 16,
                                              offset: const Offset(0, 8),
                                            ),
                                          ],
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(
                                            children: [
                                              const Text('Celsius', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                              const SizedBox(height: 8),
                                              LayoutBuilder(
                                                builder: (context, constraints) {
                                                  final double fontSize = constraints.maxWidth < 400 ? 28 : 48;
                                                  return Text(
                                                    '${weather!.tempCelsius.toStringAsFixed(1)}°C',
                                                    style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).cardColor,
                                          borderRadius: BorderRadius.circular(16),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withAlpha((0.12 * 255).round()),
                                              blurRadius: 16,
                                              offset: const Offset(0, 8),
                                            ),
                                          ],
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(
                                            children: [
                                              const Text('Fahrenheit', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                              const SizedBox(height: 8),
                                              LayoutBuilder(
                                                builder: (context, constraints) {
                                                  final double fontSize = constraints.maxWidth < 430 ? 28 : 48;
                                                  return Text(
                                                    '${weather!.tempFahrenheit.toStringAsFixed(1)}°F',
                                                    style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 24),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 32),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                      ),
                                      onPressed: fetchWeather,
                                      child: const Text('Refresh'),
                                    ),
                                    const SizedBox(width: 16),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 32),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                      ),
                                      onPressed: executeLogout,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: const [
                                          Icon(Icons.logout),
                                          SizedBox(width: 8),
                                          Text('Logout'),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
      ),
    );
  }
} 