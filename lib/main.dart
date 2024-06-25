import 'package:bargainz/pages/categories.dart';
import 'package:bargainz/pages/dashboard.dart';
import 'package:bargainz/pages/item-summary.dart';
import 'package:bargainz/pages/items.dart';
import 'package:bargainz/pages/items/new-product.dart';
import 'package:bargainz/pages/retailers.dart';
import 'package:bargainz/pages/settings-page.dart';
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
  int _selectedIndex = 0;

  final List _pages = [
    Items(),
    // Dashboard(),
    ItemSummary(),
    SettingsPage(),
  ];

  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/categories': (context) => Categories(),
        '/retailers': (context) => Retailers(),
        '/units-of-measure': (context) => UnitsOfMeasure(),
      },
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          title: const Text(
            "Bargainz",
            style: TextStyle(
              color: Color.fromARGB(255, 244, 253, 255),
            ),
          ),
          centerTitle: true,
          shadowColor: Colors.black,
          elevation: 8,
        ),
        body: _pages[_selectedIndex],
        bottomNavigationBar: NavigationBar(
          onDestinationSelected: _navigateBottomBar,
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          selectedIndex: _selectedIndex,
          height: 64,
          destinations: const [
            NavigationDestination(
                icon: Icon(Icons.list, color: Colors.teal), label: "Products"),
            // NavigationDestination(
            //     icon: Icon(
            //       Icons.home,
            //       color: Colors.teal,
            //     ),
            //     label: "Home"),
            NavigationDestination(
                icon: Icon(
                  Icons.summarize,
                  color: Colors.teal,
                ),
                label: "Summary"),
            NavigationDestination(
                icon: Icon(Icons.settings, color: Colors.teal),
                label: "Settings"),
          ],
        ),
      ),
    );
  }
}
