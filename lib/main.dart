import 'package:bargainz/components/app-scaffold.dart';
import 'package:bargainz/pages/categories.dart';
import 'package:bargainz/pages/history.dart';
import 'package:bargainz/pages/retailers.dart';
import 'package:bargainz/pages/units-of-measure.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final Map<String, Widget Function(BuildContext)> routes = {
    '/categories': (context) => const Categories(),
    '/retailers': (context) => const Retailers(),
    '/units-of-measure': (context) => const UnitsOfMeasure(),
    '/product-history': (context) => const History(),
  };

  @override
  Widget build(BuildContext context) {
    ColorScheme appColors = ColorScheme.fromSeed(seedColor: Colors.teal);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: appColors, //<--this
        textTheme: const TextTheme(
            titleLarge: TextStyle(color: Colors.teal)), //<--and this
      ),
      routes: routes,
      home: AppScaffold(
        showNavigationBar: true,
        showBackButton: false,
      ),
    );
  }
}
