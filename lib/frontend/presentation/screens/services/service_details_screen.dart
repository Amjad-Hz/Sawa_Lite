import 'package:flutter/material.dart';
import 'package:sawa_lite/frontend/data/models/service_model.dart';
import '../orders/create_order_screen.dart';

class ServiceDetailsScreen extends StatefulWidget {
  final ServiceModel service;

  const ServiceDetailsScreen({super.key, required this.service});

  @override
  State<ServiceDetailsScreen> createState() => _ServiceDetailsScreenState();
}

class _ServiceDetailsScreenState extends State<ServiceDetailsScreen> {
  double opacityTitle = 0;
  double opacityDesc = 0;
  double opacityDuration = 0;
  double opacityCost = 0;
  double opacityButton = 0;

  double offsetTitle = 20;
  double offsetDesc = 20;
  double offsetDuration = 20;
  double offsetCost = 20;
  double offsetButton = 20;

  @override
  void initState() {
    super.initState();

    // 🔥 Staggered Animation
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        setState(() {
          opacityTitle = 1;
          offsetTitle = 0;
        });
      }
    });

    Future.delayed(const Duration(milliseconds: 250), () {
      if (mounted) {
        setState(() {
          opacityDesc = 1;
          offsetDesc = 0;
        });
      }
    });

    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) {
        setState(() {
          opacityDuration = 1;
          offsetDuration = 0;
        });
      }
    });

    Future.delayed(const Duration(milliseconds: 550), () {
      if (mounted) {
        setState(() {
          opacityCost = 1;
          offsetCost = 0;
        });
      }
    });

    Future.delayed(const Duration(milliseconds: 700), () {
      if (mounted) {
        setState(() {
          opacityButton = 1;
          offsetButton = 0;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final service = widget.service;
    final primaryColor = Theme.of(context).primaryColor;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(service.nameAr),
          centerTitle: true,
        ),

        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ---------------------------
              // 🔥 عنوان الخدمة
              // ---------------------------
              AnimatedOpacity(
                duration: const Duration(milliseconds: 400),
                opacity: opacityTitle,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  transform: Matrix4.translationValues(0, offsetTitle, 0),
                  child: Text(
                    service.nameAr,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ---------------------------
              // 🔥 بطاقة الوصف
              // ---------------------------
              AnimatedOpacity(
                duration: const Duration(milliseconds: 400),
                opacity: opacityDesc,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  transform: Matrix4.translationValues(0, offsetDesc, 0),
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        service.description ?? 'لا يوجد وصف متاح',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ---------------------------
              // 🔥 بطاقة المدة
              // ---------------------------
              AnimatedOpacity(
                duration: const Duration(milliseconds: 400),
                opacity: opacityDuration,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  transform: Matrix4.translationValues(0, offsetDuration, 0),
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListTile(
                      leading: Icon(Icons.timer, color: primaryColor),
                      title: Text(
                        'المدة المتوقعة: ${service.durationDays ?? 0} يوم',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // ---------------------------
              // 🔥 بطاقة التكلفة
              // ---------------------------
              AnimatedOpacity(
                duration: const Duration(milliseconds: 400),
                opacity: opacityCost,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  transform: Matrix4.translationValues(0, offsetCost, 0),
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListTile(
                      leading: Icon(Icons.monetization_on, color: primaryColor),
                      title: Text(
                        service.cost == 0
                            ? 'التكلفة: مجانية'
                            : 'التكلفة: ${service.cost.toInt()} ل.س',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ),

              const Spacer(),

              // ---------------------------
              // 🔥 زر طلب الخدمة
              // ---------------------------
              AnimatedOpacity(
                duration: const Duration(milliseconds: 400),
                opacity: opacityButton,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  transform: Matrix4.translationValues(0, offsetButton, 0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CreateOrderScreen(service: service),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'طلب الخدمة',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
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
