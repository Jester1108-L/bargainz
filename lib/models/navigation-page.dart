import 'package:flutter/material.dart';

class NavigationPage{
  final String title;
  final IconData icon;
  String? route;
  Widget? page;

  NavigationPage({this.page, this.route, required this.title, required this.icon});
}