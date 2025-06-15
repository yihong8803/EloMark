//Platform connecting cubit and UI

import 'package:elomark/models/course.dart';
import 'package:elomark/screens/admin/cubits/cubit_home_admin.dart';
import 'package:elomark/screens/admin/adminMainPage.dart/page_home_admin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class RankingPage extends StatelessWidget {
  final Course course;
  const RankingPage({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    //Bloc Provider
    return BlocProvider(
      create: (context) => RankingCubit(),
      child: MarkPage(course: course),
    );
  }
}
