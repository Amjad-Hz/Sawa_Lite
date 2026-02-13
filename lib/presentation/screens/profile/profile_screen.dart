import 'package:flutter/material.dart';
import 'package:sawa_lite/data/models/user_model.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('الملف الشخصي'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(
                radius: 40,
                child: Icon(Icons.person, size: 50),
              ),

              const SizedBox(height: 16),

              Text( currentUser?.name ?? 'غير معروف', style: const TextStyle( fontSize: 22, fontWeight: FontWeight.bold, ), ),

              const SizedBox(height: 8),

              Text( 'رقم الهاتف: ${currentUser?.phone ?? '---'}', style: const TextStyle(fontSize: 16), ),

              const SizedBox(height: 24),

              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('الإعدادات'),
                onTap: () {},
              ),

              ListTile(
                leading: const Icon(Icons.lock),
                title: const Text('تغيير كلمة المرور'),
                onTap: () {},
              ),

              ListTile(
                leading: const Icon(Icons.info),
                title: const Text('حول التطبيق'),
                onTap: () {},
              ),

              const Spacer(),

              ElevatedButton(
                onPressed: () {
                  // لاحقاً: تسجيل خروج حقيقي
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: const Text('تسجيل الخروج'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
