import 'package:flutter/material.dart';
import '../../../data/api/api_service.dart';

class UsersManagementScreen extends StatefulWidget {
  const UsersManagementScreen({super.key});

  @override
  State<UsersManagementScreen> createState() => _UsersManagementScreenState();
}

class _UsersManagementScreenState extends State<UsersManagementScreen> {
  final TextEditingController _searchController = TextEditingController();

  List<dynamic> allUsers = [];
  List<dynamic> filteredUsers = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    try {
      final data = await ApiService.instance.adminGetAllUsers();

      setState(() {
        allUsers = data;
        filteredUsers = List.from(allUsers);
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
      print("Error loading users: $e");
    }
  }

  void _filterUsers(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredUsers = List.from(allUsers);
      } else {
        filteredUsers = allUsers.where((u) {
          return u["full_name"].toString().contains(query) ||
              u["phone"].toString().contains(query) ||
              u["email"].toString().contains(query);
        }).toList();
      }
    });
  }

  void _changeRole(dynamic user) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("تغيير دور ${user["full_name"]}"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _roleButton(user, "user", "مستخدم عادي"),
            _roleButton(user, "admin", "مشرف (Admin)"),
          ],
        ),
      ),
    );
  }

  Widget _roleButton(dynamic user, String role, String label) {
    return ListTile(
      title: Text(label),
      onTap: () async {
        Navigator.pop(context);

        try {
          final updated = await ApiService.instance.adminUpdateUserRole(
            user["id"],
            role,
          );

          setState(() {
            final index = allUsers.indexWhere((u) => u["id"] == user["id"]);
            allUsers[index] = updated;
            filteredUsers = List.from(allUsers);
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("تم تغيير الدور إلى: $label")),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("فشل تغيير الدور")),
          );
        }
      },
    );
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

        body: loading
            ? const Center(child: CircularProgressIndicator())
            : Column(
          children: [
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
                        user["is_verified"]
                            ? Icons.verified
                            : Icons.person,
                        color: primaryColor,
                      ),
                    ),
                    title: Text(user["full_name"]),
                    subtitle: Text(
                      "${user["phone"]} • ${user["email"]}\n"
                          "الدور: ${user["role"] ?? "user"}",
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == "role") {
                          _changeRole(user);
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: "role",
                          child: Text("تغيير الدور"),
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
