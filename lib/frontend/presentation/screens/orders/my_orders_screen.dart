import 'package:flutter/material.dart';
import 'package:sawa_lite/frontend/data/api/api_service.dart';
import 'package:sawa_lite/frontend/data/models/order_model.dart';
import 'package:sawa_lite/frontend/data/models/service_model.dart';
import 'order_status_screen.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  bool isLoading = true;
  String? errorMessage;
  List<OrderModel> orders = [];

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    try {
      final data = await ApiService.instance.getMyOrders();

      orders = data.map<OrderModel>((json) => OrderModel.fromJson(json)).toList();

      setState(() => isLoading = false);
    } catch (e) {
      setState(() {
        errorMessage = "فشل تحميل الطلبات: $e";
        isLoading = false;
      });
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'مكتمل':
        return Colors.green;
      case 'مرفوض':
        return Colors.red;
      case 'مقبول':
        return Colors.blue;
      default:
        return Colors.orange; // قيد المراجعة
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("طلباتي"),
          centerTitle: true,
        ),

        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : errorMessage != null
            ? Center(child: Text(errorMessage!))
            : RefreshIndicator(
          onRefresh: _loadOrders,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];

              return Card(
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // رقم الطلب
                      Row(
                        children: [
                          Icon(Icons.receipt_long,
                              color: primaryColor),
                          const SizedBox(width: 8),
                          Text(
                            "طلب رقم: ${order.id}",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // اسم الخدمة
                      Text(
                        order.serviceName ?? "خدمة غير معروفة",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),

                      const SizedBox(height: 8),

                      // حالة الطلب
                      Row(
                        children: [
                          const Icon(Icons.info_outline,
                              size: 20, color: Colors.grey),
                          const SizedBox(width: 6),
                          Text(
                            "الحالة: ",
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            order.status,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: _statusColor(order.status),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // تاريخ الطلب
                      Row(
                        children: [
                          const Icon(Icons.calendar_today,
                              size: 18, color: Colors.grey),
                          const SizedBox(width: 6),
                          Text(
                            "تاريخ الطلب: ${order.createdAt.toString().substring(0, 10)}",
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // زر متابعة الطلب
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => OrderStatusScreen(
                                  order: order,
                                  service: ServiceModel(
                                    id: order.serviceId,
                                    nameAr: order.serviceName ?? "خدمة",
                                    description: null,
                                    category: null,
                                    durationDays: null,
                                    cost: 0,
                                    isActive: true,
                                  ),
                                ),
                              ),
                            );
                          },
                          child: const Text(
                            "متابعة الطلب",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
