import 'package:flutter/material.dart';
import '../../data/user_prefs.dart';
import '../../data/api/api_service.dart';
import '../../utils/jwt_helper.dart';
import 'auth/login_screen.dart';
import 'home_screen.dart';
import '../../data/models/user_model.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 2));

    // تحميل التوكن
    final token = await UserPrefs.getToken();

    // إذا لا يوجد توكن → تسجيل خروج
    if (token == null || JwtHelper.isExpired(token)) {
      await UserPrefs.clearToken();
      await UserPrefs.clearUser();

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
      return;
    }

    // التوكن صالح → تحميله في ApiService
    ApiService.instance.setToken(token);

    // تحميل المستخدم
    currentUser = await UserPrefs.getUser();

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => currentUser != null
            ? const HomeScreen()
            : const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: _SplashBody(),
    );
  }
}

class _SplashBody extends StatelessWidget {
  const _SplashBody();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: const Color(0xFF1B4D3E),
      child: Center(
        child: Image.asset(
          'assets/logo.png',
          width: 180,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
