import 'package:bargainz/models/navigation-page.dart';
import 'package:flutter/material.dart';

// List of navigational options/pages for the settings page
final List<NavigationPage> SettingsNavigation = [
  NavigationPage(route: '/categories', title: "Categories", icon: Icons.account_tree),
  NavigationPage(route: '/retailers', title: "Retailers", icon: Icons.shop_2),
  NavigationPage(route: '/units-of-measure', title: "Units Of Measure", icon: Icons.monitor_weight),
  NavigationPage(route: '/product-history', title: "History", icon: Icons.timelapse),
];