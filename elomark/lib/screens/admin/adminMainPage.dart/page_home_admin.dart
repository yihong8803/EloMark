import 'package:elomark/color.dart';
import 'package:elomark/models/course.dart';
import 'package:elomark/screens/admin/add_student_admin.dart';
import 'package:elomark/screens/admin/adminMainPage.dart/cubit_home_admin.dart';
import 'package:elomark/screens/admin/adminMainPage.dart/row_home_admin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Ranking extends StatefulWidget {
  final Course course;

  const Ranking({super.key, required this.course});

  @override
  State<Ranking> createState() => _RankingState();
}

class _RankingState extends State<Ranking> with SingleTickerProviderStateMixin {
  late RankingCubit rankingCubit;
  late TabController _tabController;
  final List<String> categories = ['point', 'weight', 'frequency'];

  @override
  void initState() {
    super.initState();
    rankingCubit = RankingCubit();
    _tabController = TabController(length: categories.length, vsync: this);
  }

  @override
  void dispose() {
    rankingCubit.close();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: rankingCubit,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 2,
          title: Text(
            '${widget.course.courseCode} - ${widget.course.courseName}',
            style: const TextStyle(fontSize: 18),
          ),
          bottom: TabBar(
            controller: _tabController,
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
            tabs: categories.map((c) => Tab(text: c.toUpperCase())).toList(),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddStudent(course: widget.course),
                  ),
                );
              },
            ),
          ],
        ),
        backgroundColor: primary,
        body: Container(
          margin: const EdgeInsets.only(top: 20),
          padding: const EdgeInsets.only(top: 8.0),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child:
              BlocBuilder<RankingCubit, Map<String, List<Map<String, String>>>>(
                builder: (context, rankingData) {
                  return TabBarView(
                    controller: _tabController,
                    children:
                        categories.map((category) {
                          final filteredList = rankingData[category] ?? [];

                          if (filteredList.isEmpty) {
                            return const Center(
                              child: Text("No data available"),
                            );
                          }

                          return ListView.builder(
                            itemCount: filteredList.length,
                            itemBuilder: (context, index) {
                              final student = filteredList[index];
                              return RankingList(
                                category: category,
                                index: (index + 1).toString(),
                                stdName: student['stdName'] ?? '',
                                mark: student['mark'] ?? '',
                              );
                            },
                          );
                        }).toList(),
                  );
                },
              ),
        ),
      ),
    );
  }
}
