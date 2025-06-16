import 'dart:io';
import 'package:csv/csv.dart';
import 'package:elomark/color.dart';
import 'package:elomark/models/course.dart';
import 'package:elomark/models/mark.dart';
import 'package:elomark/screens/admin/add_student_admin.dart';
import 'package:elomark/screens/admin/adminMainPage.dart/row_home_admin.dart';
import 'package:elomark/screens/admin/cubits/cubit_mark_admin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class MarkPage extends StatefulWidget {
  final Course course;

  const MarkPage({super.key, required this.course});

  @override
  State<MarkPage> createState() => _MarkPageState();
}

class _MarkPageState extends State<MarkPage> {
  late MarkCubit markCubit;

  @override
  void initState() {
    super.initState();
    markCubit = MarkCubit();
    markCubit.loadMarksByCourse(widget.course.courseId);
  }

  @override
  void dispose() {
    markCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: markCubit,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 2,
          title: Text(
            '${widget.course.courseCode} - ${widget.course.courseName}',
            style: const TextStyle(fontSize: 18),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddStudent(course: widget.course),
                  ),
                );

                if (result == 'refresh') {
                  markCubit.loadMarksByCourse(widget.course.courseId);
                }
              },
            ),
          ],
        ),
        backgroundColor: primary,
        body: Container(
          margin: const EdgeInsets.only(top: 20),
          padding: const EdgeInsets.only(top: 8.0),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
             children: [
                Align(
  alignment: Alignment.centerLeft,
  child: TextButton.icon(
    onPressed: () async {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Delete Course"),
          content: const Text("Are you sure you want to delete this course and all related marks?"),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text("Delete"),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        ),
      );

      if (confirm == true) {
        // TODO: Add your delete logic here (e.g., call API or delete locally)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Course deleted successfully')),
        );

        Navigator.pop(context); // Go back after deletion
      }
    },
    icon: const Icon(Icons.delete, color: Colors.red),
    label: const Text(
      'Delete Course',
      style: TextStyle(color: Colors.red),
    ),
  ),
),



            //   // Export CSV Button
            //   Align(
            //     alignment: Alignment.centerLeft,
            //     child: TextButton.icon(
            //       onPressed: () async {
            //         final marks = markCubit.state;

            //         if (marks.isEmpty) {
            //           ScaffoldMessenger.of(context).showSnackBar(
            //             const SnackBar(content: Text('No marks to export')),
            //           );
            //           return;
            //         }

            //         List<List<String>> csvData = [
            //           ['Student Name', 'Course Name', 'Mark'],
            //           ...marks.map(
            //             (mark) => [
            //               mark.student.studentName,
            //               mark.course.courseName,
            //               mark.mark.toString(),
            //             ],
            //           ),
            //         ];

            //         await exportCSV(context, csvData);
            //       },
            //       icon: const Icon(Icons.share),
            //       label: const Text('Export All as CSV'),
            //     ),
            //   ),

              // List of marks
              Expanded(
                child: BlocBuilder<MarkCubit, List<Mark>>(
                  builder: (context, marks) {
                    if (marks.isEmpty) {
                      return const Center(child: Text("No students available"));
                    }

                    return ListView.builder(
                      itemCount: marks.length,
                      itemBuilder: (context, index) {
                        final mark = marks[index];
                        return MarkList(
                          markData: mark,
                          onRefresh: () {
                            markCubit.loadMarksByCourse(widget.course.courseId);
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> exportCSV(
    BuildContext context,
    List<List<String>> csvData,
  ) async {
    try {
      final csv = const ListToCsvConverter().convert(csvData);
      final directory = await getApplicationDocumentsDirectory();
      final path = "${directory.path}/course_marks.csv";
      final file = File(path);

      await file.writeAsString(csv);
      await Share.shareXFiles([XFile(path)], text: 'Course Mark CSV Export');
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error exporting CSV: $e')));
    }
  }
}
