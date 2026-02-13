import 'package:flutter/material.dart';
import 'package:sawa_lite/data/models/wallet_model.dart';

class RechargeScreen extends StatefulWidget {
  const RechargeScreen({super.key});

  @override
  State<RechargeScreen> createState() => _RechargeScreenState();
}

class _RechargeScreenState extends State<RechargeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _recharge() {
    if (_formKey.currentState!.validate()) {
      final amount = double.parse(_amountController.text);

      // تحديث الرصيد (Mock)
      mockWallet.balance += amount;

      // إضافة عملية جديدة
      mockWallet.transactions.insert(
        0,
        WalletTransaction(
          id: mockWallet.transactions.length + 1,
          amount: amount,
          type: 'شحن',
          date: DateTime.now(),
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم شحن الرصيد بنجاح')),
      );

      Navigator.pop(context); // العودة للمحفظة
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('شحن الرصيد'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'المبلغ',
                    hintText: 'أدخل مبلغ الشحن',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء إدخال مبلغ الشحن';
                    }
                    final amount = double.tryParse(value);
                    if (amount == null || amount <= 0) {
                      return 'الرجاء إدخال مبلغ صحيح';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 24),

                ElevatedButton(
                  onPressed: _recharge,
                  child: const Text('تأكيد الشحن'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
