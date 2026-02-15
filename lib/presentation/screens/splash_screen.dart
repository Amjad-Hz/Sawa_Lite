import 'package:flutter/material.dart';
import 'package:sawa_lite/data/user_prefs.dart';
import 'package:sawa_lite/presentation/screens/auth/login_screen.dart';
import 'package:sawa_lite/presentation/screens/home_screen.dart';
import '../../../data/models/user_model.dart';

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

    currentUser = await UserPrefs.loadUser();

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

      color: const Color(0xFF1B4D3E), // الأخضر الداكن

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
