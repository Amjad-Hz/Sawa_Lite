import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'frontend/core/theme/light_theme.dart';
import 'frontend/core/theme/dark_theme.dart';
import 'frontend/core/theme/theme_controller.dart';
import 'frontend/presentation/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // تحميل السيم من SharedPreferences
  await ThemeController.instance.loadTheme();

  runApp(const SawaLiteApp());
}

class SawaLiteApp extends StatelessWidget {
  const SawaLiteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: ThemeController.instance.isDark,
      builder: (context, isDark, _) {
        return MaterialApp(
          title: 'سوا لايت',
          debugShowCheckedModeBanner: false,

          // 🔥 الأنيميشن العالمي كما هو
          theme: buildLightTheme().copyWith(
            pageTransitionsTheme: const PageTransitionsTheme(
              builders: {
                TargetPlatform.android: _CustomTransitionBuilder(),
                TargetPlatform.iOS: _CustomTransitionBuilder(),
              },
            ),
          ),

          darkTheme: buildDarkTheme(),
          themeMode: isDark ? ThemeMode.dark : ThemeMode.light,

          locale: const Locale('ar'),
          supportedLocales: const [
            Locale('ar'),
          ],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],

          home: const SplashScreen(),
        );
      },
    );
  }
}

// 🔥 كلاس الأنيميشن العالمي
class _CustomTransitionBuilder extends PageTransitionsBuilder {
  const _CustomTransitionBuilder();

  @override
  Widget buildTransitions<T>(
      PageRoute<T> route,
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
      ) {
    // لا نضيف أنيميشن للصفحة الأولى (Splash)
    if (route.settings.name == '/') {
      return child;
    }

    final slide = Tween<Offset>(
      begin: const Offset(0.1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: animation,
      curve: Curves.easeOut,
    ));

    final fade = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(animation);

    return FadeTransition(
      opacity: fade,
      child: SlideTransition(
        position: slide,
        child: child,
      ),
    );
  }
}
