import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/user_model.dart';

class UserPrefs {
  static const String _tokenKey = "token";
  static const String _userKey = "user";

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  static Future<void> saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
  }

  static Future<UserModel?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_userKey);

    if (jsonString == null) return null;

    try {
      final jsonMap = jsonDecode(jsonString);


      if (!jsonMap.containsKey("role")) {
        await prefs.remove(_userKey);
        return null;
      }

      return UserModel.fromJson(jsonMap);

    } catch (e) {
      await prefs.remove(_userKey);
      return null;
    }
  }

  static Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }
}
