import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'app.dart';

void main() async {
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    // Handle .env loading error silently
  }
  runApp(const App());
}
