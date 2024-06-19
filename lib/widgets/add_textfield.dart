import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for FilteringTextInputFormatter

enum TextFieldInputType {
  text,
  number,
}

class AddTextfield extends StatelessWidget {
  final String hintText;
  final IconData prefixIcon;
  final TextEditingController controller;
  final TextFieldInputType inputType;

  const AddTextfield({
    Key? key,
    required this.hintText,
    required this.prefixIcon,
    required this.controller,
    this.inputType = TextFieldInputType.text, // Default input type is text
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextInputType keyboardType;
    List<TextInputFormatter> inputFormatters;

    // Determine keyboardType and inputFormatters based on inputType
    switch (inputType) {
      case TextFieldInputType.text:
        keyboardType = TextInputType.text;
        inputFormatters = [];
        break;
      case TextFieldInputType.number:
        keyboardType = TextInputType.number;
        inputFormatters = [
          FilteringTextInputFormatter.digitsOnly, // Filter out non-numeric characters
        ];
        break;
    }

    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(prefixIcon),
        filled: true,
        fillColor: Colors.grey.shade200,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
