import 'package:flutter/material.dart';
import 'services/services_list_screen.dart';
import 'about/about_screen.dart';
import '../../data/models/user_model.dart';
import '../../data/user_prefs.dart';
import 'auth/login_screen.dart';
import 'settings/settings_screen.dart';
import 'profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    _MainHomePage(),
    ServicesListScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("سوا لايت"),
          centerTitle: true,
        ),

        drawer: Drawer(
          child: TweenAnimationBuilder(
            duration: const Duration(milliseconds: 400),
            tween: Tween<double>(begin: 0, end: 1),
            curve: Curves.easeOut,
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset((1 - value) * 40, 0),
                  child: child,
                ),
              );
            },
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/logo.png',
                        width: 90,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "سوا لايت",
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),

                const Divider(),

                ListTile(
                  leading: Icon(Icons.list, color: primaryColor),
                  title: const Text("عرض الخدمات"),
                  onTap: () {
                    setState(() => _currentIndex = 1);
                    Navigator.pop(context);
                  },
                ),

                ListTile(
                  leading: Icon(Icons.settings, color: primaryColor),
                  title: const Text("الإعدادات"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SettingsScreen()),
                    );
                  },
                ),

                ListTile(
                  leading: Icon(Icons.info_outline, color: primaryColor),
                  title: const Text("حول التطبيق"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AboutScreen()),
                    );
                  },
                ),

                const Spacer(),

                ListTile(
                  leading: const Icon(Icons.person, color: Colors.blue),
                  title: const Text("الملف الشخصي"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ProfileScreen()),
                    );
                  },
                ),

                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text(
                    "تسجيل الخروج",
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () async {
                    Navigator.pop(context); // إغلاق القائمة الجانبية

                    // نافذة التأكيد
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) {
                        return Directionality(
                          textDirection: TextDirection.rtl,
                          child: AlertDialog(
                            title: const Text("تأكيد تسجيل الخروج"),
                            content: const Text("هل أنت متأكد أنك تريد تسجيل الخروج؟"),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text("إلغاء"),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text(
                                  "تسجيل الخروج",
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );

                    // إذا وافق المستخدم
                    if (confirm == true) {
                      await UserPrefs.clearUser();
                      currentUser = null;

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      );
                    }
                  },
                ),


              ],
            ),
          ),
        ),

        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.05, 0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            );
          },
          child: _pages[_currentIndex],
        ),

        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          selectedItemColor: primaryColor,
          unselectedItemColor: Colors.grey,
          onTap: (index) {
            setState(() => _currentIndex = index);
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "الرئيسية",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: "الخدمات",
            ),
          ],
        ),
      ),
    );
  }
}

// --------------------------------------------------
// 🔥 الصفحة الرئيسية مع Animation للبطاقات + Animation الضغط
// --------------------------------------------------
class _MainHomePage extends StatelessWidget {
  const _MainHomePage();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: [
          _buildServiceCard(
            context,
            icon: Icons.list,
            title: "عرض الخدمات",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ServicesListScreen(),
                ),
              );
            },
          ),
          _buildServiceCard(
            context,
            icon: Icons.person,
            title: "الملف الشخصي",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ProfileScreen(),
                ),
              );
            },
          ),
          _buildServiceCard(
            context,
            icon: Icons.home,
            title: "السجل العقاري",
            onTap: () {},
          ),
          _buildServiceCard(
            context,
            icon: Icons.car_rental,
            title: "خدمات المركبات",
            onTap: () {},
          ),
          _buildServiceCard(
            context,
            icon: Icons.health_and_safety,
            title: "التأمين الصحي",
            onTap: () {},
          ),
          _buildServiceCard(
            context,
            icon: Icons.account_balance,
            title: "الدوائر الحكومية",
            onTap: () {},
          ),
        ],
      ),
    );
  }

  static Widget _buildServiceCard(
      BuildContext context, {
        required IconData icon,
        required String title,
        required VoidCallback onTap,
      }) {
    final primaryColor = Theme.of(context).primaryColor;

    return StatefulBuilder(
      builder: (context, setState) {
        double scale = 1.0;

        return GestureDetector(
          onTapDown: (_) => setState(() => scale = 0.95),
          onTapUp: (_) => setState(() => scale = 1.0),
          onTapCancel: () => setState(() => scale = 1.0),
          onTap: onTap,
          child: TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 450),
            curve: Curves.easeOut,
            tween: Tween(begin: 0, end: 1),
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, 20 * (1 - value)),
                  child: AnimatedScale(
                    scale: scale,
                    duration: const Duration(milliseconds: 120),
                    child: child,
                  ),
                ),
              );
            },
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon, size: 48, color: primaryColor),
                    const SizedBox(height: 12),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
