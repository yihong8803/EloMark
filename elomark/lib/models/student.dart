import 'package:elomark/models/course.dart';

class Student {
  final int studentId;
  final String studentName;
  final String studentEmail;
  final String? image;

  Student({
    required this.studentId,
    required this.studentName,
    required this.studentEmail,
    this.image,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      studentId: json['student_id'],
      studentName: json['student_name'],
      studentEmail: json['student_email'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'student_id': studentId,
      'student_name': studentName,
      'student_email': studentEmail,
      'image': image,
    };
  }
}



class ExamMark {
  final int id;
  final int studentId;
  final int courseId;
  final double mark;
  final String createdAt;
  final String updatedAt;
  final Student student;
  final Course course;

  ExamMark({
    required this.id,
    required this.studentId,
    required this.courseId,
    required this.mark,
    required this.createdAt,
    required this.updatedAt,
    required this.student,
    required this.course,
  });

  factory ExamMark.fromJson(Map<String, dynamic> json) {
    return ExamMark(
      id: json['id'],
      studentId: json['student_id'],
      courseId: json['course_id'],
      mark: (json['mark'] as num).toDouble(),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      student: Student.fromJson(json['student']),
      course: Course.fromJson(json['course']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'student_id': studentId,
      'course_id': courseId,
      'mark': mark,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'student': student.toJson(),
      'course': course.toJson(),
    };
  }
}
