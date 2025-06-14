import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constant.dart';
import '../models/api_response.dart';
import '../models/course.dart';

class CourseService {
  // Get All Courses
  static Future<ApiResponse<List<Course>>> getCourses() async {
    ApiResponse<List<Course>> apiResponse = ApiResponse();

    try {
      final response = await http.get(Uri.parse(courseURL));

      switch (response.statusCode) {
        case 200:
          final List data = jsonDecode(response.body);
          apiResponse.data = data.map((e) => Course.fromJson(e)).toList();
          break;

        default:
          apiResponse.error = serverError;
          break;
      }
    } catch (e) {
      apiResponse.error = somethingWentWrong;
    }

    return apiResponse;
  }

// Add course and return created Course object
static Future<ApiResponse<Course>> addCourse({
  required String courseCode,
  required String courseName,
}) async {
  ApiResponse<Course> apiResponse = ApiResponse();

  try {
    final response = await http.post(
      Uri.parse(courseURL),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'course_code': courseCode,
        'course_name': courseName,
      }),
    );

    switch (response.statusCode) {
      case 200:
      case 201:
        final data = jsonDecode(response.body);
        apiResponse.data = Course.fromJson(data);
        break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.error = errors[errors.keys.first][0];
        break;
      default:
        apiResponse.error = serverError;
    }
  } catch (e) {
    apiResponse.error = somethingWentWrong;
  }

  return apiResponse;
}

  // Get Course by ID
  static Future<ApiResponse<Course>> getCourse(int id) async {
    ApiResponse<Course> apiResponse = ApiResponse();

    try {
      final response = await http.get(Uri.parse('$courseURL/$id'));

      switch (response.statusCode) {
        case 200:
          final data = jsonDecode(response.body);
          apiResponse.data = Course.fromJson(data);
          break;

        default:
          apiResponse.error = serverError;
          break;
      }
    } catch (e) {
      apiResponse.error = somethingWentWrong;
    }

    return apiResponse;
  }
// Create Course and return the created Course model
static Future<ApiResponse<Course>> createCourse(Course course) async {
  ApiResponse<Course> apiResponse = ApiResponse();

  try {
    final response = await http.post(
      Uri.parse(courseURL),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(course.toJson()),
    );

    switch (response.statusCode) {
      case 201:
      case 200:
        final data = jsonDecode(response.body);
        apiResponse.data = Course.fromJson(data);
        break;

      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.error = errors[errors.keys.first][0];
        break;

      default:
        apiResponse.error = serverError;
        break;
    }
  } catch (e) {
    apiResponse.error = somethingWentWrong;
  }

  return apiResponse;
}

  // Update Course
  static Future<ApiResponse<Course>> updateCourse(int id, Course course) async {
    ApiResponse<Course> apiResponse = ApiResponse();

    try {
      final response = await http.put(
        Uri.parse('$courseURL/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(course.toJson()),
      );

      switch (response.statusCode) {
        case 200:
          final data = jsonDecode(response.body);
          apiResponse.data = Course.fromJson(data);
          break;

        case 422:
          final errors = jsonDecode(response.body)['errors'];
          apiResponse.error = errors[errors.keys.elementAt(0)][0];
          break;

        default:
          apiResponse.error = serverError;
          break;
      }
    } catch (e) {
      apiResponse.error = somethingWentWrong;
    }

    return apiResponse;
  }

  // Delete Course
  static Future<ApiResponse<bool>> deleteCourse(int id) async {
    ApiResponse<bool> apiResponse = ApiResponse();

    try {
      final response = await http.delete(Uri.parse('$courseURL/$id'));

      switch (response.statusCode) {
        case 200:
          apiResponse.data = true;
          break;

        default:
          apiResponse.error = serverError;
          break;
      }
    } catch (e) {
      apiResponse.error = somethingWentWrong;
    }

    return apiResponse;
  }
}
