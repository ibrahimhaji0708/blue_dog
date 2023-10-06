// ignore_for_file: use_build_context_synchronously

import 'package:blue_dog/bloc/auth_event.dart';
import 'package:blue_dog/bloc/auth_state.dart';
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
  String? emailError;
  String? passwordError;
  //
  LoginBloc(LoginState loginState) : super(LoginState());
  //
  Stream<LoginState> mapEventToState(LoginEvent event, BuildContext context) async* {
    // ignore: void_checks
    on<LoginButtonPressed>((event, emit) async* {
      // yield LoadingState();
      // await Future.delayed(const Duration(seconds: 2));

      // Future<void> login() async* {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      // Check if the user exists in Supabase
      final userQuery = await supabase
          .from('users')
          .select()
          .eq('email', email)
          .execute(); //.execute() if the login doesn't work

      if (userQuery.data == null || userQuery.data.isEmpty) {
        yield ErrorState();
      } else {
        // User exists, perform login

        // Perform email validation
        if (email.isEmpty || !email.contains('@') || !email.contains('.com')) {
          emailError = 'Invalid email address';
        } else {
          emailError = null;
        }

        if (password.length < 6) {
          passwordError = 'Password must be at least 6 characters long';
        } else {
          passwordError = null;
        }

        if (emailError == null && passwordError == null) {
          if (password.length < 6) {
            passwordError = 'Password must be at least 6 characters long';
            yield ErrorState();
          } else {
            yield LoggedInState();
          }
        } else {
          yield ErrorState();
        }
      }
      //}
    });
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
      child: const LoginPage(),
    );
  }
}

class LoginWidgets extends StatelessWidget {
  const LoginWidgets({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      //listenWhen: (previous, current) => previous.loggedIn != current.loggedIn,
      listener: (context, state) {
        // if (state.loggedIn) {
        //   Navigator.pushNamed(context, '/home');
        // } else {
        //   Navigator.pushNamed(context, '/login');
        // }
      },
      child: const LoginPage(),
    );
  }
}
