import 'package:flutter/material.dart';
import '../../../data/models/user_model.dart';

class UsersManagementScreen extends StatefulWidget {
  const UsersManagementScreen({super.key});

  @override
  State<UsersManagementScreen> createState() => _UsersManagementScreenState();
}

class _UsersManagementScreenState extends State<UsersManagementScreen> {
  final TextEditingController _searchController = TextEditingController();

  // مبدئيًا بيانات تجريبية – لاحقًا تربطها مع الباكند
  List<UserModel> allUsers = [
    UserModel(
      id: 1,
      phone: "0999999999",
      email: "user1@test.com",
      fullName: "مستخدم تجريبي 1",
      password: "1234",
      role: "user",
    ),
    UserModel(
      id: 2,
      phone: "0988888888",
      email: "admin@test.com",
      fullName: "مدير النظام",
      password: "admin",
      role: "admin",
    ),
  ];

  List<UserModel> filteredUsers = [];

  @override
  void initState() {
    super.initState();
    filteredUsers = List.from(allUsers);
  }

  void _filterUsers(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredUsers = List.from(allUsers);
      } else {
        filteredUsers = allUsers.where((u) {
          return u.fullName.contains(query) ||
              u.phone.contains(query) ||
              u.email.contains(query);
        }).toList();
      }
    });
  }

  void _deleteUser(UserModel user) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("حذف مستخدم"),
        content: Text("هل أنت متأكد من حذف المستخدم: ${user.fullName}؟"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("إلغاء"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              "حذف",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() {
        allUsers.removeWhere((u) => u.id == user.id);
        filteredUsers.removeWhere((u) => u.id == user.id);
      });

      // لاحقًا: استدعاء API لحذف المستخدم من الباكند
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("إدارة المستخدمين"),
          centerTitle: true,
        ),

        body: Column(
          children: [
            // حقل البحث
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: "بحث عن مستخدم بالاسم أو الرقم أو الإيميل",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onChanged: _filterUsers,
              ),
            ),

            Expanded(
              child: ListView.separated(
                itemCount: filteredUsers.length,
                separatorBuilder: (_, __) => const Divider(height: 0),
                itemBuilder: (context, index) {
                  final user = filteredUsers[index];

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: primaryColor.withOpacity(0.15),
                      child: Icon(
                        user.role == "admin" ? Icons.verified_user : Icons.person,
                        color: primaryColor,
                      ),
                    ),
                    title: Text(user.fullName),
                    subtitle: Text("${user.phone} • ${user.email}"),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == "delete") {
                          _deleteUser(user);
                        } else if (value == "edit") {
                          // لاحقًا: شاشة تعديل مستخدم
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: "edit",
                          child: Text("تعديل"),
                        ),
                        const PopupMenuItem(
                          value: "delete",
                          child: Text(
                            "حذف",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
