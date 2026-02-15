import 'package:flutter/material.dart';
import 'package:sawa_lite/frontend/data/models/wallet_model.dart';

class TransactionDetailsScreen extends StatelessWidget {
  final WalletTransaction transaction;

  const TransactionDetailsScreen({super.key, required this.transaction});

  Color _typeColor(String type) {
    switch (type) {
      case 'شحن':
        return Colors.green;
      case 'استرداد':
        return Colors.blue;
      case 'دفع':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _typeIcon(String type) {
    switch (type) {
      case 'شحن':
        return Icons.add_circle;
      case 'استرداد':
        return Icons.refresh;
      case 'دفع':
        return Icons.remove_circle;
      default:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("تفاصيل العملية"),
          centerTitle: true,
        ),

        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // ---------------------------
              // 🔥 بطاقة نوع العملية
              // ---------------------------
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  leading: Icon(
                    _typeIcon(transaction.type),
                    color: _typeColor(transaction.type),
                    size: 40,
                  ),
                  title: Text(
                    transaction.type,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: _typeColor(transaction.type),
                    ),
                  ),
                  subtitle: Text(
                    transaction.date.toString().substring(0, 16),
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ---------------------------
              // 🔥 بطاقة المبلغ
              // ---------------------------
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  leading: Icon(Icons.monetization_on, color: primaryColor),
                  title: Text(
                    "المبلغ: ${transaction.amount.toInt()} ل.س",
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // ---------------------------
              // 🔥 بطاقة رقم الطلب (إن وجد)
              // ---------------------------
              if (transaction.orderId != null)
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    leading: Icon(Icons.receipt_long, color: primaryColor),
                    title: Text(
                      "رقم الطلب المرتبط: ${transaction.orderId}",
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ),

              const SizedBox(height: 12),

              // ---------------------------
              // 🔥 بطاقة الوصف
              // ---------------------------
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    transaction.description ?? "لا يوجد وصف لهذه العملية",
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),

              const Spacer(),

              // زر الرجوع
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "رجوع",
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
