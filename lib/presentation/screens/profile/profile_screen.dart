import 'package:flutter/material.dart';
import 'package:sawa_lite/data/models/user_model.dart';
import 'package:sawa_lite/presentation/screens/auth/login_screen.dart';
import '../../../data/user_prefs.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('الملف الشخصي'),
          centerTitle: true,
        ),

        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [

              // صورة المستخدم
              const CircleAvatar(
                radius: 45,
                child: Icon(Icons.person, size: 55),
              ),

              const SizedBox(height: 16),

              // بطاقة بيانات المستخدم
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentUser?.name ?? 'غير معروف',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        'رقم الهاتف: ${currentUser?.phone ?? '---'}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // عناصر القائمة
              ListTile(
                leading: Icon(Icons.settings, color: primaryColor),
                title: const Text('الإعدادات'),
                onTap: () {},
              ),

              ListTile(
                leading: Icon(Icons.lock, color: primaryColor),
                title: const Text('تغيير كلمة المرور'),
                onTap: () {},
              ),

              ListTile(
                leading: Icon(Icons.info, color: primaryColor),
                title: const Text('حول التطبيق'),
                onTap: () {},
              ),

              const Spacer(),

              // زر تسجيل الخروج
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    await UserPrefs.clearUser();
                    currentUser = null;

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    'تسجيل الخروج',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
