import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/email_pass_input_bloc.dart';

class EmailPasswordInput extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isPassword;

  const EmailPasswordInput({
    Key? key,
    required this.controller,
    required this.hintText,
    this.isPassword = false, required Null Function(dynamic isValid) onValidationChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final inputBloc = BlocProvider.of<EmailPasswordInputBloc>(context);

    return BlocBuilder<EmailPasswordInputBloc, EmailPasswordInputState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: controller,
              onChanged: (text) {
                inputBloc.validateInput(text, isPassword);
              },
              decoration: InputDecoration(
                hintText: hintText,
                errorText: state.errorText,
                border: const OutlineInputBorder(),
              ),
              obscureText: isPassword,
            ),
            const SizedBox(height: 10), // Adjust the spacing as needed
          ],
        );
      },
    );
  }
}
