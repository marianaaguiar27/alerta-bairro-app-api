import 'package:flutter/material.dart';

import 'home_screen.dart';
import 'login_screen.dart';

void main() {
  runApp(const AlertaBairroApp());
}

class AlertaBairroApp extends StatelessWidget {
  const AlertaBairroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AlertaBairro',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF3F6FA),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF123B63),
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(
            fontSize: 16,
            color: Color(0xFF111827),
          ),
          bodySmall: TextStyle(
            fontSize: 14,
            color: Color(0xFF1F2937),
          ),
        ),
      ),
      home: const LoginScreen(),
      routes: {
        '/inicio': (context) => const HomeScreen(),
      },
    );
  }
}