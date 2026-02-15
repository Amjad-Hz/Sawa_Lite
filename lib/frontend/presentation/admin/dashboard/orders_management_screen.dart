import 'package:flutter/material.dart';

class OrdersManagementScreen extends StatefulWidget {
  const OrdersManagementScreen({super.key});

  @override
  State<OrdersManagementScreen> createState() => _OrdersManagementScreenState();
}

class _OrdersManagementScreenState extends State<OrdersManagementScreen> {
  final TextEditingController _searchController = TextEditingController();

  // بيانات تجريبية — لاحقًا تربطها بالباكند
  List<Map<String, dynamic>> allOrders = [
    {
      "id": 101,
      "user": "مستخدم تجريبي 1",
      "service": "استخراج بيان عائلي",
      "status": "قيد التنفيذ",
      "price": 15000,
      "date": "2026-02-10"
    },
    {
      "id": 102,
      "user": "مستخدم تجريبي 2",
      "service": "تجديد رخصة قيادة",
      "status": "مكتمل",
      "price": 30000,
      "date": "2026-02-11"
    },
    {
      "id": 103,
      "user": "مستخدم تجريبي 3",
      "service": "معاملة سجل عقاري",
      "status": "جديد",
      "price": 20000,
      "date": "2026-02-12"
    },
  ];

  List<Map<String, dynamic>> filteredOrders = [];

  @override
  void initState() {
    super.initState();
    filteredOrders = List.from(allOrders);
  }

  void _filterOrders(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredOrders = List.from(allOrders);
      } else {
        filteredOrders = allOrders.where((order) {
          return order["user"].toString().contains(query) ||
              order["service"].toString().contains(query) ||
              order["id"].toString().contains(query);
        }).toList();
      }
    });
  }

  void _changeStatus(Map<String, dynamic> order) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("تغيير حالة الطلب"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _statusButton(order, "جديد"),
            _statusButton(order, "قيد التنفيذ"),
            _statusButton(order, "مكتمل"),
            _statusButton(order, "مرفوض"),
          ],
        ),
      ),
    );
  }

  Widget _statusButton(Map<String, dynamic> order, String status) {
    return ListTile(
      title: Text(status),
      onTap: () {
        setState(() {
          order["status"] = status;
        });
        Navigator.pop(context);

        // لاحقًا: إرسال الحالة الجديدة للباكند
      },
    );
  }

  void _showOrderDetails(Map<String, dynamic> order) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("تفاصيل الطلب رقم ${order["id"]}"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("المستخدم: ${order["user"]}"),
            Text("الخدمة: ${order["service"]}"),
            Text("السعر: ${order["price"]} ل.س"),
            Text("الحالة: ${order["status"]}"),
            Text("التاريخ: ${order["date"]}"),
          ],
        ),
        actions: [
          TextButton(
            child: const Text("إغلاق"),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case "مكتمل":
        return Colors.green;
      case "قيد التنفيذ":
        return Colors.orange;
      case "مرفوض":
        return Colors.red;
      default:
        return Colors.blueGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("إدارة الطلبات"),
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
                  hintText: "بحث عن طلب...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onChanged: _filterOrders,
              ),
            ),

            Expanded(
              child: ListView.separated(
                itemCount: filteredOrders.length,
                separatorBuilder: (_, __) => const Divider(height: 0),
                itemBuilder: (context, index) {
                  final order = filteredOrders[index];

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: primaryColor.withOpacity(0.15),
                      child: Icon(Icons.receipt_long, color: primaryColor),
                    ),
                    title: Text("طلب رقم ${order["id"]}"),
                    subtitle: Text("${order["service"]} • ${order["user"]}"),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _statusColor(order["status"]).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        order["status"],
                        style: TextStyle(
                          color: _statusColor(order["status"]),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    onTap: () => _showOrderDetails(order),
                    onLongPress: () => _changeStatus(order),
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
