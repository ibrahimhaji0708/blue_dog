import 'package:blue_dog/email_password_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/register_bloc.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final registrationBloc = BlocProvider.of<RegistrationBloc>(context);

    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('BLUE DOG'),
      ),
      body: BlocBuilder<RegistrationBloc, RegistrationState>(
        builder: (context, state) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 63.0),
                  Image.asset(
                    'assets/images/blue_dog.png',
                    height: 150.0,
                    width: 150.0,
                  ),
                  const SizedBox(height: 70.0),
                  EmailPasswordInput(
                    controller: _emailController,
                    hintText: 'Email', onValidationChanged: (isValid) {  },
                  ),
                  EmailPasswordInput(
                    controller: _passwordController,
                    hintText: 'Password',
                    isPassword: true, onValidationChanged: (isValid) {  },
                  ),
                  const SizedBox(height: 10.0),
                  const TextField(
                    obscureText: true, // For password
                    decoration: InputDecoration(
                      hintText: 'Confirm Password',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  // ignore: sized_box_for_whitespace
                  Container(
                    width: 350,
                    height: 50,
                    child: OutlinedButton(
                      onPressed: () {
                        if (!state.isLoading) {
                          // Dispatch a RegisterUser event to the bloc
                          registrationBloc.add(RegisterUser(
                            email: _emailController.text,
                            password: _passwordController.text,
                          ));
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.blue),
                        textStyle: MaterialStateTextStyle.resolveWith(
                            (states) => const TextStyle(color: Colors.white)),
                      ),
                      child: state.isLoading
                          ? CircularProgressIndicator() // Show loading indicator
                          : const Text('Register'),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  // ignore: sized_box_for_whitespace
                  Container(
                    width: 350,
                    height: 50,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Login'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
