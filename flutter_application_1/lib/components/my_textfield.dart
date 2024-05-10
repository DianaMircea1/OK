import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final controller;
  final String hintText;
  final bool obscureText;

  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromRGBO(227, 202, 232, 1)),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color:  Color.fromRGBO(121, 74, 127, 1)),
            ),
            fillColor: const Color.fromRGBO(239, 226, 242,1),
            filled: true,
            hintText: hintText,
            hintStyle: const TextStyle(color: Color.fromRGBO(208, 168, 216, 1))),
      ),
    );
  }
}