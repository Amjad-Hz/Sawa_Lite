import 'package:flutter/material.dart';
import 'services/services_list_screen.dart';
import 'about/about_screen.dart';
import '../../data/models/user_model.dart';
import '../../data/user_prefs.dart';
import 'auth/login_screen.dart';
import 'settings/settings_screen.dart';
import 'profile/profile_screen.dart';
import 'package:sawa_lite/frontend/presentation/community/community_screen.dart';
import 'package:sawa_lite/frontend/presentation/screens/orders/my_orders_screen.dart';
import 'package:sawa_lite/frontend/presentation/screens/wallet/wallet_screen.dart';

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
    MyOrdersScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Sawa Lite"),
          centerTitle: true,
          elevation: 2,
        ),

        drawer: Drawer(
          child: Column(
            children: [
              // ---------------------------
              // رأس القائمة
              // ---------------------------
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 40),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: primaryColor.withOpacity(0.2),
                      child: Icon(Icons.person, size: 50, color: primaryColor),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      currentUser?.fullName ?? "مستخدم",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),

              // ---------------------------
              // عناصر القائمة
              // ---------------------------
              Expanded(
                child: ListView(
                  children: [
                    // القسم الأول — الصفحات الأساسية
                    _drawerItem(
                      icon: Icons.home,
                      title: "الرئيسية",
                      onTap: () {
                        setState(() => _currentIndex = 0);
                        Navigator.pop(context);
                      },
                    ),

                    _drawerItem(
                      icon: Icons.list,
                      title: "عرض الخدمات",
                      onTap: () {
                        setState(() => _currentIndex = 1);
                        Navigator.pop(context);
                      },
                    ),

                    _drawerItem(
                      icon: Icons.receipt_long,
                      title: "طلباتي",
                      onTap: () {
                        setState(() => _currentIndex = 2);
                        Navigator.pop(context);
                      },
                    ),

                    _drawerItem(
                      icon: Icons.account_balance_wallet,
                      title: "المحفظة",
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const WalletScreen()),
                        );
                      },
                    ),

                    const Divider(),

                    // القسم الثاني — الحساب والإعدادات
                    _drawerItem(
                      icon: Icons.person,
                      title: "الملف الشخصي",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ProfileScreen()),
                        );
                      },
                    ),

                    _drawerItem(
                      icon: Icons.settings,
                      title: "الإعدادات",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const SettingsScreen()),
                        );
                      },
                    ),

                    const Divider(),

                    // القسم الثالث — معلومات إضافية
                    _drawerItem(
                      icon: Icons.forum,
                      title: "المجتمع",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const CommunityScreen()),
                        );
                      },
                    ),

                    _drawerItem(
                      icon: Icons.info_outline,
                      title: "حول التطبيق",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const AboutScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const Divider(),

              // ---------------------------
              // تسجيل الخروج
              // ---------------------------
              _drawerItem(
                icon: Icons.logout,
                title: "تسجيل الخروج",
                color: Colors.red,
                onTap: () async {
                  Navigator.pop(context);

                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (_) => AlertDialog(
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

                  if (confirm == true) {
                    await UserPrefs.clearToken();
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

        // ---------------------------
        // محتوى الصفحات
        // ---------------------------
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

        // ---------------------------
        // Bottom Navigation
        // ---------------------------
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          selectedItemColor: primaryColor,
          unselectedItemColor: Colors.grey,
          elevation: 8,
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
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long),
              label: "طلباتي",
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? color,
  }) {
    final primaryColor = Theme.of(context).primaryColor;

    return ListTile(
      leading: Icon(icon, color: color ?? primaryColor),
      title: Text(
        title,
        style: TextStyle(
          color: color ?? Colors.black87,
          fontWeight: FontWeight.w600,
        ),
      ),
      onTap: onTap,
    );
  }
}

class _MainHomePage extends StatelessWidget {
  const _MainHomePage();

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: [
          _buildCard(
            context,
            icon: Icons.list,
            title: "عرض الخدمات",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ServicesListScreen()),
              );
            },
          ),
          _buildCard(
            context,
            icon: Icons.forum,
            title: "المجتمع",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CommunityScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  static Widget _buildCard(
      BuildContext context, {
        required IconData icon,
        required String title,
        required VoidCallback onTap,
      }) {
    final primaryColor = Theme.of(context).primaryColor;

    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: primaryColor),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
