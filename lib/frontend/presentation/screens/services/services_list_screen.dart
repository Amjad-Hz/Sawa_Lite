import 'package:flutter/material.dart';
import 'package:sawa_lite/frontend/data/models/service_model.dart';
import 'service_details_screen.dart';

class ServicesListScreen extends StatelessWidget {
  const ServicesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('الخدمات الحكومية'),
          centerTitle: true,
        ),

        body: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: mockServices.length,
          itemBuilder: (context, index) {
            final service = mockServices[index];

            return _AnimatedServiceItem(
              delay: index * 120, // ⏳ تأخير تدريجي لكل عنصر
              child: Card(
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),

                  leading: Icon(
                    Icons.miscellaneous_services,
                    size: 32,
                    color: primaryColor,
                  ),

                  title: Text(
                    service.nameAr,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  subtitle: Text(
                    service.description ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  trailing: Text(
                    service.cost == 0 ? 'مجانية' : '${service.cost.toInt()} ل.س',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
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
              ),
            );
          },
        ),
      ),
    );
  }
}

// --------------------------------------------------
// 🔥 عنصر متحرك (Fade + Slide + Staggered)
// --------------------------------------------------
class _AnimatedServiceItem extends StatefulWidget {
  final Widget child;
  final int delay;

  const _AnimatedServiceItem({
    required this.child,
    required this.delay,
  });

  @override
  State<_AnimatedServiceItem> createState() => _AnimatedServiceItemState();
}

class _AnimatedServiceItemState extends State<_AnimatedServiceItem> {
  double opacity = 0;
  double offsetY = 20;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) {
        setState(() {
          opacity = 1;
          offsetY = 0;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 400),
      opacity: opacity,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOut,
        transform: Matrix4.translationValues(0, offsetY, 0),
        child: widget.child,
      ),
    );
  }
}
