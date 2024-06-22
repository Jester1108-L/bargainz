import 'package:bargainz/pages/dashboard.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Dashboard(),
      ),
      routes: {
        // '/': (context) => const Dashboard(),
      },
    );
  }
}
