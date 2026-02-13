import 'package:flutter/material.dart';
import 'package:sawa_lite/data/models/order_model.dart';
import 'package:sawa_lite/data/models/service_model.dart';

class OrderStatusScreen extends StatelessWidget {
  final OrderModel order;
  final ServiceModel service;

  const OrderStatusScreen({
    super.key,
    required this.order,
    required this.service,
  });

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
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('متابعة الطلب'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                service.nameAr,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  const Icon(Icons.info, color: Colors.blue),
                  const SizedBox(width: 8),
                  Text(
                    'حالة الطلب: ',
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    order.status,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _statusColor(order.status),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  const Icon(Icons.calendar_today, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(
                    'تاريخ الإنشاء: ${order.createdAt.toString().substring(0, 10)}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),

              if (order.updatedAt != null) ...[
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(Icons.update, color: Colors.grey),
                    const SizedBox(width: 8),
                    Text(
                      'آخر تحديث: ${order.updatedAt.toString().substring(0, 10)}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ],

              const SizedBox(height: 16),

              if (order.notes != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'ملاحظاتك:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(order.notes!),
                  ],
                ),

              const Spacer(),

              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('رجوع'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
