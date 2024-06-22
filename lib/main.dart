import 'package:bargainz/pages/categories.dart';
import 'package:bargainz/pages/dashboard.dart';
import 'package:bargainz/pages/items.dart';
import 'package:bargainz/pages/retailers.dart';
import 'package:bargainz/pages/settings.dart';
import 'package:flutter/material.dart';

void main() {
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
    Categories(),
    Dashboard(),
    Retailers(),
    Settings(),
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
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          title: const Text("Test", style: TextStyle(color: Color.fromARGB(255, 244, 253, 255),),),
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
                icon: Icon(Icons.list, color: Colors.teal), label: "Items"),
            NavigationDestination(
                icon: Icon(Icons.account_tree, color: Colors.teal),
                label: "Categories"),
            NavigationDestination(
                icon: Icon(
                  Icons.home,
                  color: Colors.teal,
                ),
                label: "Home"),
            NavigationDestination(
                icon: Icon(Icons.shop, color: Colors.teal), label: "Retailers"),
            NavigationDestination(
                icon: Icon(Icons.settings, color: Colors.teal),
                label: "Settings"),
          ],
        ),
      ),
    );
  }
}
