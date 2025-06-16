import 'course.dart';

class Student {
  final int studentId;
  final String studentName;
  final String studentEmail;
  final String password;
  final String? image;

  Student({
    required this.studentId,
    required this.studentName,
    required this.studentEmail,
    required this.password,
    this.image,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      studentId: json['student_id'],
      studentName: json['student_name'],
      studentEmail: json['student_email'],
      password: json['password'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'student_id': studentId,
      'student_name': studentName,
      'student_email': studentEmail,
      'password': password,
      'image': image,
    };
  }
}

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

class StudentMarkState {
  final Student? student;
  final List<StudentMark> marks;

  StudentMarkState({
    this.student,
    this.marks = const [],
  });

  StudentMarkState copyWith({
    Student? student,
    List<StudentMark>? marks,
  }) {
    return StudentMarkState(
      student: student ?? this.student,
      marks: marks ?? this.marks,
    );
  }
}


class StudentMarkResponse {
  final Student student;
  final List<StudentMark> marks;

  StudentMarkResponse({required this.student, required this.marks});

  factory StudentMarkResponse.fromJson(Map<String, dynamic> json) {
    return StudentMarkResponse(
      student: Student.fromJson(json['student']),
      marks: (json['marks'] as List)
          .map((mark) => StudentMark.fromJson(mark))
          .toList(),
    );
  }
}

