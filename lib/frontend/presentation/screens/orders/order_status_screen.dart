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

  // Load order details from backend
  Future<void> _loadOrder() async {
    try {
      final response = await ApiService.instance.getOrderById(widget.order.id);

      setState(() {
        updatedOrder = OrderModel.fromJson(response);
        isLoading = false;
        isRefreshing = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = "Failed to load order status: $e";
        isLoading = false;
        isRefreshing = false;
      });
    }
  }

  // Check if order is paid
  bool _isPaid(OrderModel order) {
    return order.isPaid == true;
  }

  // Handle payment
  Future<void> _payForOrder() async {
    setState(() {
      isPaying = true;
      errorMessage = null;
    });

    try {
      await ApiService.instance.payForOrder(widget.order.id);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Payment completed successfully')),
        );
      }

      await _loadOrder();
    } catch (e) {
      if (mounted) {
        String message = "Payment failed";

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

  // Color for order status
  Color _statusColor(String status) {
    switch (status) {
      case 'مكتمل':
        return Colors.green;
      case 'مرفوض':
        return Colors.red;
      case 'مقبول':
        return Colors.blue;
      default:
        return Colors.orange;
    }
  }

  // Color for payment status
  Color _paymentColor(bool isPaid) {
    return isPaid ? Colors.green : Colors.red;
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
              // Service name
              Text(
                (updatedOrder?.service ?? widget.service).nameAr,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              // Order status
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

              // Payment status
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  leading: Icon(
                    Icons.payments,
                    color: _paymentColor(order.isPaid),
                  ),
                  title: const Text(
                    'حالة الدفع:',
                    style: TextStyle(fontSize: 16),
                  ),
                  subtitle: Text(
                    order.isPaid ? "مدفوع" : "غير مدفوع",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _paymentColor(order.isPaid),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Creation date
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

              // Last update
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

              // Notes
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

              // Payment button (only if not paid)
              if (!_isPaid(order))
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

              // Back button
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
