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
    final primaryColor = Theme.of(context).primaryColor;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('متابعة الطلب'),
          centerTitle: true,
        ),

        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // عنوان الخدمة
              Text(
                service.nameAr,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              // بطاقة حالة الطلب
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  leading: Icon(Icons.info, color: primaryColor),
                  title: const Text(
                    'حالة الطلب:',
                    style: TextStyle(fontSize: 16),
                  ),
                  subtitle: Text(
                    order.status,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _statusColor(order.status),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // بطاقة تاريخ الإنشاء
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  leading: const Icon(Icons.calendar_today, color: Colors.grey),
                  title: Text(
                    'تاريخ الإنشاء: ${order.createdAt.toString().substring(0, 10)}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),

              if (order.updatedAt != null) ...[
                const SizedBox(height: 12),

                // بطاقة آخر تحديث
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.update, color: Colors.grey),
                    title: Text(
                      'آخر تحديث: ${order.updatedAt.toString().substring(0, 10)}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 12),

              // بطاقة الملاحظات
              if (order.notes != null && order.notes!.isNotEmpty)
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
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
                  ),
                ),

              const Spacer(),

              // زر الرجوع
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'رجوع',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
