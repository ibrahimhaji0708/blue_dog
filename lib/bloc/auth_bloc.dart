import 'package:blue_dog/bloc/auth_event.dart';
import 'package:blue_dog/bloc/auth_state.dart';
import 'package:blue_dog/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';

import 'package:supabase/supabase.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final supabase = SupabaseClient(
    'https://ydvzfbbrjpyccxoabdxz.supabase.co',
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InlkdnpmYmJyanB5Y2N4b2FiZHh6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTQ3ODAwMDQsImV4cCI6MjAxMDM1NjAwNH0.wkQE09ZoNK5PQBa89Pp17CYitzf6h_kp6O1fPFfCwO4',
  );
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final bool _emailValid = false;
  final bool _passwordValid = false;
  String? emailError;
  String? passwordError;
  LoginBloc(LoginState loginState) : super(LoginState());
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginState) {
      yield LoadingState();

      await Future.delayed(const Duration(seconds: 2));

      try {
        if (event.email == 'test@example.com' && event.password == 'password') {
          yield LoggedInState();
        } else {
          yield ErrorState('Invalid email or password');
        }
      } catch (e) {
        yield ErrorState('An error occurred: $e');
      }

      Future<void> _login(context)async {
        if (_emailValid && _passwordValid) {
          //var supabaseClient;
          final email = _emailController.text.trim();
          final password = _passwordController.text.trim();

          await Future.delayed(const Duration(seconds: 2));

          // Check if the user exists in Supabase
          final userQuery = await supabase
              .from('users')
              .select()
              .eq('email', email)
              .execute();

          if (userQuery.data == null || userQuery.data.isEmpty) {
            // User doesn't exist, show a message to register
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Registration Required'),
                  content: const Text(
                      'You haven\'t registered yet. Please register your details and try logging in again.'),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          } else {
            // User exists, perform login
            // showDialog(
            //   context: context,
            //   builder: (BuildContext context) {
            //     return AlertDialog(
            //       title: const Text('User has been Logged In'),
            //       content: const Text(''),
            //       actions: <Widget>[
            //         TextButton(
            //           child: const Text('OK'),
            //           onPressed: () {
            //             Navigator.of(context).pop();
            //           },
            //         ),
            //       ],
            //     );
            //   },
            // );
          }

          // Perform email validation
          if (email.isEmpty ||
              !email.contains('@') ||
              !email.contains('.com')) {
            emailError = 'Invalid email address';
          } else {
            emailError = null;
          }

          // Perform password validation
          if (password.length < 2 /*|| !password.contains(RegExp(r'[0-9]'))*/) {
            passwordError =
                'Password must be at least 6 characters and contain numbers';
          } else {
            passwordError = null;
          }

          if (emailError == null && passwordError == null) {
            if (password.length < 6) {
              passwordError = 'Password must be at least 6 characters long';
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Validation Error'),
                  content: Text('Please correct the following errors:\n\n' +
                      (emailError != null ? '- $emailError\n' : '') +
                      (passwordError != null ? '- $passwordError\n' : '')),
                ),
              );
            } else {
              // Attempt login
              showDialog(
                context: context,
                builder: (context) => const AlertDialog(
                  title: Text('U have been logged in successfully '),
                ),
              );
            }
          }
        } else {
          // Display error message for invalid email or password
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Validation Error'),
              content: Text('Please correct the following errors:\n\n' +
                  (emailError != null ? '- $emailError\n' : '') +
                  (passwordError != null ? '- $passwordError\n' : '')),
            ),
          );
        }
      }
    }
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(
        LoginState(),
      ),
      child: const BlueDog(),
    );
  }
}

class LoginWidgets extends StatelessWidget {
  const LoginWidgets({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listenWhen: (previous, current) => previous.loggedIn != current.loggedIn,
      listener: (context, state) {
        if (state.loggedIn) {
          Navigator.pushNamed(context, '/home');
        } else {
          Navigator.pushNamed(context, '/login');
        }
      },
      child: const LoginPage(),
    );
  }
}
