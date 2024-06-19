import 'package:flutter/material.dart';

class AccountTextfield extends StatelessWidget {
  final String hintText;
  final IconData prefixIcon;
  final IconData? postfixIcon;
  final TextEditingController controller;

  const AccountTextfield({
    super.key,
    required this.hintText,
    required this.prefixIcon,
    this.postfixIcon,
    required this.controller
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      width: screenWidth * 0.8,
      height: screenHeight * 0.05,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Icon(prefixIcon),
          suffixIcon: Icon(postfixIcon),
          fillColor: const Color.fromARGB(179, 176, 175, 175),
          filled: true,
          hintText: hintText,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10),
          ),
          contentPadding: EdgeInsets.symmetric(
            vertical: screenHeight * 0.013,
            horizontal: screenWidth * 0.05,
          ),
        ),
      ),
    );
  }
}
