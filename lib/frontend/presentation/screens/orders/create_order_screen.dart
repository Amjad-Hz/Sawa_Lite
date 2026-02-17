import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:sawa_lite/frontend/data/api/api_service.dart';
import 'package:sawa_lite/frontend/data/models/service_model.dart';

class CreateOrderScreen extends StatefulWidget {
  final ServiceModel service;

  const CreateOrderScreen({super.key, required this.service});

  @override
  State<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  final _formKey = GlobalKey<FormState>();
  final _notesController = TextEditingController();

  bool isLoading = false;
  double opacity = 0;
  double offsetY = 20;

  @override
  void initState() {
    super.initState();

    // Start simple fade and slide animation
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        setState(() {
          opacity = 1;
          offsetY = 0;
        });
      }
    });
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  // Submit order to backend
  Future<void> _submitOrder() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      final order = await ApiService.instance.createOrder(
        serviceId: widget.service.id,
        notes: _notesController.text.trim(),
      );

      setState(() => isLoading = false);

      // Show success dialog
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            "تم إرسال الطلب بنجاح",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text(
            "رقم الطلب: ${order['id']}",
            style: const TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Return to previous screen
              },
              child: const Text("حسناً"),
            ),
          ],
        ),
      );
    } catch (e) {
      setState(() => isLoading = false);

      String message = "فشل إرسال الطلب";

      if (e is DioException && e.response != null) {
        message = e.response!.data['detail'] ?? message;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final service = widget.service;
    final primaryColor = Theme.of(context).primaryColor;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text('طلب خدمة: ${service.nameAr}'),
          centerTitle: true,
        ),

        body: AnimatedOpacity(
          duration: const Duration(milliseconds: 400),
          opacity: opacity,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            transform: Matrix4.translationValues(0, offsetY, 0),
            padding: const EdgeInsets.all(16.0),

            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Service title
                  Text(
                    service.nameAr,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Notes input card
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextFormField(
                        controller: _notesController,
                        maxLines: 4,
                        decoration: const InputDecoration(
                          labelText: 'ملاحظات (اختياري)',
                          border: InputBorder.none,
                          alignLabelWithHint: true,
                        ),
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Submit order button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _submitOrder,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                          : const Text(
                        'إرسال الطلب',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
