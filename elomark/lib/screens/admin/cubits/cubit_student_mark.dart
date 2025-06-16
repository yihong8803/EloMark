// student_mark_cubit.dart
import 'package:elomark/models/studentMark.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elomark/services/mark_service.dart';

class StudentMarkCubit extends Cubit<List<StudentMark>> {
  StudentMarkCubit() : super([]);

  Future<void> loadMarksByStudent(String studentId) async {
    final marks = await MarkService.getMarksByStudent(studentId);
    emit(marks);
  }

  void clearMarks() {
    emit([]);
  }
}
