import 'package:flutter/material.dart';
import '../../../core/theme/theme_controller.dart';
import '../about/about_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Directionality(
      textDirection: TextDirection.rtl,
      child: _SettingsBody(),
    );
  }
}

class _SettingsBody extends StatefulWidget {
  const _SettingsBody();

  @override
  State<_SettingsBody> createState() => _SettingsBodyState();
}

class _SettingsBodyState extends State<_SettingsBody> {
  double opacity = 0;
  double offsetY = 20;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        setState(() {
          opacity = 1;
          offsetY = 0;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text("الإعدادات"),
        centerTitle: true,
      ),

      body: AnimatedOpacity(
        duration: const Duration(milliseconds: 400),
        opacity: opacity,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          transform: Matrix4.translationValues(0, offsetY, 0),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // -------------------------------
              // قسم الحساب
              // -------------------------------
              _sectionTitle("الحساب"),

              _settingsCard(
                icon: Icons.language,
                title: "اللغة",
                subtitle: "العربية",
                onTap: () {},
              ),

              const SizedBox(height: 10),

              // -------------------------------
              // قسم التطبيق
              // -------------------------------
              _sectionTitle("التطبيق"),

              ValueListenableBuilder<bool>(
                valueListenable: ThemeController.instance.isDark,
                builder: (context, isDark, _) {
                  return _switchCard(
                    icon: Icons.dark_mode,
                    title: "الوضع الليلي",
                    value: isDark,
                    onChanged: (value) {
                      ThemeController.instance.toggleTheme(value);
                    },
                  );
                },
              ),

              const SizedBox(height: 10),

              _settingsCard(
                icon: Icons.info_outline,
                title: "حول التطبيق",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AboutScreen()),
                  );
                },
              ),


              const SizedBox(height: 10),

              // -------------------------------
              // قسم الدعم
              // -------------------------------
              _sectionTitle("الدعم"),

              _settingsCard(
                icon: Icons.help_outline,
                title: "مركز المساعدة",
                onTap: () {},
              ),

              const SizedBox(height: 10),

              _settingsCard(
                icon: Icons.contact_support,
                title: "اتصل بنا",
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  // -------------------------------
  // عنصر عنوان القسم
  // -------------------------------
  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 16),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // -------------------------------
  // بطاقة إعدادات عادية
  // -------------------------------
  Widget _settingsCard({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    final primaryColor = Theme.of(context).primaryColor;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        leading: Icon(icon, color: primaryColor),
        title: Text(title),
        subtitle: subtitle != null ? Text(subtitle) : null,
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  // -------------------------------
  // بطاقة إعدادات مع Switch
  // -------------------------------
  Widget _switchCard({
    required IconData icon,
    required String title,
    required bool value,
    required Function(bool) onChanged,
  }) {
    final primaryColor = Theme.of(context).primaryColor;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: SwitchListTile(
        secondary: Icon(icon, color: primaryColor),
        title: Text(title),
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}
