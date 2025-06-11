import 'package:flutter/material.dart';

/// A class that manages all the colors used in the application.
/// Colors are organized into logical groups and include opacity variants.
class ColorsManager {
  // Primary Colors
  static const Color primary = Color(0xFF3B82F6);
  static const Color primaryDark = Color(0xFF3B82F6);
  static const Color primaryLight = Color(0xFF42A5F5);

  // Primary with opacity
  static Color primaryWithOpacity(double opacity) =>
      primary.withOpacity(opacity);
  static Color primaryDarkWithOpacity(double opacity) =>
      primaryDark.withOpacity(opacity);
  static Color primaryLightWithOpacity(double opacity) =>
      primaryLight.withOpacity(opacity);

  // Secondary Colors
  static const Color secondary = Color.fromARGB(0, 255, 255, 255);
  static const Color secondaryDark = Color.fromARGB(255, 203, 227, 224);
  static const Color secondaryLight = Color(0xFF4DB6AC);

  // Gray Scale
  static const Color gray = Color(0xFF9E9E9E);
  static const Color lightGray = Color(0xFFE0E0E0);
  static const Color lighterGray = Color(0xFFF5F5F5);
  static const Color moreLightGray = Color(0xFFFAFAFA);
  static const Color darkGray = Color(0xFF616161);
  static const Color darkerGray = Color(0xFF424242);

  // Background Colors
  static const Color background = Color(0xFFFFFFFF);
  static const Color backgroundDark = Color(0xFFF5F5F5);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFFEEEEEE);

  // Status Colors
  static const Color error = Color(0xFFD32F2F);
  static const Color success = Color(0xFF388E3C);
  static const Color warning = Color(0xFFF57C00);
  static const Color info = Color(0xFF2196F3);

  // Status Colors with opacity
  static Color errorWithOpacity(double opacity) => error.withOpacity(opacity);
  static Color successWithOpacity(double opacity) =>
      success.withOpacity(opacity);
  static Color warningWithOpacity(double opacity) =>
      warning.withOpacity(opacity);
  static Color infoWithOpacity(double opacity) => info.withOpacity(opacity);

  // Text Colors
  static const Color textDark = Color(0xFF212121);
  static const Color textLight = Color(0xFF757575);
  static const Color textMedium = Color(0xFF616161);
  static const Color textHint = Color(0xFF9E9E9E);
  static const Color textDisabled = Color(0xFFBDBDBD);

  // Border Colors
  static const Color border = Color(0xFFE0E0E0);
  static const Color borderDark = Color(0xFFBDBDBD);
  static const Color borderLight = Color(0xFFEEEEEE);

  // Shadow Colors
  static const Color shadow = Color(0x1A000000);
  static const Color shadowDark = Color(0x33000000);
  static const Color shadowLight = Color(0x0D000000);

  // Overlay Colors
  static const Color overlay = Color(0x80000000);
  static const Color overlayLight = Color(0x40000000);
  static const Color overlayDark = Color(0xCC000000);

  // Disabled Colors
  static const Color disabled = Color(0xFFBDBDBD);
  static const Color disabledDark = Color(0xFF9E9E9E);
  static const Color disabledLight = Color(0xFFE0E0E0);
}
