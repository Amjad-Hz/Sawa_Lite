import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'add_experience_screen.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  List<dynamic> experiences = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchExperiences();
  }

  Future<void> fetchExperiences() async {
    try {
      final dio = Dio();
      final response = await dio.get(
        "http://YOUR_API_URL/community/experiences",
      );

      setState(() {
        experiences = response.data;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      print("Error fetching experiences: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("المجتمع"),
          centerTitle: true,
        ),

        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : experiences.isEmpty
            ? const Center(
          child: Text(
            "لا توجد تجارب بعد",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        )
            : ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: experiences.length,
          itemBuilder: (context, index) {
            final exp = experiences[index];

            return _experienceCard(
              user: exp["user"]["full_name"],
              service: exp["service"]["name"],
              content: exp["content"],
              rating: exp["rating"],
              date: exp["created_at"],
              color: primaryColor,
            );
          },
        ),

        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final added = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const AddExperienceScreen(),
              ),
            );

            if (added == true) {
              fetchExperiences();
            }
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _experienceCard({
    required String user,
    required String service,
    required String content,
    required int rating,
    required String date,
    required Color color,
  }) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // اسم المستخدم + الخدمة
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: color.withOpacity(0.15),
                  child: Icon(Icons.person, color: color),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    user,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),

            const SizedBox(height: 8),

            Text(
              "الخدمة: $service",
              style: const TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 8),

            // التقييم
            Row(
              children: List.generate(
                5,
                    (i) => Icon(
                  i < rating ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                  size: 20,
                ),
              ),
            ),

            const SizedBox(height: 10),

            // المحتوى
            Text(
              content,
              style: const TextStyle(fontSize: 15),
            ),

            const SizedBox(height: 10),

            // التاريخ
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                date.split("T")[0],
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
