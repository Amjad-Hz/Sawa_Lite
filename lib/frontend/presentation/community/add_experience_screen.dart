import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../data/user_prefs.dart';

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
      final dio = Dio();
      final response = await dio.get("http://YOUR_API_URL/services");

      setState(() {
        services = response.data;
        loadingServices = false;
      });
    } catch (e) {
      setState(() => loadingServices = false);
      print("Error loading services: $e");
    }
  }

  Future<void> submitExperience() async {
    if (selectedServiceId == null || rating == 0 || _contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("يرجى ملء جميع الحقول")),
      );
      return;
    }

    setState(() => sending = true);

    try {
      final dio = Dio();

      // 🔥 الحصول على التوكن من UserPrefs
      final token = await UserPrefs.getToken();

      final response = await dio.post(
        "http://YOUR_API_URL/community/experiences",
        data: {
          "service_id": selectedServiceId,
          "content": _contentController.text.trim(),
          "rating": rating,
        },
        options: Options(
          headers: {
            if (token != null && token.isNotEmpty) "Authorization": "Bearer $token",
          },
        ),
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
                  return DropdownMenuItem(
                    value: service["id"],
                    child: Text(service["name"]),
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
