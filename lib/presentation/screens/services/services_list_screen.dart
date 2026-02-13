import 'package:flutter/material.dart';
import 'package:sawa_lite/data/models/service_model.dart';

import 'service_details_screen.dart';

class ServicesListScreen extends StatelessWidget {
  const ServicesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('الخدمات الحكومية'),
        ),
        body: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: mockServices.length,
          itemBuilder: (context, index) {
            final service = mockServices[index];

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                title: Text(service.nameAr),
                subtitle: Text(service.description ?? ''),
                trailing: Text(
                  service.cost == 0 ? 'مجانية' : '${service.cost.toInt()} ل.س',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ServiceDetailsScreen(service: service),
                    ),
                  );
                },

              ),
            );
          },
        ),
      ),
    );
  }
}
