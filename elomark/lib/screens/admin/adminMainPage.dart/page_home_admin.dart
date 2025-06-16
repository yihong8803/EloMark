import 'dart:io';
import 'package:csv/csv.dart';
import 'package:elomark/color.dart';
import 'package:elomark/models/course.dart';
import 'package:elomark/models/mark.dart';
import 'package:elomark/screens/admin/add_student_admin.dart';
import 'package:elomark/screens/admin/adminMainPage.dart/row_home_admin.dart';
import 'package:elomark/screens/admin/cubits/cubit_mark_admin.dart';
import 'package:elomark/services/course_service.dart';
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
                      builder:
                          (context) => AlertDialog(
                            title: const Text("Delete Course"),
                            content: const Text(
                              "Are you sure you want to delete this course and all related marks?",
                            ),
                            actions: [
                              TextButton(
                                child: const Text("Cancel"),
                                onPressed:
                                    () => Navigator.of(context).pop(false),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                                child: const Text("Delete"),
                                onPressed:
                                    () => Navigator.of(context).pop(true),
                              ),
                            ],
                          ),
                    );

                    if (confirm == true) {
                      final response = await CourseService.deleteCourse(
                        widget.course.courseId,
                      );

                      if (response.data == true) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Course deleted successfully'),
                          ),
                        );
                        Navigator.pop(context, 'refresh');
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              response.error ?? 'Failed to delete course',
                            ),
                          ),
                        );
                      }
                    }
                  },
                  icon: const Icon(Icons.delete, color: Colors.red),
                  label: const Text(
                    'Delete Course',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),

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

              // Export CSV Button
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: () async {
                    final marks = markCubit.state;

                    if (marks.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('No marks to export')),
                      );
                      return;
                    }

                    final total = marks.fold(0, (sum, mark) => sum + mark.mark);
                    final average = total / marks.length;

                    List<List<String>> csvData = [
                      ['Student Name', 'Mark'],
                      ...marks.map(
                        (mark) => [
                          mark.student.studentName,

                          mark.mark.toString(),
                        ],
                      ),
                      [],
                      ['Average Mark', '', average.toStringAsFixed(2)],
                    ];

                    await exportCSV(
                      context,
                      csvData,
                      widget.course.courseCode,
                      widget.course.courseName,
                    );
                  },
                  icon: const Icon(Icons.share),
                  label: const Text('Export All as CSV'),
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
    String courseCode,
    String courseName,
  ) async {
    try {
      final csv = const ListToCsvConverter().convert(csvData);
      final directory = await getApplicationDocumentsDirectory();

      final safeCode = courseCode
          .replaceAll(RegExp(r'[^\w\s-]'), '')
          .replaceAll(' ', '_');
      final safeName = courseName
          .replaceAll(RegExp(r'[^\w\s-]'), '')
          .replaceAll(' ', '_');

      final path = "${directory.path}/${safeCode}_${safeName}_Report.csv";
      final file = File(path);

      await file.writeAsString(csv);
      await Share.shareXFiles([
        XFile(path),
      ], text: 'Mark Report for $courseCode - $courseName');
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error exporting CSV: $e')));
    }
  }
}
