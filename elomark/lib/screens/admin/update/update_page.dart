import 'dart:io';
import 'dart:convert';
import 'package:csv/csv.dart';
import 'package:elomark/constant.dart';
import 'package:elomark/label_text.dart';
import 'package:elomark/models/mark.dart';
import 'package:elomark/screens/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class UpdatePage extends StatefulWidget {
  final Mark markData;

  const UpdatePage({super.key, required this.markData});

  @override
  State<UpdatePage> createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  late TextEditingController markController;

  @override
  void initState() {
    super.initState();
    markController = TextEditingController(
      text: widget.markData.mark.toString(),
    );
  }

  @override
  void dispose() {
    markController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final studentName = widget.markData.student.studentName;
    final studentId = widget.markData.student.studentId;
    final courseName = widget.markData.course.courseName;
    final courseId = widget.markData.course.courseId;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Mark'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder:
                    (ctx) => AlertDialog(
                      title: const Text('Confirm Delete'),
                      content: const Text(
                        'Are you sure you want to delete this mark?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(ctx).pop(false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(ctx).pop(true),
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
              );

              if (confirm == true) {
                final response = await http.delete(
                  Uri.parse('$examMarkURL/student/$studentId/course/$courseId'),
                );

                if (response.statusCode == 200) {
                  final body = jsonDecode(response.body);
                  if (body['success']) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Mark deleted successfully'),
                        ),
                      );
                      Navigator.pop(context, 'refresh');
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Delete failed: ${body['message']}'),
                      ),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Server error: ${response.statusCode}'),
                    ),
                  );
                }
              }
            },
          ),
        ],
      ),
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
                FillInBlank(
                  text: studentName,
                  icon: Icons.person,
                  hint: "Student Name",
                  isEnabled: false,
                ),
                const SizedBox(height: 16),
                LabelText(text: "Course Name:"),
                FillInBlank(
                  text: courseName,
                  icon: Icons.book,
                  hint: "Course Name",
                  isEnabled: false,
                ),
                const SizedBox(height: 16),
                LabelText(text: "Mark:"),
                TextField(
                  controller: markController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.grade),
                    hintText: "Mark",
                    border: OutlineInputBorder(),
                  ),
                ),
                
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final markText = markController.text.trim();
          if (markText.isEmpty || int.tryParse(markText) == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Please enter a valid integer mark.'),
              ),
            );
            return;
          }

          final int newMark = int.parse(markText);

          final success = await updateMark(
            studentId: studentId,
            courseId: courseId,
            mark: newMark,
          );

          if (success) {
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Mark updated successfully')),
            );
            Navigator.pop(context, 'refresh');
          } else {
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to update mark')),
            );
          }
        },
        label: const Text('Update'),
        icon: const Icon(Icons.update),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Future<void> exportCSV(
    BuildContext context,
    String studentName,
    String courseName,
    String mark,
  ) async {
    try {
      List<List<String>> csvData = [
        ['Student Name', 'Course Name', 'Mark'],
        [studentName, courseName, mark],
      ];

      String csv = const ListToCsvConverter().convert(csvData);
      final directory = await getApplicationDocumentsDirectory();
      final path = "${directory.path}/student_mark.csv";
      final file = File(path);

      await file.writeAsString(csv);
      await Share.shareXFiles([XFile(path)], text: 'Student Mark CSV Export');
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error exporting CSV: $e')));
    }
  }

  // Make sure this function is available or imported from your service file
  Future<bool> updateMark({
    required int studentId,
    required int courseId,
    required int mark,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('$examMarkURL/student/$studentId/course/$courseId'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'mark': mark}),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error in updateMark: $e');
      return false;
    }
  }
}
