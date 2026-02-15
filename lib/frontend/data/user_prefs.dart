import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/user_model.dart';

class UserPrefs {
  static const String userKey = "user_data";
  static const String tokenKey = "token";

  static const String passwordKey = "user_password";

  static Future<void> savePassword(String password) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(passwordKey, password);
  }

  static Future<String?> loadPassword() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(passwordKey);
  }

  static Future<void> saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(userKey, jsonEncode(user.toJson()));
  }

  static Future<UserModel?> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(userKey);
    if (data == null) return null;
    return UserModel.fromJson(jsonDecode(data));
  }

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(tokenKey, token);
  }

  static Future<String?> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(tokenKey);
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(userKey);
    prefs.remove(tokenKey);
  }
}
