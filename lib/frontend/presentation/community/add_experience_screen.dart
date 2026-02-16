import 'package:flutter/material.dart';
import '../../data/api/api_service.dart';

class AddExperienceScreen extends StatefulWidget {
  final int? serviceId;

  const AddExperienceScreen({super.key, this.serviceId});

  @override
  State<AddExperienceScreen> createState() => _AddExperienceScreenState();
}

class _AddExperienceScreenState extends State<AddExperienceScreen> {
  final TextEditingController _contentController = TextEditingController();
  int rating = 0;
  int? selectedServiceId;

  List<dynamic> services = [];
  bool loadingServices = true;
  bool sending = false;

  @override
  void initState() {
    super.initState();
    selectedServiceId = widget.serviceId;
    fetchServices();
  }

  Future<void> fetchServices() async {
    try {
      final data = await ApiService.instance.getServices();

      setState(() {
        services = data;
        loadingServices = false;
      });
    } catch (e) {
      setState(() => loadingServices = false);
      print("Error loading services: $e");
    }
  }

  Future<void> submitExperience() async {
    if (selectedServiceId == null ||
        rating == 0 ||
        _contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("يرجى ملء جميع الحقول")),
      );
      return;
    }

    setState(() => sending = true);

    try {
      await ApiService.instance.addExperience(
        serviceId: selectedServiceId!,
        rating: rating,
        content: _contentController.text.trim(),
      );

      setState(() => sending = false);

      Navigator.pop(context, true);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("تم إضافة التجربة بنجاح")),
      );
    } catch (e) {
      setState(() => sending = false);
      print("Error submitting experience: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("حدث خطأ أثناء الإرسال")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("إضافة تجربة"),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              const Text(
                "اختر الخدمة",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              loadingServices
                  ? const Center(child: CircularProgressIndicator())
                  : DropdownButtonFormField<int>(
                value: selectedServiceId,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: services.map<DropdownMenuItem<int>>((service) {
                  final id = service["id"];
                  final name = service["name"] ??
                      service["name_ar"] ??
                      "خدمة غير معروفة";

                  return DropdownMenuItem(
                    value: id,
                    child: Text(name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => selectedServiceId = value);
                },
              ),

              const SizedBox(height: 20),

              const Text(
                "التقييم",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              Row(
                children: List.generate(
                  5,
                      (i) => IconButton(
                    icon: Icon(
                      i < rating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 32,
                    ),
                    onPressed: () {
                      setState(() => rating = i + 1);
                    },
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                "اكتب تجربتك",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              TextField(
                controller: _contentController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: "اكتب تجربتك هنا...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: sending ? null : submitExperience,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: primaryColor,
                ),
                child: sending
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                  "إرسال التجربة",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
