import 'package:flutter/material.dart';
import '../../../core/theme/theme_controller.dart';

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

class _SettingsBody extends StatelessWidget {
  const _SettingsBody();

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text("الإعدادات"),
        centerTitle: true,
      ),

      body: ListView(
        children: [
          const SizedBox(height: 10),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "الحساب",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          ListTile(
            leading: Icon(Icons.language, color: primaryColor),
            title: const Text("اللغة"),
            onTap: () {},
          ),

          const Divider(),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "التطبيق",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // 🔥 زر الوضع الليلي يعمل الآن
          ValueListenableBuilder<bool>(
            valueListenable: ThemeController.instance.isDark,
            builder: (context, isDark, _) {
              return SwitchListTile(
                title: const Text("الوضع الليلي"),
                secondary: Icon(Icons.dark_mode, color: primaryColor),
                value: isDark,
                onChanged: (value) {
                  ThemeController.instance.toggleTheme(value);
                },
              );
            },
          ),

          ListTile(
            leading: Icon(Icons.info, color: primaryColor),
            title: const Text("حول التطبيق"),
            onTap: () {},
          ),

          const Divider(),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "الدعم",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          ListTile(
            leading: Icon(Icons.help, color: primaryColor),
            title: const Text("مركز المساعدة"),
            onTap: () {},
          ),

          ListTile(
            leading: Icon(Icons.contact_support, color: primaryColor),
            title: const Text("اتصل بنا"),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
