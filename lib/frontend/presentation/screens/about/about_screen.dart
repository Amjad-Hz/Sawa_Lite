import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Directionality(
      textDirection: TextDirection.rtl,
      child: _AboutScreenBody(),
    );
  }
}

class _AboutScreenBody extends StatefulWidget {
  const _AboutScreenBody();

  @override
  State<_AboutScreenBody> createState() => _AboutScreenBodyState();
}

class _AboutScreenBodyState extends State<_AboutScreenBody> {
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
        title: const Text("حول التطبيق"),
        centerTitle: true,
      ),

      body: AnimatedOpacity(
        duration: const Duration(milliseconds: 400),
        opacity: opacity,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          transform: Matrix4.translationValues(0, offsetY, 0),
          padding: const EdgeInsets.all(20.0),

          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                // logo
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
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  "الإصدار 1.0.0",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 30),

                _infoCard(
                  title: "من نحن",
                  content:
                  "سوا لايت هو تطبيق يهدف إلى تسهيل الوصول إلى الخدمات الحكومية "
                      "بشكل مبسط وسريع، مع واجهة استخدام سهلة ومناسبة لجميع المستخدمين.",
                ),

                const SizedBox(height: 16),

                _infoCard(
                  title: "مهمتنا",
                  content:
                  "تقديم خدمات رقمية موثوقة تساعد المستخدمين على إنجاز معاملاتهم "
                      "الحكومية بسهولة، وتقليل الوقت والجهد المبذول في الإجراءات التقليدية.",
                ),

                const SizedBox(height: 16),

                _infoCard(
                  title: "حقوق التطبيق",
                  content:
                  "جميع الحقوق محفوظة © 2026. هذا التطبيق تم تطويره بهدف تحسين "
                      "تجربة المستخدم وتوفير خدمات حكومية رقمية بشكل فعال.",
                ),

                const SizedBox(height: 16),

                _infoCard(
                  title: "تواصل معنا",
                  content:
                  "للدعم الفني أو الاستفسارات، يمكنك التواصل معنا عبر البريد الإلكتروني:\n"
                      "support@sawa-lite.com",
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoCard({required String title, required String content}) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              content,
              textAlign: TextAlign.start,
              style: const TextStyle(
                fontSize: 15,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
