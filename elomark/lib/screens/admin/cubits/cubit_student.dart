import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elomark/models/student.dart';
import 'package:elomark/services/student_service.dart';
import 'package:elomark/models/api_response.dart';

class StudentCubit extends Cubit<Student?> {
  StudentCubit() : super(null);

  // Load student detail from backend
  Future<void> loadStudent() async {
    try {
      final response = await StudentService.getStudentDetail();
      if (response.error == null && response.data != null) {
        emit(response.data);
      } else {
        print('Failed to load student: ${response.error}');
        emit(null);
      }
    } catch (e) {
      print('Exception while loading student: $e');
      emit(null);
    }
  }

  // Login student
  Future<void> login(String email, String password) async {
    try {
      final response = await StudentService.login(email, password);
      if (response.error == null && response.data != null) {
        emit(response.data);
      } else {
        print('Login failed: ${response.error}');
        emit(null);
      }
    } catch (e) {
      print('Login exception: $e');
      emit(null);
    }
  }

  // Register student
  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      final response = await StudentService.register(
        studentName: name,
        studentEmail: email,
        password: password,
        confirmPassword: confirmPassword,
      );
      if (response.error == null && response.data != null) {
        emit(response.data);
      } else {
        print('Registration failed: ${response.error}');
        emit(null);
      }
    } catch (e) {
      print('Registration exception: $e');
      emit(null);
    }
  }

  // Optional: Clear current student (logout-like behavior)
  void clearStudent() {
    emit(null);
  }
}
