import 'package:flutter/material.dart';
import '../../../data/api/api_service.dart';

class OrdersManagementScreen extends StatefulWidget {
  const OrdersManagementScreen({super.key});

  @override
  State<OrdersManagementScreen> createState() => _OrdersManagementScreenState();
}

class _OrdersManagementScreenState extends State<OrdersManagementScreen> {
  final TextEditingController _searchController = TextEditingController();

  List<dynamic> allOrders = [];
  List<dynamic> filteredOrders = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    try {
      final data = await ApiService.instance.adminGetAllOrders();

      setState(() {
        allOrders = data;
        filteredOrders = List.from(allOrders);
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
      print("Error loading orders: $e");
    }
  }

  void _filterOrders(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredOrders = List.from(allOrders);
      } else {
        filteredOrders = allOrders.where((order) {
          final service = order["service"];
          return (service?["name_ar"] ?? "")
              .toString()
              .contains(query) ||
              order["id"].toString().contains(query);
        }).toList();
      }
    });
  }

  void _changeStatus(dynamic order) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("تغيير حالة الطلب"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _statusButton(order, "قيد المراجعة"),
            _statusButton(order, "مقبول"),
            _statusButton(order, "مرفوض"),
            _statusButton(order, "مكتمل"),
          ],
        ),
      ),
    );
  }

  Widget _statusButton(dynamic order, String status) {
    return ListTile(
      title: Text(status),
      onTap: () async {
        Navigator.pop(context);

        try {
          await ApiService.instance.adminUpdateOrderStatus(order["id"], status);

          setState(() {
            order["status"] = status;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("تم تحديث الحالة إلى: $status")),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("فشل تحديث الحالة")),
          );
        }
      },
    );
  }

  void _showOrderDetails(dynamic order) {
    final service = order["service"];

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("تفاصيل الطلب رقم ${order["id"]}"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("الخدمة: ${service?["name_ar"] ?? "غير متوفر"}"),
            const SizedBox(height: 6),
            Text("الحالة: ${order["status"]}"),
            Text("التاريخ: ${order["created_at"].toString().substring(0, 10)}"),
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
      case "مقبول":
        return Colors.blue;
      case "مرفوض":
        return Colors.red;
      default:
        return Colors.orange;
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
                  final service = order["service"];

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: primaryColor.withOpacity(0.15),
                      child: Icon(Icons.receipt_long, color: primaryColor),
                    ),
                    title: Text("طلب رقم ${order["id"]}"),
                    subtitle: Text(
                      "${service?["name_ar"] ?? "خدمة غير معروفة"}\n"
                          "التاريخ: ${order["created_at"].toString().substring(0, 10)}",
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // شارة الحالة
                        Container(
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
                        const SizedBox(width: 8),
                        // زر تغيير الحالة
                        IconButton(
                          icon: const Icon(Icons.edit, size: 20),
                          tooltip: "تغيير حالة الطلب",
                          onPressed: () => _changeStatus(order),
                        ),
                      ],
                    ),
                    onTap: () => _showOrderDetails(order),
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
