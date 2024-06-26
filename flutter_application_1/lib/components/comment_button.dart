import "package:flutter/material.dart";
// ignore: unnecessary_import
import "package:flutter/widgets.dart";
class CommentButton extends StatelessWidget {
  final void Function()? onTap;
  const CommentButton({
    super.key,
    required this.onTap,
    });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: const Icon(
        Icons.comment,
        color: Color.fromRGBO(121, 74, 127, 1),
      )
    );
  }
}