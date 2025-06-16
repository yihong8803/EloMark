import 'package:elomark/models/studentMark.dart';
import 'package:flutter/material.dart';
import 'package:elomark/color.dart';

class StudentMarkRow extends StatelessWidget {
  final StudentMark markData;

  const StudentMarkRow({super.key, required this.markData});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Row(
        children: [
          // Left: Course Info
          Expanded(
            flex: 7,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    markData.course.courseCode,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    markData.course.courseName,
                    style: const TextStyle(fontSize: 13),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 10),

          // Right: Mark
          Expanded(
            flex: 3,
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                color: point_color,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(
                child: Text(
                  markData.mark.toString(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
