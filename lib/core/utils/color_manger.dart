import 'dart:ui';
import 'package:flutter/material.dart';

// HexColor class for handling hex color codes

// ColorsManager class using HexColor
class ColorsManager {
  // Using HexColor for all colors
  static Color mainBlue = HexColor('023856');
  static Color lightBlue = HexColor('F4F8FF');
  static Color darkBlue = HexColor('242424');

  static Color gray = HexColor('757575');
  static Color lightGray = HexColor('C2C2C2');
  static Color lighterGray = HexColor('EDEDED');
  static Color moreLightGray = HexColor('FDFDFF');
  static Color moreLighterGray = HexColor('F5F5F5');

  static Color textPrimary = darkBlue;
  static Color textSecondary = gray;

  static Color background = moreLighterGray;
  static Color backgroundLight = moreLightGray;

  static Color buttonPrimary = mainBlue;
  static Color buttonDisabled = lightGray;

  static Color overlayLight = HexColor('80FFFFFF');
  static Color overlayDark = HexColor('80000000');

  // New colors with specified opacity
  static Color blue37Opacity = HexColor('5E4FC3F7'); // 4FC3F7 at 37% opacity
  static Color blue76Opacity = HexColor('C2298DB9'); // 298DB9 at 76% opacity
  static Color blue100Opacity = HexColor('FF0C75A4'); // 0C75A4 at 100% opacity
  static Color iconColor = HexColor('023856'); // Icon color

  // Combined gradient color
  static Color gradientBlue =
      HexColor('FF0C75A4'); // Using the base color 0C75A4 as the primary color
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor"; // Adds 0xFF if only 6 digits
    }
    return int.parse(hexColor, radix: 16); // Parse to int
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
