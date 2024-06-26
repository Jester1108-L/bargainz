import 'package:bargainz/models/navigation-page.dart';
import 'package:bargainz/pages/product-summary.dart';
import 'package:bargainz/pages/products.dart';
import 'package:bargainz/pages/settings-page.dart';
import 'package:flutter/material.dart';

// List of navigational options/pages for the bottom navigation bar
final List<NavigationPage> BottomNavigation = [
  NavigationPage(page: const Products(), title: "Products", icon: Icons.list),
  NavigationPage(page: const ProductSummary(), title: "Summary", icon: Icons.summarize),
  NavigationPage(page: const SettingsPage(), title: "Settings", icon: Icons.settings),
];