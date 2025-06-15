import 'package:elomark/models/mark.dart';
import 'package:elomark/screens/admin/update/update_page.dart';
import 'package:flutter/material.dart';
import 'package:elomark/color.dart';

class MarkList extends StatelessWidget {
  final Mark markData;
  final VoidCallback onRefresh;

  const MarkList({super.key, required this.markData, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UpdatePage(markData: markData),
          ),
        );

        if (result == 'refresh') {
          onRefresh(); // ✅ Call refresh if needed
        }
      },
      child: Row(
        children: [
          // Left portion
          Container(
            padding: const EdgeInsets.only(left: 8),
            margin: const EdgeInsets.all(10.0),
            height: 60,
            width: MediaQuery.of(context).size.width * 0.7,
            decoration: BoxDecoration(
              color: point_color,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(70),
                    image: const DecorationImage(
                      image: AssetImage("assets/images/ava.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  width: 40,
                  height: 40,
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 20),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        markData.student.studentName,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Right portion
          Container(
            padding: const EdgeInsets.all(5),
            height: 60,
            width: MediaQuery.of(context).size.width * 0.23,
            decoration: BoxDecoration(
              color: point_color,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: Text(
                markData.mark.toString(),
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
