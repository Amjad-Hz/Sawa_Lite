import 'package:flutter/material.dart';
import 'package:sawa_lite/frontend/data/user_prefs.dart';
import 'package:sawa_lite/frontend/presentation/screens/auth/signup_screen.dart';
import 'package:sawa_lite/frontend/presentation/screens/home_screen.dart';

import '../../../data/models/user_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool isRegistered = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  void _loadUser() async {
    currentUser = await UserPrefs.loadUser();
    if (currentUser != null) {
      setState(() {
        isRegistered = true;
      });
    }
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      if (currentUser != null &&
          currentUser!.phone == _phoneController.text &&
          currentUser!.password == _passwordController.text) {

        await UserPrefs.saveUser(currentUser!);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("رقم الهاتف أو كلمة المرور غير صحيحة")),
        );
      }
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
    final primaryColor = Theme.of(context).primaryColor;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,

        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // الشعار
                Image.asset(
                  'assets/logo.png',
                  width: 140,
                  fit: BoxFit.contain,
                ),

                const SizedBox(height: 20),

                Text(
                  "تسجيل الدخول",
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 30),

                // رقم الهاتف
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'رقم الهاتف',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "الرجاء إدخال رقم الهاتف";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // كلمة المرور
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'كلمة المرور',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "الرجاء إدخال كلمة المرور";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 24),

                // زر تسجيل الدخول
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _login,
                    child: const Text('تسجيل الدخول'),
                  ),
                ),

                const SizedBox(height: 12),

                // رابط إنشاء حساب
                TextButton(
                  onPressed: _goToSignUp,
                  child: Text(
                    'ليس لديك حساب؟ إنشاء حساب',
                    style: TextStyle(color: primaryColor),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
