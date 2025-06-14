
class Course {
  final int courseId;
  final String courseName;
  final String courseCode;

  Course({
    required this.courseId,
    required this.courseName,
    required this.courseCode,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      courseId: json['course_id'],
      courseName: json['course_name'],
      courseCode: json['course_code'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'course_id': courseId,
      'course_name': courseName,
      'course_code': courseCode,
    };
  }
}