import 'package:elomark/models/studentMark.dart';
import 'package:elomark/screens/admin/cubits/cubit_student_mark.dart';
import 'package:elomark/screens/student/row_student_mark.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elomark/color.dart';

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
      value: studentMarkCubit, // ✅ Provide the correct cubit
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 2,
          title: const Text(
            'My Courses and Marks',
            style: TextStyle(fontSize: 18),
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
          child: BlocBuilder<StudentMarkCubit, List<StudentMark>>(
            builder: (context, marks) {
              if (marks.isEmpty) {
                return const Center(child: Text("No marks available"));
              }

              return ListView.builder(
                itemCount: marks.length,
                itemBuilder: (context, index) {
                  final mark = marks[index];
                  return StudentMarkRow(markData: mark); // ✅ Should accept StudentMark
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
