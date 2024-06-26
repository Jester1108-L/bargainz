import 'package:bargainz/constants/bottom-navigation.dart';
import 'package:bargainz/models/navigation-page.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AppScaffold extends StatefulWidget {
  final Widget? childWidget;

  bool showNavigationBar;

  AppScaffold(
      {super.key, this.childWidget, this.showNavigationBar = false});

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  int _selectedIndex = 2;

  // Set the selected navigation index and refresh the widget states
  void onNavigationItemClick(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(
          color: Colors.white,
        ),
        backgroundColor: Colors.teal,
        title: Text(
          widget.showNavigationBar
              ? BottomNavigation[_selectedIndex].title
              : "Bargainz",
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        shadowColor: Colors.black,
        elevation: 8,
      ),
      body: widget.showNavigationBar
          ? BottomNavigation[_selectedIndex].page
          : Padding(
              padding: const EdgeInsets.only(top: 32, left: 8, right: 8),
              child: widget.childWidget,
            ),
      bottomNavigationBar: widget.showNavigationBar
          ? NavigationBar(
              onDestinationSelected: onNavigationItemClick,
              labelBehavior:
                  NavigationDestinationLabelBehavior.onlyShowSelected,
              selectedIndex: _selectedIndex,
              height: 64,
              destinations: [
                for (NavigationPage page in BottomNavigation)
                  NavigationDestination(
                      icon: Icon(page.icon, color: Colors.teal),
                      label: page.title)
              ],
            )
          : null,
    );
  }
}
