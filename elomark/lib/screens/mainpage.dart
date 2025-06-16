import 'package:flutter/material.dart';
import 'package:elomark/models/student.dart';

class MainPage extends StatelessWidget {
  final Student student;

  const MainPage({Key? key, required this.student}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Dashboard")),
      body: Center(child: Text("Welcome, ${student.studentName}!")),
    );
  }
}
