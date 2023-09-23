import 'package:blue_dog/email_password_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/forgot_password_bloc.dart';

class ForgotPassScreen extends StatelessWidget {
  const ForgotPassScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final forgotPasswordBloc = BlocProvider.of<ForgotPasswordBloc>(context);

    final TextEditingController _emailController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('BLUE DOG'),
      ),
      body: BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
        builder: (context, state) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const SizedBox(height: 65.0),
                  Image.asset(
                    'assets/images/blue_dog.png',
                    height: 150.0,
                    width: 150.0,
                  ),
                  const SizedBox(height: 110.0),
                  EmailPasswordInput(
                    controller: _emailController,
                    hintText: 'Email', onValidationChanged: (isValid) {  },
                  ),
                  const SizedBox(height: 30),
                  // ignore: sized_box_for_whitespace
                  Container(
                    width: 350,
                    height: 50,
                    child: OutlinedButton(
                      onPressed: () {
                        if (!state.isLoading) {
                          // Dispatch a SendPasswordResetEmail event to the bloc
                          forgotPasswordBloc.add(
                            SendPasswordResetEmail(email: _emailController.text),
                          );
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.blue),
                        textStyle: MaterialStateTextStyle.resolveWith(
                            (states) => const TextStyle(color: Colors.white)),
                      ),
                      child: state.isLoading
                          ? const CircularProgressIndicator() // Show loading indicator
                          : const Text('Send Link'),
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  // ignore: sized_box_for_whitespace
                  Container(
                    width: 350,
                    height: 50,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Back'),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
