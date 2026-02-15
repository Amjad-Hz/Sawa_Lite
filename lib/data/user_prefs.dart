import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sawa_lite/data/models/user_model.dart';

class UserPrefs {
  static const String _userKey = "user_data";

  // حفظ بيانات المستخدم
  static Future<void> saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(user.toJson());
    await prefs.setString(_userKey, jsonString);
  }

  // تحميل بيانات المستخدم
  static Future<UserModel?> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_userKey);

    if (jsonString == null) return null;

    final jsonMap = jsonDecode(jsonString);
    return UserModel.fromJson(jsonMap);
  }

  // حذف بيانات المستخدم
  static Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }
}
