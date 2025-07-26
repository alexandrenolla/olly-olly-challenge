import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'app.dart';

void main() async {
  try {
    print('📁 Loading .env file...');
    await dotenv.load(fileName: ".env");
    print('✅ .env file loaded successfully');
    print('🔑 API Key loaded: ${dotenv.env['OPENWEATHER_API_KEY'] != null ? 'YES' : 'NO'}');
    if (dotenv.env['OPENWEATHER_API_KEY'] != null) {
      print('🔑 API Key length: ${dotenv.env['OPENWEATHER_API_KEY']!.length}');
    }
  } catch (e) {
    print('❌ Error loading .env file: $e');
  }
  runApp(const App());
}
