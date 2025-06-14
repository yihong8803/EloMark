import 'package:elomark/label_text.dart';
import 'package:elomark/screens/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class UpdatePage extends StatelessWidget {
  final String stdName;
  final String category;
  final String mark;

  const UpdatePage({
    super.key,
    required this.stdName,
    required this.category,
    required this.mark,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,

      appBar: AppBar(
        title: const Text('Update Mark'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              // Add delete logic here
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Delete button pressed')),
              );
            },
          ),
        ],
      ),
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

                FillInBlank(
                  text: stdName,
                  icon: Icons.person,
                  hint: "Student Name",
                  isEnabled: false,
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
                  text: mark,
                  icon: Icons.grade,
                  hint: "Mark",
                  isEnabled: true,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: () {
                      // Export logic here
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('CSV exported')),
                      );
                    },
                    icon: Icon(Icons.share),
                    label: Text('Export as CSV'),
                  ),
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
            const SnackBar(content: Text('Update button pressed')),
          );
        },
        label: const Text('Update'),
        icon: const Icon(Icons.update),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}


