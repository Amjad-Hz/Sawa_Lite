import 'package:flutter/material.dart';
import 'package:sawa_lite/data/models/service_model.dart';

import '../../../data/models/order_model.dart';
import 'order_status_screen.dart';

class CreateOrderScreen extends StatefulWidget {
  final ServiceModel service;

  const CreateOrderScreen({super.key, required this.service});

  @override
  State<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  final _formKey = GlobalKey<FormState>();
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _submitOrder() {
    if (_formKey.currentState!.validate()) {
      // إنشاء طلب وهمي (mock) مؤقتاً
      final newOrder = OrderModel(
        id: 999, // رقم مؤقت
        userId: 1,
        serviceId: widget.service.id,
        status: 'قيد المراجعة',
        notes: _notesController.text,
        createdAt: DateTime.now(),
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => OrderStatusScreen(
            order: newOrder,
            service: widget.service,
          ),
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text('طلب خدمة: ${widget.service.nameAr}'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.service.nameAr,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 16),

                TextFormField(
                  controller: _notesController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: 'ملاحظات (اختياري)',
                    alignLabelWithHint: true,
                  ),
                ),

                const Spacer(),

                ElevatedButton(
                  onPressed: _submitOrder,
                  child: const Text('إرسال الطلب'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
