import "package:flutter/material.dart";

class Comment extends StatelessWidget {
  final String text;
  final String user;
  final String time;
  const Comment({
    super.key,
    required this.text,
    required this.user,
    required this.time,
    });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromRGBO(227, 202, 232, 1),
        borderRadius: BorderRadius.circular(4),
      ),
      margin: const EdgeInsets.only(bottom: 5),
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //comment
          Text(text,
          style: const TextStyle(color: Color.fromRGBO(68, 35, 72, 1)),
          ),

          const SizedBox(height: 5),

          //user and time
          Row(
            children: [
              Text(user,
                style: const TextStyle(color:  Color.fromRGBO(98, 60, 103, 1)),
              ),
               const Text(
                " - ",
                style:  TextStyle(color: Color.fromRGBO(98, 60, 103, 1)),
                ),
              Text(time,
                style: const TextStyle(color: Color.fromRGBO(98, 60, 103, 1)),
                ),
            ],
          ),

        ],
      ),
    );
  }
}