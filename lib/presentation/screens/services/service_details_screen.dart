import 'package:flutter/material.dart';
import 'package:sawa_lite/data/models/service_model.dart';

import '../orders/create_order_screen.dart';

class ServiceDetailsScreen extends StatelessWidget {
  final ServiceModel service;

  const ServiceDetailsScreen({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(service.nameAr),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                service.nameAr,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                service.description ?? 'لا يوجد وصف متاح',
                style: const TextStyle(fontSize: 16),
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  const Icon(Icons.timer, color: Colors.blue),
                  const SizedBox(width: 8),
                  Text(
                    'المدة المتوقعة: ${service.durationDays ?? 0} يوم',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  const Icon(Icons.monetization_on, color: Colors.green),
                  const SizedBox(width: 8),
                  Text(
                    service.cost == 0
                        ? 'التكلفة: مجانية'
                        : 'التكلفة: ${service.cost.toInt()} ل.س',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),

              const Spacer(),

              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CreateOrderScreen(service: service),
                    ),
                  );
                },
                child: const Text('طلب الخدمة'),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
