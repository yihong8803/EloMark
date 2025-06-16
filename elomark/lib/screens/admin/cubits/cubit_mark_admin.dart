import 'package:elomark/models/mark.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elomark/services/mark_service.dart';

class MarkCubit extends Cubit<List<Mark>> {
  MarkCubit() : super([]);

  Future<void> loadMarksByCourse(int courseId) async {
    final marks = await MarkService.getMarksByCourse(courseId);
    emit(marks);
  }



  void clearMarks() {
    emit([]);
  }
}
