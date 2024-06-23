import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  final Widget childWidget;

  const AppScaffold({super.key, required this.childWidget});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(
            leading: const BackButton(
              color: Colors.white,
            ),
            backgroundColor: Colors.teal,
            title: const Text(
              "Test",
              style: TextStyle(
                color: Color.fromARGB(255, 244, 253, 255),
              ),
            ),
            centerTitle: true,
            shadowColor: Colors.black,
            elevation: 8,
          ),
          body: Padding(
            padding: const EdgeInsets.only(top: 32, left: 8, right: 8),
            child: childWidget,
          ),
        );
  }
}