//Platform connecting cubit and UI

import 'package:elomark/screens/admin/adminMainPage.dart/cubit_home_admin.dart';
import 'package:elomark/screens/admin/adminMainPage.dart/page_home_admin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class RankingPage extends StatelessWidget {
  final String category;
  const RankingPage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    //Bloc Provider
    return BlocProvider(
      create: (context) => RankingCubit(),
      child: Ranking(category: category),
    );
  }
}
