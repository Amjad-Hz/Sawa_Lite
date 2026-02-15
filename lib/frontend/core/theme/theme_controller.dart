import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController {
  static final ThemeController instance = ThemeController._internal();
  ThemeController._internal();

  final ValueNotifier<bool> isDark = ValueNotifier(false);

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    isDark.value = prefs.getBool("isDark") ?? false;
  }

  Future<void> toggleTheme(bool value) async {
    isDark.value = value;
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("isDark", value);
  }
}
