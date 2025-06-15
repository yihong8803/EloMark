import 'package:elomark/services/student_service.dart';
import 'package:flutter/material.dart';
import 'package:elomark/models/student.dart';
import 'package:elomark/services/student_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<Student> _studentFuture;

  @override
  void initState() {
    super.initState();
    // Start loading student data
    _studentFuture = loadStudent();
  }

  Future<Student> loadStudent() async {
    final response = await StudentService.getStudentDetail();

    if (response.error == null && response.data != null) {
      return response.data!;
    } else {
      throw Exception(response.error ?? 'Failed to load student');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Student Details')),
      body: FutureBuilder<Student>(
        future: _studentFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While loading show spinner
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // If error occurs
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            // Data loaded, show student card
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: StudentDetailCard(student: snapshot.data!),
            );
          } else {
            return Center(child: Text('No data'));
          }
        },
      ),
    );
  }
}

class StudentDetailCard extends StatelessWidget {
  final Student student;

  const StudentDetailCard({Key? key, required this.student}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (student.image != null && student.image!.isNotEmpty)
              ClipOval(
                child: Image.network(
                  student.image!,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Icon(Icons.person, size: 80),
                ),
              )
            else
              Icon(Icons.person, size: 80),
            SizedBox(height: 12),
            Text(
              student.studentName,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(student.studentName),
          ],
        ),
      ),
    );
  }
}
