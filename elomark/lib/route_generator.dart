import 'package:elomark/screens/login.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => HomePage());

      default:
        return MaterialPageRoute(builder: (_) => HomePage());
    }
  }
}
