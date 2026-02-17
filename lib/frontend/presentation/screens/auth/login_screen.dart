import 'package:flutter/material.dart';
import 'package:sawa_lite/frontend/data/api/api_service.dart';
import 'package:sawa_lite/frontend/data/models/user_model.dart';
import 'package:sawa_lite/frontend/data/user_prefs.dart';
import 'package:sawa_lite/frontend/presentation/screens/auth/signup_screen.dart';
import 'package:sawa_lite/frontend/presentation/screens/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  void _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // تسجيل الدخول والحصول على التوكن
      final token = await ApiService.instance.login(
        phone: _phoneController.text.trim(),
        password: _passwordController.text.trim(),
      );

      await UserPrefs.saveToken(token);

      // تحميل التوكن في ApiService
      ApiService.instance.setToken(token);

      // جلب بيانات المستخدم الأساسية
      final userData = await ApiService.instance.getMe();
      currentUser = UserModel.fromJson(userData);

      // 🔥 تحديد الدور بدون الاعتماد على الباك
      String role = "user";

      // أول مستخدم في قاعدة البيانات هو الأدمن
      if (currentUser!.id == 1) {
        role = "admin";
      }

      // تحديث currentUser بالدور الصحيح
      currentUser = UserModel(
        id: currentUser!.id,
        phone: currentUser!.phone,
        email: currentUser!.email,
        fullName: currentUser!.fullName,
        createdAt: currentUser!.createdAt,
        isVerified: currentUser!.isVerified,
        role: role,
      );

      // حفظ المستخدم النهائي
      await UserPrefs.saveUser(currentUser!);

      // الانتقال للصفحة الرئيسية
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("فشل تسجيل الدخول: $e")),
      );
    } finally {
      setState(() => _isLoading = false);
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
              children: [
                Image.asset('assets/logo.png', width: 140),
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
                  decoration: const InputDecoration(labelText: 'رقم الهاتف'),
                  validator: (v) =>
                  v == null || v.isEmpty ? "الرجاء إدخال رقم الهاتف" : null,
                ),

                const SizedBox(height: 16),

                // كلمة المرور
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'كلمة المرور'),
                  validator: (v) =>
                  v == null || v.isEmpty ? "الرجاء إدخال كلمة المرور" : null,
                ),

                const SizedBox(height: 24),

                // زر تسجيل الدخول
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _login,
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('تسجيل الدخول'),
                  ),
                ),

                // الانتقال لإنشاء حساب
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SignUpScreen()),
                    );
                  },
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
