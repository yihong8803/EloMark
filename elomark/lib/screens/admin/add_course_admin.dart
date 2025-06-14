import 'package:elomark/models/course.dart';
import 'package:elomark/services/course_service.dart';
import 'package:flutter/material.dart';

class AddCoursePage extends StatefulWidget {
  const AddCoursePage({super.key});

  @override
  State<AddCoursePage> createState() => _AddCoursePageState();
}

class _AddCoursePageState extends State<AddCoursePage> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _nameController = TextEditingController();
  bool _isSubmitting = false;

  Future<void> _submitCourse() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSubmitting = true);

      final response = await CourseService.addCourse(
        courseCode: _codeController.text,
        courseName: _nameController.text,
      );

      setState(() => _isSubmitting = false);

      if (response.error == null && response.data != null) {
        final Course course = response.data!;
        Navigator.pop(context, course); // ✅ return full Course object
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.error ?? 'Failed to add course')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Course')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _codeController,
                decoration: const InputDecoration(labelText: 'Course Code'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter course code' : null,
              ),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Course Name'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter course name' : null,
              ),
              const SizedBox(height: 20),
              _isSubmitting
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _submitCourse,
                      child: const Text('Submit'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
