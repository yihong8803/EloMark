import 'package:elomark/screens/admin/adminMainPage.dart/provider_home_admin.dart';
import 'package:elomark/screens/login.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => RankingPage(category: 'point'));

      default:
        return MaterialPageRoute(builder: (_) => RankingPage(category: 'point'));
    }
  }
}
