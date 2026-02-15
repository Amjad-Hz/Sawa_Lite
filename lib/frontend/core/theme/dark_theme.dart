import 'package:flutter/material.dart';

ThemeData buildDarkTheme() {
  const Color primaryGreen = Color(0xFF1B4D3E);
  const Color secondaryGold = Color(0xFFC9A94B);

  return ThemeData(
    brightness: Brightness.dark,
    fontFamily: 'Roboto',

    // اللون الأساسي
    primaryColor: primaryGreen,

    // خلفية الشاشات
    scaffoldBackgroundColor: const Color(0xFF121212),

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
      fillColor: const Color(0xFF1E1E1E),
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
      backgroundColor: Color(0xFF1E1E1E),
      selectedItemColor: primaryGreen,
      unselectedItemColor: Colors.grey,
      elevation: 10,
    ),

    // البطاقات
    cardTheme: CardTheme(
      color: const Color(0xFF1E1E1E),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),

    // النصوص
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Colors.white),
      bodySmall: TextStyle(color: Colors.white70),
      titleLarge: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
