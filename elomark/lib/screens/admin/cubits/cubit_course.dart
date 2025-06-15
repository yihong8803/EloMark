import 'package:elomark/models/course.dart';
import 'package:elomark/services/course_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CourseCubit extends Cubit<List<Course>> {
  CourseCubit() : super([]);

  // Load courses from backend
  Future<void> loadCourses() async {
    final response = await CourseService.getCourses();
    if (response.error == null && response.data != null) {
      emit(response.data!);
    } else {
      // Optionally, handle error state or log it
      print('Failed to load courses: ${response.error}');
    }
  }

  Future<void> addCourse(Course course) async {
  final response = await CourseService.addCourse(
    courseCode: course.courseCode,
    courseName: course.courseName,
  );

  if (response.error == null && response.data != null) {
    emit([...state, response.data!]); // Append the returned course
  } else {
    print('Failed to add course: ${response.error}');
  }
}

  // Optional: Refresh/reload courses
  void refresh() {
    loadCourses();
  }
}