import 'package:elomark/label_text.dart';
import 'package:elomark/screens/admin/search_student.dart';
import 'package:elomark/screens/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class AddStudent extends StatelessWidget {
  final String category;

  const AddStudent({super.key, required this.category});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,

      appBar: AppBar(title: const Text('Add Student')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                // Student Image
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage(
                      "assets/images/ava.jpg",
                    ), // Your image path
                  ),
                ),
                SizedBox(height: 30),

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
                  onSelected: (String selectedName) {
                    // Handle the selected student name here
                    print("Selected student: $selectedName");
                  },
                ),
                SizedBox(height: 16),
                LabelText(text: "Course Code:"),
                FillInBlank(
                  text: category,
                  icon: Icons.book,
                  hint: "Course Code",
                  isEnabled: false,
                ),
                SizedBox(height: 16),
                LabelText(text: "Course Name:"),
                FillInBlank(
                  text: category,
                  icon: Icons.book,
                  hint: "Course Name",
                  isEnabled: false,
                ),
                SizedBox(height: 16),
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
          // Add update logic here
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Create button pressed')),
          );
        },
        label: const Text('Create'),
        icon: const Icon(Icons.create),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
