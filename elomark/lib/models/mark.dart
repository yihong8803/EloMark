import 'package:elomark/models/course.dart';
import 'package:elomark/models/student.dart';

class Mark {
  final int id;
  final int studentId;
  final int courseId;
  final int mark; // changed from double to int
  final String? createdAt;
  final String? updatedAt;
  final Student student;
  final Course course;

  Mark({
    required this.id,
    required this.studentId,
    required this.courseId,
    required this.mark,
    required this.createdAt,
    required this.updatedAt,
    required this.student,
    required this.course,
  });

  factory Mark.fromJson(Map<String, dynamic> json) {
    return Mark(
      id: json['id'],
      studentId: json['student_id'],
      courseId: json['course_id'],
      mark: (json['mark'] as num).toInt(), // convert safely to int
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
