import 'dart:io';
import 'package:csv/csv.dart';
import 'package:elomark/models/studentMark.dart';
import 'package:elomark/screens/student/row_student_mark.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:elomark/color.dart';
import 'package:elomark/screens/admin/cubits/cubit_student_mark.dart';

class StudentMarkPage extends StatefulWidget {
  final String studentId;

  const StudentMarkPage({super.key, required this.studentId});

  @override
  State<StudentMarkPage> createState() => _StudentMarkPageState();
}

class _StudentMarkPageState extends State<StudentMarkPage> {
  late StudentMarkCubit studentMarkCubit;

  @override
  void initState() {
    super.initState();
    studentMarkCubit = StudentMarkCubit();
    studentMarkCubit.loadMarksByStudent(widget.studentId);
  }

  @override
  void dispose() {
    studentMarkCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: studentMarkCubit,
      child: BlocBuilder<StudentMarkCubit, StudentMarkState>(
        builder: (context, state) {
          final studentName = state.student?.studentName ?? 'Student';

          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              elevation: 2,
              title: Text(
                state.student != null ? studentName : 'Loading...',
                style: const TextStyle(fontSize: 18),
              ),
            ),
            backgroundColor: primary,
            body: Container(
              margin: const EdgeInsets.only(top: 20),
              padding: const EdgeInsets.all(8),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  Expanded(
                    child:
                        state.marks.isEmpty
                            ? const Center(child: Text("No marks available"))
                            : ListView.builder(
                              itemCount: state.marks.length,
                              itemBuilder: (context, index) {
                                final mark = state.marks[index];
                                return StudentMarkRow(markData: mark);
                              },
                            ),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: () async {
                        final marks = state.marks;

                        if (marks.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('No marks to export')),
                          );
                          return;
                        }

                        final total = marks.fold(
                          0,
                          (sum, mark) => sum + mark.mark,
                        );
                        final average = total / marks.length;

                        List<List<String>> csvData = [
                          ['Course Name', 'Mark'],
                          ...marks.map(
                            (mark) => [
                              mark.course.courseName,
                              mark.mark.toString(),
                            ],
                          ),
                          [],
                          ['Average Mark', average.toStringAsFixed(2)],
                        ];

                        await exportCSV(context, csvData, studentName);
                      },
                      icon: const Icon(Icons.share),
                      label: const Text('Export Marks'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> exportCSV(
    BuildContext context,
    List<List<String>> csvData,
    String studentName,
  ) async {
    try {
      final csv = const ListToCsvConverter().convert(csvData);
      final directory = await getApplicationDocumentsDirectory();

      // Sanitize file name
      final safeName = studentName
          .replaceAll(RegExp(r'[^\w\s-]'), '')
          .replaceAll(' ', '_');
      final filePath = "${directory.path}/${safeName}_Mark_Report.csv";

      final file = File(filePath);
      await file.writeAsString(csv);
      await Share.shareXFiles([
        XFile(filePath),
      ], text: 'Mark Report for $studentName');
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error exporting CSV: $e')));
    }
  }
}
