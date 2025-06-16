// student_mark_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elomark/models/student.dart';
import 'package:elomark/models/studentMark.dart';
import 'package:elomark/services/mark_service.dart';

class StudentMarkCubit extends Cubit<StudentMarkState> {
  StudentMarkCubit() : super(StudentMarkState());


  Future<void> loadMarksByStudent(String studentId) async {
    final result = await MarkService.getMarksByStudent(studentId);

    if (result != null) {
      emit(StudentMarkState(student: result.student, marks: result.marks));
    } else {
      emit(StudentMarkState()); // emit empty state on error
    }
  }

  void clearMarks() {
    emit(StudentMarkState());
  }
}