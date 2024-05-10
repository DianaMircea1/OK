import "package:flutter/material.dart";

class MyTextBox extends StatelessWidget {
  final String text;
  final String sectionName;
  final void Function() onPressed;
  const MyTextBox({
    super.key,
    required this.text,
    required this.sectionName,
    required this.onPressed,
    });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromRGBO(239, 226, 242,1),
        border: Border.all(color: const Color.fromRGBO(227, 202, 232, 1),),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.only(
        left: 15,
        bottom: 15,
      ),
      margin: const EdgeInsets.only(left:20, right: 20, top: 20,),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        //section name
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //section name
            Text(sectionName,
            style: const TextStyle(
              color: Color.fromRGBO(208, 168, 216, 1),
              fontSize: 17,
            )
            ),
            //edit button
            IconButton(
              onPressed: onPressed, 
              icon: const Icon(
                Icons.edit, color: Color.fromRGBO(121, 74, 127, 1),
              )
            )
          ],
        ),
        //text 
        Text(text,
        style: const TextStyle(
          color: Color.fromRGBO(121, 74, 127, 1),
          fontSize: 15,
        ),
        ),
      ],
     ),
    );
  }
}