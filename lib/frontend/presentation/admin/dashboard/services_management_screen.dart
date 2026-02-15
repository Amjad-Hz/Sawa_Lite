import 'package:flutter/material.dart';

class ServicesManagementScreen extends StatefulWidget {
  const ServicesManagementScreen({super.key});

  @override
  State<ServicesManagementScreen> createState() => _ServicesManagementScreenState();
}

class _ServicesManagementScreenState extends State<ServicesManagementScreen> {
  final TextEditingController _searchController = TextEditingController();

  // بيانات تجريبية — لاحقًا تربطها بالباكند
  List<Map<String, dynamic>> allServices = [
    {"id": 1, "name": "استخراج بيان عائلي", "price": 15000},
    {"id": 2, "name": "تجديد رخصة قيادة", "price": 30000},
    {"id": 3, "name": "معاملة سجل عقاري", "price": 20000},
  ];

  List<Map<String, dynamic>> filteredServices = [];

  @override
  void initState() {
    super.initState();
    filteredServices = List.from(allServices);
  }

  void _filterServices(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredServices = List.from(allServices);
      } else {
        filteredServices = allServices.where((service) {
          return service["name"].toString().contains(query);
        }).toList();
      }
    });
  }

  void _deleteService(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("حذف خدمة"),
        content: const Text("هل أنت متأكد من حذف هذه الخدمة؟"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("إلغاء"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              "حذف",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() {
        allServices.removeWhere((s) => s["id"] == id);
        filteredServices.removeWhere((s) => s["id"] == id);
      });

      // لاحقًا: استدعاء API لحذف الخدمة من الباكند
    }
  }

  void _addService() {
    showDialog(
      context: context,
      builder: (_) => _ServiceDialog(
        onSave: (name, price) {
          setState(() {
            allServices.add({
              "id": DateTime.now().millisecondsSinceEpoch,
              "name": name,
              "price": price,
            });
            filteredServices = List.from(allServices);
          });
        },
      ),
    );
  }

  void _editService(Map<String, dynamic> service) {
    showDialog(
      context: context,
      builder: (_) => _ServiceDialog(
        initialName: service["name"],
        initialPrice: service["price"],
        onSave: (name, price) {
          setState(() {
            service["name"] = name;
            service["price"] = price;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("إدارة الخدمات"),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: _addService,
            ),
          ],
        ),

        body: Column(
          children: [
            // حقل البحث
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: "بحث عن خدمة...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onChanged: _filterServices,
              ),
            ),

            Expanded(
              child: ListView.separated(
                itemCount: filteredServices.length,
                separatorBuilder: (_, __) => const Divider(height: 0),
                itemBuilder: (context, index) {
                  final service = filteredServices[index];

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: primaryColor.withOpacity(0.15),
                      child: Icon(Icons.miscellaneous_services, color: primaryColor),
                    ),
                    title: Text(service["name"]),
                    subtitle: Text("السعر: ${service["price"]} ل.س"),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == "edit") {
                          _editService(service);
                        } else if (value == "delete") {
                          _deleteService(service["id"]);
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: "edit",
                          child: Text("تعديل"),
                        ),
                        const PopupMenuItem(
                          value: "delete",
                          child: Text(
                            "حذف",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --------------------------------------------------
// نافذة إضافة/تعديل خدمة
// --------------------------------------------------
class _ServiceDialog extends StatefulWidget {
  final String? initialName;
  final int? initialPrice;
  final Function(String name, int price) onSave;

  const _ServiceDialog({
    this.initialName,
    this.initialPrice,
    required this.onSave,
  });

  @override
  State<_ServiceDialog> createState() => _ServiceDialogState();
}

class _ServiceDialogState extends State<_ServiceDialog> {
  late TextEditingController _nameController;
  late TextEditingController _priceController;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: widget.initialName ?? "");
    _priceController = TextEditingController(
      text: widget.initialPrice?.toString() ?? "",
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.initialName == null ? "إضافة خدمة" : "تعديل خدمة"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: "اسم الخدمة"),
          ),
          TextField(
            controller: _priceController,
            decoration: const InputDecoration(labelText: "السعر"),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
      actions: [
        TextButton(
          child: const Text("إلغاء"),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
          child: const Text("حفظ"),
          onPressed: () {
            final name = _nameController.text.trim();
            final price = int.tryParse(_priceController.text.trim()) ?? 0;

            if (name.isNotEmpty && price > 0) {
              widget.onSave(name, price);
              Navigator.pop(context);
            }
          },
        ),
      ],
    );
  }
}
