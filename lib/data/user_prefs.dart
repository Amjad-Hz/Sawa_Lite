import 'package:shared_preferences/shared_preferences.dart';
import 'package:sawa_lite/data/models/user_model.dart';

class UserPrefs {
  static Future<void> saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('id', user.id);
    await prefs.setString('name', user.name);
    await prefs.setString('phone', user.phone);
    await prefs.setString('password', user.password);
  }

  static Future<UserModel?> loadUser() async {
    final prefs = await SharedPreferences.getInstance();

    final id = prefs.getInt('id');
    final name = prefs.getString('name');
    final phone = prefs.getString('phone');
    final password = prefs.getString('password');

    if (id == null || name == null || phone == null || password == null) {
      return null;
    }

    return UserModel(
      id: id,
      name: name,
      phone: phone,
      password: password,
    );
  }

  static Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
