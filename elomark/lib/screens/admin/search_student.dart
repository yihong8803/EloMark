import 'dart:convert';
import 'package:elomark/constant.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class StudentSearchField extends StatefulWidget {
  final void Function(String) onSelected;

  const StudentSearchField({super.key, required this.onSelected});

  @override
  State<StudentSearchField> createState() => _StudentSearchFieldState();
}

class _StudentSearchFieldState extends State<StudentSearchField> {
  List<String> studentNames = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchStudents();
  }

  Future<void> fetchStudents() async {
    final url = Uri.parse(studentURL); // fetch all students from base URL

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);
        final names = List<String>.from(
          jsonBody.map((student) => student['student_name']),
        );

        print("DEBUG - Student names: $names");

        setState(() {
          studentNames = names;
          isLoading = false;
        });
      } else {
        print('Server returned ${response.statusCode}');
        setState(() => isLoading = false);
      }
    } catch (e) {
      print('Error fetching student names: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return const Iterable<String>.empty();
        }
        return studentNames.where(
          (name) =>
              name.toLowerCase().contains(textEditingValue.text.toLowerCase()),
        );
      },
      onSelected: widget.onSelected,
      fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
        return TextField(
          controller: controller,
          focusNode: focusNode,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.person),
            labelText: 'Student Name',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      },
    );
  }
}
