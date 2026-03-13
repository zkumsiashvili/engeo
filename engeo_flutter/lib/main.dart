import 'package:flutter/material.dart';
import 'screens/wordlist_screen.dart';

void main() {
  runApp(const EnGeoApp());
}

class EnGeoApp extends StatelessWidget {
  const EnGeoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EnGeo Dictionary',
      theme: ThemeData(
        primarySwatch: Colors.brown,
        scaffoldBackgroundColor: const Color(0xFFD2691E), // Chocolate color from original app
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF8B4513), // Saddle brown
          foregroundColor: Colors.white,
        ),
      ),
      home: const WordlistScreen(),
    );
  }
}
