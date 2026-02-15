import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:sawa_lite/frontend/data/api/api_service.dart';
import 'package:sawa_lite/frontend/data/models/order_model.dart';
import 'package:sawa_lite/frontend/data/models/service_model.dart';

class OrderStatusScreen extends StatefulWidget {
  final OrderModel order;
  final ServiceModel service;

  const OrderStatusScreen({
    super.key,
    required this.order,
    required this.service,
  });

  @override
  State<OrderStatusScreen> createState() => _OrderStatusScreenState();
}

class _OrderStatusScreenState extends State<OrderStatusScreen> {
  bool isLoading = true;
  bool isRefreshing = false;
  bool isPaying = false;
  String? errorMessage;
  OrderModel? updatedOrder;

  @override
  void initState() {
    super.initState();
    _loadOrder();
  }

  Future<void> _loadOrder() async {
    try {
      final response =
      await ApiService.instance.getOrderById(widget.order.id);

      setState(() {
        updatedOrder = OrderModel.fromJson(response);
        isLoading = false;
        isRefreshing = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = "فشل تحميل حالة الطلب: $e";
        isLoading = false;
        isRefreshing = false;
      });
    }
  }

  // الحالات التي يسمح فيها بالدفع
  bool _canPay(String status) {
    return status == 'قيد المراجعة' || status == 'مقبول';
  }

  // الطلب مدفوع إذا كان مكتمل
  bool _isPaid(OrderModel order) {
    return order.status == 'مكتمل';
  }

  Future<void> _payForOrder() async {
    setState(() {
      isPaying = true;
      errorMessage = null;
    });

    try {
      await ApiService.instance.payForOrder(widget.order.id);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم الدفع بنجاح من المحفظة')),
        );
      }

      await _loadOrder();
    } catch (e) {
      if (mounted) {
        String message = "فشل الدفع";

        if (e is DioException && e.response != null) {
          message = e.response!.data['detail'] ?? message;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isPaying = false;
        });
      }
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
    final order = updatedOrder ?? widget.order;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('متابعة الطلب'),
          centerTitle: true,
          actions: [
            IconButton(
              icon: isRefreshing
                  ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
                  : const Icon(Icons.refresh),
              onPressed: () {
                setState(() => isRefreshing = true);
                _loadOrder();
              },
            ),
          ],
        ),

        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : errorMessage != null
            ? Center(child: Text(errorMessage!))
            : Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // اسم الخدمة
              Text(
                widget.service.nameAr,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              // حالة الطلب
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

              // تاريخ الإنشاء
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  leading: const Icon(Icons.calendar_today,
                      color: Colors.grey),
                  title: Text(
                    'تاريخ الإنشاء: ${order.createdAt.toString().substring(0, 10)}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),

              // آخر تحديث
              if (order.updatedAt != null) ...[
                const SizedBox(height: 12),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.update,
                        color: Colors.grey),
                    title: Text(
                      'آخر تحديث: ${order.updatedAt.toString().substring(0, 10)}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 12),

              // ملاحظات
              if (order.notes != null && order.notes!.isNotEmpty)
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
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

              // زر الدفع
              if (_canPay(order.status) && !_isPaid(order))
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: isPaying ? null : _payForOrder,
                    icon: isPaying
                        ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                        : const Icon(Icons.account_balance_wallet),
                    label: const Text(
                      'الدفع من المحفظة',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),

              const SizedBox(height: 8),

              // زر الرجوع
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
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
