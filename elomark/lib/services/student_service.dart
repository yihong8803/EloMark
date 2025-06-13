import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constant.dart';
import '../models/api_response.dart';
import '../models/student.dart';

class StudentService {
  // Login Function
  static Future<ApiResponse<Student>> login(
    String email,
    String password,
  ) async {
    ApiResponse<Student> apiResponse = ApiResponse();

    try {
      final response = await http.post(
        Uri.parse(loginURL),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      switch (response.statusCode) {
        case 200:
          final data = jsonDecode(response.body);
          final student = Student.fromJson(data);
          apiResponse.data = student;
          break;

        case 422:
          final errors = jsonDecode(response.body)['errors'];
          apiResponse.error = errors[errors.keys.elementAt(0)][0];
          break;

        case 403:
          apiResponse.error = jsonDecode(response.body)['message'];
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

  // Register Function
  static Future<ApiResponse<Student>> register({
    required String studentName,
    required String studentEmail,
    required String password,
    required String confirmPassword,
  }) async {
    ApiResponse<Student> apiResponse = ApiResponse();

    try {
      final response = await http.post(
        Uri.parse(registerURL),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'student_name': studentName,
          'student_email': studentEmail,
          'password': password,
          'password_confirmation': confirmPassword,
        }),
      );

      switch (response.statusCode) {
        case 200:
          final data = jsonDecode(response.body);
          final student = Student.fromJson(data);
          apiResponse.data = student;
          break;

        case 422:
          final errors = jsonDecode(response.body)['errors'];
          apiResponse.error = errors[errors.keys.elementAt(0)][0];
          break;

        case 403:
          apiResponse.error = jsonDecode(response.body)['message'];
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

  // Logout Function (just a placeholder since no token is stored)
  static Future<void> logout() async {
    // If you later add token management, clear token here
  }

  // Get Student Detail
static Future<ApiResponse<Student>> getStudentDetail() async {
  ApiResponse<Student> apiResponse = ApiResponse();
  print('Calling backend...');
  print('Requesting URL: $studentURL');
  try {
    final response = await http.get(Uri.parse(studentURL)).timeout(Duration(seconds: 100));
    print('HTTP status: ${response.statusCode}');
    print('Body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('Decoded data: $data');

      if (data is List && data.isNotEmpty) {
        apiResponse.data = Student.fromJson(data[0]);
      } else {
        apiResponse.error = 'No student data found';
      }
    } else {
      apiResponse.error = 'Server error: ${response.statusCode}';
    }
  } catch (e) {
    print('Exception caught: $e');
    apiResponse.error = 'Exception: $e';
  }

  print('Returning apiResponse: error=${apiResponse.error}, data=${apiResponse.data}');
  return apiResponse;
}

  Future<Student> loadStudent() async {
    print('Loading student...');
    final response = await StudentService.getStudentDetail();
    print('StudentService response received');
    print('Error: ${response.error}');
    print('Data: ${response.data}');

    if (response.error == null && response.data != null) {
      print('Returning student data');
      return response.data!;
    } else {
      print('Throwing exception: ${response.error}');
      throw Exception(response.error ?? 'Failed to load student');
    }
  }
}
