import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sawa_lite/frontend/data/models/user_model.dart';
import 'edit_profile_screen.dart';
import 'change_password_screen.dart';

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
              CircleAvatar(
                radius: 50,
                backgroundImage: currentUser?.imagePath != null
                    ? FileImage(File(currentUser!.imagePath!))
                    : null,
                child: currentUser?.imagePath == null
                    ? const Icon(Icons.person, size: 60)
                    : null,
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

                      // الاسم
                      Text(
                        currentUser?.name ?? 'غير معروف',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      // رقم الهاتف
                      Text(
                        'رقم الهاتف: ${currentUser?.phone ?? '---'}',
                        style: const TextStyle(fontSize: 16),
                      ),

                      const SizedBox(height: 8),

                      // البريد الإلكتروني
                      Text(
                        'البريد الإلكتروني: ${currentUser?.email ?? '---'}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // زر تعديل البيانات
              ListTile(
                leading: Icon(Icons.edit, color: primaryColor),
                title: const Text('تعديل البيانات'),
                onTap: () async {
                  final updated = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                  );

                  if (updated == true) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const ProfileScreen()),
                    );
                  }

                },
              ),

              // زر تغيير كلمة المرور
              ListTile(
                leading: Icon(Icons.lock, color: primaryColor),
                title: const Text('تغيير كلمة المرور'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ChangePasswordScreen()),
                  );
                },
              ),


              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
