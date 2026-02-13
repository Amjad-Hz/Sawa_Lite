import 'package:flutter/material.dart';
import 'package:sawa_lite/presentation/screens/auth/signup_screen.dart';
import 'package:sawa_lite/presentation/screens/home_screen.dart';

import '../../../data/models/user_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  bool isRegistered = false; // المستخدم غير مسجل في البداية

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء إنشاء حساب أولاً')),
      );
      return;
    }

    if (_phoneController.text == currentUser!.phone &&
        _passwordController.text == currentUser!.password) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('رقم الهاتف أو كلمة المرور غير صحيحة')),
      );
    }
  }


  Future<void> _goToSignUp() async {
    final registered = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SignUpScreen()),
    );

    if (registered == true) {
      setState(() {
        isRegistered = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم إنشاء الحساب بنجاح، يمكنك تسجيل الدخول الآن')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('تسجيل الدخول')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'رقم الهاتف'),
              ),

              const SizedBox(height: 16),

              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'كلمة المرور'),
              ),

              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: _login,
                child: const Text('تسجيل الدخول'),
              ),

              TextButton(
                onPressed: _goToSignUp,
                child: const Text('ليس لديك حساب؟ إنشاء حساب'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
