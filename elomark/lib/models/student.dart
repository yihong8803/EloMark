import 'package:elomark/models/course.dart';

class Student {
  final int studentId;
  final String studentName;

  final String? image;

  Student({
    required this.studentId,
    required this.studentName,

    this.image,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      studentId: json['student_id'],
      studentName: json['student_name'],

      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'student_id': studentId,
      'student_name': studentName,
      'image': image,
    };
  }
}


