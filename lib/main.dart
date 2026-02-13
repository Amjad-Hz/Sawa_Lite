import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/theme/light_theme.dart';
import 'presentation/screens/auth/login_screen.dart';

void main() {
  runApp(const SawaLiteApp());
}

class SawaLiteApp extends StatelessWidget {
  const SawaLiteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'سوا لايت',
      debugShowCheckedModeBanner: false,
      theme: buildLightTheme(),
      locale: const Locale('ar'),
      supportedLocales: const [
        Locale('ar'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const LoginScreen(),
    );

  }
}
