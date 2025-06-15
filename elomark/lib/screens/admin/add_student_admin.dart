import 'dart:convert';
import 'package:elomark/constant.dart';
import 'package:elomark/models/course.dart';
import 'package:elomark/label_text.dart';
import 'package:elomark/screens/admin/search_student.dart';
import 'package:elomark/screens/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddStudent extends StatefulWidget {
  final Course course;

  const AddStudent({super.key, required this.course});

  @override
  State<AddStudent> createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  String? selectedStudentName;
  int? selectedStudentId;
  final TextEditingController markController = TextEditingController();

  Future<void> submitMark() async {
    final mark = int.tryParse(markController.text);

    if (selectedStudentId == null || mark == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a student and enter a valid mark'),
        ),
      );
      return;
    }

    final response = await http.post(
      Uri.parse(examMarkURL),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'student_id': selectedStudentId,
        'course_id': widget.course.courseId,
        'mark': mark,
      }),
    );

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Mark added successfully')));
      Navigator.pop(context, 'refresh');
    } else {
      print('Failed to add mark: ${response.body}');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to add mark')));
    }
  }

  Future<void> fetchStudentId(String name) async {
    final response = await http.get(Uri.parse(studentURL));
    if (response.statusCode == 200) {
      final List<dynamic> students = jsonDecode(response.body);
      final matchedStudent = students.firstWhere(
        (s) => s['student_name'] == name,
        orElse: () => null,
      );

      if (matchedStudent != null) {
        setState(() {
          selectedStudentName = name;
          selectedStudentId = matchedStudent['student_id'];
        });
      }
    }
  }

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
                const CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage("assets/images/ava.jpg"),
                ),
                const SizedBox(height: 30),

                LabelText(text: "Student Name:"),
                StudentSearchField(
                  onSelected: (String name) async {
                    await fetchStudentId(name);
                  },
                ),

                const SizedBox(height: 16),
                LabelText(text: "Course Code:"),
                FillInBlank(
                  text: widget.course.courseCode,
                  icon: Icons.book,
                  hint: "Course Code",
                  isEnabled: false,
                ),

                const SizedBox(height: 16),
                LabelText(text: "Course Name:"),
                FillInBlank(
                  text: widget.course.courseName,
                  icon: Icons.book,
                  hint: "Course Name",
                  isEnabled: false,
                ),

                const SizedBox(height: 16),
                LabelText(text: "Mark:"),
                TextField(
                  controller: markController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.grade),
                    hintText: "Enter mark",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: submitMark,
        label: const Text('Add Student'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
