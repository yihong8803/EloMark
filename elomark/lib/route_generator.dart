import 'package:elomark/screens/admin/adminMainPage.dart/provider_home_admin.dart';
import 'package:elomark/screens/admin/course_select_page.dart';
import 'package:elomark/screens/login.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        // Redirect to course selection on app start
        final courseList = args as List<Map<String, String>>? ?? [];
        return MaterialPageRoute(builder: (_) => CourseSelectionPage());

      case '/course-selection':
        final courseList = args as List<Map<String, String>>;
        return MaterialPageRoute(builder: (_) => CourseSelectionPage());

      default:
        final courseList = args as List<Map<String, String>>? ?? [];
        return MaterialPageRoute(builder: (_) => CourseSelectionPage());
    }
  }
}
