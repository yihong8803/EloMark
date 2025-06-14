import 'package:flutter/material.dart';

class StudentSearchField extends StatelessWidget {
  final List<String> studentNames;
  final void Function(String) onSelected;

  const StudentSearchField({
    super.key,
    required this.studentNames,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text == '') {
          return const Iterable<String>.empty();
        }
        return studentNames.where((String name) {
          return name.toLowerCase().contains(textEditingValue.text.toLowerCase());
        });
      },
      onSelected: onSelected,
      fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
        return TextField(
          controller: controller,
          focusNode: focusNode,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.person),
            labelText: 'Student Name',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      },
    );
  }
}
