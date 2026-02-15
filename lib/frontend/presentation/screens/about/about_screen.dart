import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return const Directionality(
      textDirection: TextDirection.rtl,
      child: _AboutScreenBody(),
    );
  }
}

class _AboutScreenBody extends StatelessWidget {
  const _AboutScreenBody();

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text("حول التطبيق"),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            // الشعار
            Image.asset(
              'assets/logo.png',
              width: 120,
              height: 120,
              fit: BoxFit.contain,
            ),

            const SizedBox(height: 20),

            Text(
              "سوا لايت",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "الإصدار 1.0.0",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 30),

            // بطاقة الوصف الرئيسي
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "سوا لايت هو تطبيق يهدف إلى تسهيل الوصول إلى الخدمات الحكومية "
                      "بشكل مبسط وسريع، مع واجهة استخدام سهلة ومناسبة لجميع المستخدمين.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.6,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // بطاقة إضافية
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "تم تطوير هذا التطبيق بهدف تحسين تجربة المستخدم "
                      "وتوفير خدمات حكومية رقمية بشكل فعال.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.6,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
