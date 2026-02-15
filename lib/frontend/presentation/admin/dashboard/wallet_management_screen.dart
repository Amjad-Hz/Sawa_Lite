import 'package:flutter/material.dart';

class WalletManagementScreen extends StatefulWidget {
  const WalletManagementScreen({super.key});

  @override
  State<WalletManagementScreen> createState() => _WalletManagementScreenState();
}

class _WalletManagementScreenState extends State<WalletManagementScreen> {
  final TextEditingController _searchController = TextEditingController();

  // بيانات تجريبية — لاحقًا تربطها بالباكند
  List<Map<String, dynamic>> allUsers = [
    {"id": 1, "name": "مستخدم تجريبي 1", "balance": 50000},
    {"id": 2, "name": "مستخدم تجريبي 2", "balance": 120000},
    {"id": 3, "name": "مستخدم تجريبي 3", "balance": 80000},
  ];

  List<Map<String, dynamic>> filteredUsers = [];

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
          return u["name"].toString().contains(query) ||
              u["id"].toString().contains(query);
        }).toList();
      }
    });
  }

  void _addBalance(Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (_) => _BalanceDialog(
        title: "إضافة رصيد",
        onSave: (amount) {
          setState(() {
            user["balance"] += amount;
          });
        },
      ),
    );
  }

  void _deductBalance(Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (_) => _BalanceDialog(
        title: "خصم رصيد",
        onSave: (amount) {
          setState(() {
            user["balance"] -= amount;
            if (user["balance"] < 0) user["balance"] = 0;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    // حساب الرصيد الإجمالي للنظام
    final totalBalance = allUsers.fold<int>(
      0,
          (sum, u) => sum + (u["balance"] as int),
    );

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("إدارة الرصيد"),
          centerTitle: true,
        ),

        body: Column(
          children: [
            // بطاقة الرصيد الإجمالي
            Card(
              margin: const EdgeInsets.all(12),
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: primaryColor.withOpacity(0.15),
                  child: Icon(Icons.account_balance_wallet, color: primaryColor),
                ),
                title: const Text(
                  "إجمالي رصيد النظام",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text("$totalBalance ل.س"),
              ),
            ),

            // حقل البحث
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: "بحث عن مستخدم...",
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
                      child: Icon(Icons.person, color: primaryColor),
                    ),
                    title: Text(user["name"]),
                    subtitle: Text("الرصيد: ${user["balance"]} ل.س"),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == "add") {
                          _addBalance(user);
                        } else if (value == "deduct") {
                          _deductBalance(user);
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: "add",
                          child: Text("إضافة رصيد"),
                        ),
                        const PopupMenuItem(
                          value: "deduct",
                          child: Text(
                            "خصم رصيد",
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

// --------------------------------------------------
// نافذة إضافة/خصم رصيد
// --------------------------------------------------
class _BalanceDialog extends StatefulWidget {
  final String title;
  final Function(int amount) onSave;

  const _BalanceDialog({
    required this.title,
    required this.onSave,
  });

  @override
  State<_BalanceDialog> createState() => _BalanceDialogState();
}

class _BalanceDialogState extends State<_BalanceDialog> {
  final TextEditingController _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: TextField(
        controller: _amountController,
        decoration: const InputDecoration(labelText: "المبلغ"),
        keyboardType: TextInputType.number,
      ),
      actions: [
        TextButton(
          child: const Text("إلغاء"),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
          child: const Text("حفظ"),
          onPressed: () {
            final amount = int.tryParse(_amountController.text.trim()) ?? 0;
            if (amount > 0) {
              widget.onSave(amount);
              Navigator.pop(context);
            }
          },
        ),
      ],
    );
  }
}
