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
              CircleAvatar(
                radius: 55,
                backgroundColor: primaryColor.withOpacity(0.15),
                child: Icon(Icons.person, size: 60, color: primaryColor),
              ),

              const SizedBox(height: 16),

              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentUser?.fullName ?? 'غير معروف',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 12),

                      Row(
                        children: [
                          Icon(Icons.phone, color: primaryColor),
                          const SizedBox(width: 8),
                          Text(currentUser?.phone ?? '---'),
                        ],
                      ),

                      const SizedBox(height: 12),

                      Row(
                        children: [
                          Icon(Icons.email, color: primaryColor),
                          const SizedBox(width: 8),
                          Text(currentUser?.email ?? '---'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              ListTile(
                leading: Icon(Icons.edit, color: primaryColor),
                title: const Text('تعديل البيانات'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                  );
                },
              ),

              ListTile(
                leading: Icon(Icons.lock, color: primaryColor),
                title: const Text('تغيير كلمة المرور'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 18),
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
