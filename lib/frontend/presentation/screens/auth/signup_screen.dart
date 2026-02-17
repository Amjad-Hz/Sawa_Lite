import 'package:flutter/material.dart';
import 'package:sawa_lite/frontend/data/api/api_service.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final fullNameRegex = RegExp(
    r'^[\p{L}]{2,}\s+[\p{L}]{2,}(\s+[\p{L}]{2,})*$',
    unicode: true,
  );

  void _register() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      await ApiService.instance.register(
        phone: _phoneController.text.trim(),
        email: _emailController.text.trim(),
        fullName: _nameController.text.trim(),
        password: _passwordController.text.trim(),
      );

      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("فشل إنشاء الحساب: $e")),
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
              children: [
                Image.asset('assets/logo.png', width: 140),
                const SizedBox(height: 20),
                Text(
                  "إنشاء حساب جديد",
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),

                // full name
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'الاسم الكامل'),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return "الرجاء إدخال الاسم";
                    }
                    if (!fullNameRegex.hasMatch(v.trim())) {
                      return "يرجى إدخال الاسم الكامل (اسم أول واسم ثاني على الأقل)";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(labelText: 'رقم الهاتف'),
                  validator: (v) =>
                  v == null || v.isEmpty ? "الرجاء إدخال رقم الهاتف" : null,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'البريد الإلكتروني'),
                  validator: (v) =>
                  v == null || v.isEmpty ? "الرجاء إدخال البريد" : null,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'كلمة المرور'),
                  validator: (v) =>
                  v == null || v.length < 4 ? "كلمة المرور قصيرة" : null,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'تأكيد كلمة المرور'),
                  validator: (v) =>
                  v != _passwordController.text ? "غير متطابقة" : null,
                ),
                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _register,
                    child: const Text('إنشاء حساب'),
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
