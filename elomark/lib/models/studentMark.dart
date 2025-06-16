import 'package:elomark/models/course.dart';

class StudentMark {
  final int id;
  final int studentId;
  final int courseId;
  final int mark;
  final String? createdAt;
  final String? updatedAt;
  final Course course;

  StudentMark({
    required this.id,
    required this.studentId,
    required this.courseId,
    required this.mark,
    required this.createdAt,
    required this.updatedAt,
    required this.course,
  });

  factory StudentMark.fromJson(Map<String, dynamic> json) {
    return StudentMark(
      id: json['id'],
      studentId: json['student_id'],
      courseId: json['course_id'],
      mark: (json['mark'] as num).toInt(),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
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
      'course': course.toJson(),
    };
  }
}
