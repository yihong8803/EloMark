import 'dart:convert';
import 'package:elomark/models/studentMark.dart';
import 'package:http/http.dart' as http;
import '../models/mark.dart';
import '../constant.dart';

class MarkService {
  // Get all marks
  static Future<List<Mark>> getAllMarks() async {
    try {
      final response = await http.get(Uri.parse(examMarkURL));

      if (response.statusCode == 200) {
        final List<dynamic> body = jsonDecode(response.body)['data'];
        return body.map((json) => Mark.fromJson(json)).toList();
      } else {
        print('Failed to load marks: ${response.body}');
        return [];
      }
    } catch (e) {
      print('Error in getAllMarks: $e');
      return [];
    }
  }

  // Get all marks by student ID (StudentMark model)
  static Future<List<StudentMark>> getMarksByStudent(String studentId) async {
    try {
      final response = await http.get(
        Uri.parse('$examMarkURL/students/$studentId'),
      );

      print('Response body (student): ${response.body}');

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        if (decoded is List) {
          return decoded
              .map<StudentMark>((json) => StudentMark.fromJson(json))
              .toList();
        } else {
          print('Response is not a list');
          return [];
        }
      } else {
        print(
          'Failed to load student marks: ${response.statusCode} - ${response.body}',
        );
        return [];
      }
    } catch (e) {
      print('Error in getMarksByStudent: $e');
      return [];
    }
  }

  // Get all marks by course ID
  static Future<List<Mark>> getMarksByCourse(int courseId) async {
    try {
      final response = await http.get(
        Uri.parse('$examMarkURL/courses/$courseId'),
      );
      print('Response body: ${response.body}');
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        print('Response body: ${response.body}');
        if (body['data'] is List) {
          final List<dynamic> data = body['data'];
          print('Response body: ${response.body}');
          return data.map((json) => Mark.fromJson(json)).toList();
        } else {
          print('Data is not a list');
          return [];
        }
      } else {
        print('Failed to load course marks: ${response.body}');
        return [];
      }
    } catch (e) {
      print('Error in getMarksByCourse: $e');
      return [];
    }
  }

  // Create a new mark
  static Future<bool> createMark({
    required int studentId,
    required int courseId,
    required double mark,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(examMarkURL),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'student_id': studentId,
          'course_id': courseId,
          'mark': mark,
        }),
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Error in createMark: $e');
      return false;
    }
  }

  // Update an existing mark
  static Future<bool> updateMark({
    required int studentId,
    required int courseId,
    required double mark,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('$examMarkURL/student/$studentId/course/$courseId'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'mark': mark}),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error in updateMark: $e');
      return false;
    }
  }

  // Delete a mark
  static Future<bool> deleteMark(int studentId, int courseId) async {
    try {
      final response = await http.delete(
        Uri.parse('$examMarkURL/student/$studentId/course/$courseId'),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error in deleteMark: $e');
      return false;
    }
  }
}
