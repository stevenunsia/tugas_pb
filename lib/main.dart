import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const MovieReviewsApp());
}

class MovieReviewsApp extends StatelessWidget {
  const MovieReviewsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie Reviews',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginScreen(),
    );
  }
}