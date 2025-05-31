import 'package:flutter/material.dart';

class DrawerItem {
  final String title;
  final IconData icon;
  final String route;
  final Color color;
  final List<DrawerSubItem>? subItems;

  DrawerItem({
    required this.title,
    required this.icon,
    required this.route,
    required this.color,
    this.subItems,
  });
}

class DrawerSubItem {
  final String title;
  final String route;
  final IconData icon;

  DrawerSubItem({
    required this.title,
    required this.route,
    required this.icon,
  });
}
