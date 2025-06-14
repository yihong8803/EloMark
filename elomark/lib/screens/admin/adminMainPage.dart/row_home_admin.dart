import 'package:elomark/screens/admin/update/update_page.dart';
import 'package:flutter/material.dart';
import 'package:elomark/color.dart';

class RankingList extends StatefulWidget {
  final String index;
  final String stdName;
  final String mark;
  final String category;

  const RankingList({
    super.key,
    required this.stdName,
    required this.mark,
    required this.index,
    required this.category,
  });

  @override
  State<RankingList> createState() => _RankingListState();
}

class _RankingListState extends State<RankingList> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => UpdatePage(
                  stdName: widget.stdName,
                  mark: widget.mark,
                  category: widget.category,
                ),
          ),
        );
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
              color:
                  widget.index == '1'
                      ? Colors.yellow
                      : widget.index == '2'
                      ? const Color.fromARGB(255, 246, 235, 235)
                      : widget.index == '3'
                      ? Colors.orange
                      : widget.category == 'point'
                      ? point_color
                      : widget.category == 'weight'
                      ? weight_color
                      : frequency_color,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                Text(widget.index, style: TextName),
                Container(
                  margin: const EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(70),
                    image: DecorationImage(
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
                    child: Center(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          widget.stdName,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                          ),
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
              color:
                  widget.index == '1'
                      ? Colors.yellow
                      : widget.index == '2'
                      ? const Color.fromARGB(255, 246, 235, 235)
                      : widget.index == '3'
                      ? Colors.orange
                      : widget.category == 'point'
                      ? point_color
                      : widget.category == 'weight'
                      ? weight_color
                      : frequency_color,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  '${widget.mark}',
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
    );
  }
}
