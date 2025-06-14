import 'package:elomark/models/course.dart';
import 'package:elomark/label_text.dart';
import 'package:elomark/screens/admin/search_student.dart';
import 'package:elomark/screens/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class AddStudent extends StatelessWidget {
  final Course course;

  const AddStudent({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Student')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage("assets/images/ava.jpg"),
                ),
                const SizedBox(height: 30),

                LabelText(text: "Student Name:"),
                StudentSearchField(
                  studentNames: [
                    "Yihong",
                    "Recycle Monster",
                    "Mega Knight",
                    "Terralith",
                    "Cycloop never die",
                    "debate",
                    "lalat king",
                    "zei bi",
                    "beimuyu",
                    "Wen Hui",
                  ],
                  onSelected: (selectedName) {
                    print("Selected student: $selectedName");
                  },
                ),

                const SizedBox(height: 16),
                LabelText(text: "Course Code:"),
                FillInBlank(
                  text: course.courseCode,
                  icon: Icons.book,
                  hint: "Course Code",
                  isEnabled: false,
                ),

                const SizedBox(height: 16),
                LabelText(text: "Course Name:"),
                FillInBlank(
                  text: course.courseName,
                  icon: Icons.book,
                  hint: "Course Name",
                  isEnabled: false,
                ),

                const SizedBox(height: 16),
                LabelText(text: "Mark:"),
                FillInBlank(
                  text: "Your Mark",
                  icon: Icons.grade,
                  hint: "Mark",
                  isEnabled: true,
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Create button pressed')),
          );
        },
        label: const Text('Create'),
        icon: const Icon(Icons.create),
      ),
    );
  }
}
