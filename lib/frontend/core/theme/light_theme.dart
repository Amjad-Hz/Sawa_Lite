import 'package:flutter/material.dart';

ThemeData buildLightTheme() {
  const Color primaryGreen = Color(0xFF1B4D3E);
  const Color secondaryGold = Color(0xFFC9A94B);

  return ThemeData(
    fontFamily: 'Roboto',

    // اللون الأساسي للتطبيق
    primaryColor: primaryGreen,

    // خلفية الشاشات
    scaffoldBackgroundColor: Colors.white,

    // AppBar
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryGreen,
      foregroundColor: Colors.white,
      centerTitle: true,
      elevation: 0,
    ),

    // حقول الإدخال
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      filled: true,
      fillColor: Colors.white,
    ),

    // الأزرار
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        minimumSize: const Size(double.infinity, 48),
      ),
    ),

    // Bottom Navigation
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: primaryGreen,
      unselectedItemColor: Colors.grey,
      elevation: 10,
    ),

    // البطاقات
    cardTheme: CardTheme(
      color: Colors.white,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),

    // النصوص
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Colors.black87),
      bodySmall: TextStyle(color: Colors.black54),
      titleLarge: TextStyle(
        color: primaryGreen,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
