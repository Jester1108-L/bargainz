import 'package:bargainz/constants/bottom-navigation.dart';
import 'package:bargainz/models/navigation-page.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AppScaffold extends StatefulWidget {
  final Widget? childWidget;

  String? title;
  bool showNavigationBar;
  bool showBackButton;

  AppScaffold(
      {super.key,
      this.title,
      this.childWidget,
      this.showNavigationBar = false,
      this.showBackButton = true});

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  int _selectedIndex = 0;

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
        leading: widget.showBackButton
            ? const BackButton(
                color: Colors.white,
              )
            : null,
        backgroundColor: Colors.teal,
        title: Text(
          widget.title == null
              ? BottomNavigation[_selectedIndex].title
              : widget.title ?? "Bargainz",
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        shadowColor: Colors.black,
        elevation: 8,
      ),
      body: widget.showNavigationBar
          ? BottomNavigation[_selectedIndex].page
          : Padding(
              padding: const EdgeInsets.only(top: 24, left: 8, right: 8),
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
