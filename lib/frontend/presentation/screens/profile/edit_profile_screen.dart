import 'package:flutter/material.dart';
import 'package:sawa_lite/frontend/data/models/user_model.dart';
import '../../../data/user_prefs.dart';
import '../../../data/api/api_service.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: currentUser?.fullName ?? "");
    _phoneController = TextEditingController(text: currentUser?.phone ?? "");
    _emailController = TextEditingController(text: currentUser?.email ?? "");
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      await ApiService.instance.updateUser(
        fullName: _nameController.text,
        phone: _phoneController.text,
        email: _emailController.text,
      );

      final updated = await ApiService.instance.getMe();

      currentUser = UserModel.fromJson(updated);
      await UserPrefs.saveUser(currentUser!);

      Navigator.pop(context, true);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("تم تحديث البيانات بنجاح")),
      );

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("فشل تحديث البيانات: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("تعديل الملف الشخصي"),
          centerTitle: true,
        ),

        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 55,
                    backgroundColor: primaryColor.withOpacity(0.15),
                    child: Icon(Icons.person, size: 60, color: primaryColor),
                  ),
                ),

                const SizedBox(height: 24),

                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: "الاسم الكامل",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                  value == null || value.isEmpty ? "الرجاء إدخال الاسم" : null,
                ),

                const SizedBox(height: 16),

                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: "رقم الهاتف",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                  value == null || value.isEmpty ? "الرجاء إدخال رقم الهاتف" : null,
                ),

                const SizedBox(height: 16),

                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: "البريد الإلكتروني",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                  value == null || value.isEmpty ? "الرجاء إدخال البريد الإلكتروني" : null,
                ),

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveChanges,
                    child: const Text("حفظ التعديلات"),
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
