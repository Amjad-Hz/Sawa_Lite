import 'package:flutter/material.dart';
import '../../../data/user_prefs.dart';
import 'package:sawa_lite/frontend/data/models/user_model.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _changePassword() async {
    if (!_formKey.currentState!.validate()) return;

    currentUser = UserModel(
      id: currentUser!.id,
      phone: currentUser!.phone,
      email: currentUser!.email,
      fullName: currentUser!.fullName,
      password: _newPasswordController.text,
      role: currentUser!.role,
    );

    await UserPrefs.saveUser(currentUser!);

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("تغيير كلمة المرور"),
          centerTitle: true,
        ),

        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _currentPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "كلمة المرور الحالية",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value != currentUser!.password) {
                      return "كلمة المرور الحالية غير صحيحة";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                TextFormField(
                  controller: _newPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "كلمة المرور الجديدة",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.length < 4) {
                      return "كلمة المرور الجديدة قصيرة";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "تأكيد كلمة المرور الجديدة",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value != _newPasswordController.text) {
                      return "كلمتا المرور غير متطابقتين";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _changePassword,
                    child: const Text("حفظ كلمة المرور"),
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
