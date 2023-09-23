import 'package:flutter/material.dart';

class EmailPasswordInput extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isPassword;
  final ValueChanged<bool>? onValidationChanged;

  const EmailPasswordInput({
    super.key,
    required this.controller,
    required this.hintText,
    this.isPassword = false,
    this.onValidationChanged,
  });

  @override
  State<EmailPasswordInput> createState() => _EmailPasswordInputState();
}

class _EmailPasswordInputState extends State<EmailPasswordInput> {
  String? _errorText;

  void _validateInput(String text) {
    if (text.isEmpty) {
      setState(() {
        _errorText = 'Please enter your details first.';
      });
      widget.onValidationChanged?.call(false);
    } else if (widget.isPassword && text.length < 6) {
      setState(() {
        _errorText =
            'Password must be at least 6 characters long and include numbers, symbols, and uppercase letters for security.';
      });
      widget.onValidationChanged?.call(false);
    } else if (!widget.isPassword &&
        !text.contains('@') &&
        !text.contains('.')) {
      setState(() {
        _errorText = 'Please enter a valid email address.';
      });
      widget.onValidationChanged?.call(false);
    } else {
      setState(() {
        _errorText = null;
      });
      widget.onValidationChanged?.call(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: widget.controller,
          onChanged: (text) {
            _validateInput(text);
          },
          decoration: InputDecoration(
            hintText: widget.hintText,
            errorText: _errorText,
            border: const OutlineInputBorder(),
          ),
          obscureText: widget.isPassword,
        ),
        const SizedBox(height: 10), // Adjust the spacing as needed
      ],
    );
  }
}