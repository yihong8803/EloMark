import 'package:elomark/color.dart';
import 'package:elomark/screens/admin/add_student_admin.dart';
import 'package:elomark/screens/admin/adminMainPage.dart/cubit_home_admin.dart';
import 'package:elomark/screens/admin/adminMainPage.dart/row_home_admin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Ranking extends StatelessWidget {
  final String category; // e.g., 'point', 'weight', 'frequency'
  const Ranking({super.key, required this.category});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 2,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 8.0,
              ), // Move title a bit right
              child: Text(category, style: TextStyle(fontSize: 18)),
            ),
            SizedBox(width: 4),
            PopupMenuButton<String>(
              icon: Icon(Icons.arrow_drop_down),
              onSelected: (String selectedCategory) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Ranking(category: selectedCategory),
                  ),
                );
              },
              itemBuilder: (BuildContext context) {
                return ['point', 'weight', 'frequency'].map((String option) {
                  return PopupMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList();
              },
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddStudent(category: category),
                ),
              );
            },
          ),
        ],
      ),

      backgroundColor: primary,
      body: Container(
        margin: EdgeInsets.only(top: 20),
        padding: const EdgeInsets.only(top: 8.0),
        // You can remove fixed height here; let it fill the space naturally
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child:
            BlocBuilder<RankingCubit, Map<String, List<Map<String, String>>>>(
              builder: (context, rankings) {
                final selectedList = rankings[category] ?? [];

                return ListView.builder(
                  itemCount: selectedList.length,
                  itemBuilder: (context, index) {
                    return RankingList(
                      category: category,
                      index: (index + 1).toString(),
                      stdName: selectedList[index]['stdName']!,
                      mark: selectedList[index]['mark']!,
                    );
                  },
                );
              },
            ),
      ),
    );
  }
}
