import 'package:flutter/material.dart';
class EmailPasswordInput extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isPassword;
  final Function(bool isValid)? onValidationChanged;
  final String? errorText;

  const EmailPasswordInput({
    required this.controller,
    required this.hintText,
    this.isPassword = false,
    this.onValidationChanged,
    this.errorText,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TextField(
          controller: controller,
          obscureText: isPassword,
          decoration: InputDecoration(
            hintText: hintText,
            errorText: errorText,
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            if (onValidationChanged != null) {
              // You can perform your validation here and notify the parent widget.
              bool isValid = true; // Replace this with your validation logic.
              onValidationChanged!(isValid);
            }
          },
        ),
        SizedBox(height: 10.0), // Adjust the spacing as needed.
      ],
    );
  }
}
