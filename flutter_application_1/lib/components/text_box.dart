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
        border: Border.all(color: Colors.grey[300]!,),
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
            Text(sectionName,),
            //edit button
            IconButton(
              onPressed: onPressed, 
              icon: Icon(
                Icons.edit, color: Colors.grey[500],
              )
            )
          ],
        ),
        //text 
        Text(text),
      ],
     ),
    );
  }
}