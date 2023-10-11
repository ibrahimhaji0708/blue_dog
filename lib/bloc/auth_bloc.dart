// ignore_for_file: use_build_context_synchronously, curly_braces_in_flow_control_structures

import 'dart:convert';

import 'package:blue_dog/bloc/auth_event.dart';
import 'package:blue_dog/bloc/auth_state.dart';
import 'package:blue_dog/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase/supabase.dart';
import 'package:http/http.dart' as http;

class LoginPageAbc extends StatelessWidget {
  const LoginPageAbc({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(LoginState()),
      child: const LoginPage(),
    );
  }
}

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final supabase = SupabaseClient(
    'https://ydvzfbbrjpyccxoabdxz.supabase.co',
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InlkdnpmYmJyanB5Y2N4b2FiZHh6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTQ3ODAwMDQsImV4cCI6MjAxMDM1NjAwNH0.wkQE09ZoNK5PQBa89Pp17CYitzf6h_kp6O1fPFfCwO4',
  );
  LoginBloc(LoginState loginState) : super(LoginState()) {
    on<LoginButtonPressed>(_loginPressed);
    on<CheckLogin>(_checkLogin);
    on<PasswordChanged>(_passwordChanged);
    on<EmailChanged>(_emailChanged);
  }

  void _loginPressed(LoginButtonPressed event, Emitter<LoginState> emit) async {
    emit(state.copyWith(loggingIn: false));
    if ((state.email.isEmpty || state.password.isEmpty) && state.loggingIn) {
      emit(state.copyWith(
        errMsg: 'Plz fill in your details and try again',
      ));
    }

    if (state.loggingIn &&
        (state.email.length < 5 || !state.email.contains('@'))) {
      emit(state.copyWith(errMsg: 'Invalid email address'));
    }

    //if (state.loggingIn) {
    if ((state.password.length < 6 ||
            !state.password.contains(RegExp(r'[0-9]'))) &&
        state.loggingIn) {
      emit(state.copyWith(
        errMsg: 'Invalid password.',
      ));
    }
    //}

    // api call to sign-in
    final res = await http.post(
        Uri.parse('https://ydvzfbbrjpyccxoabdxz.supabase.co/auth/v1.signin'),
        body: {
          'email': state.email,
          'password': state.password,
        });
    if (res.statusCode == 200) {
      final user = json.decode(res.body)['user'];

      if (user != null && !state.loggingIn) {
        emit(state.copyWith(
          errMsg: null,
        ));
      } else {
        emit(state.copyWith(
          errMsg: 'Invalid details. plz register if u r a new user.',
        ));
      }
    }
  }

  void _checkLogin(CheckLogin event, Emitter<LoginState> emit) async {
    try {
      final userQuery = await supabase
          .from('users')
          .select()
          .eq('email', event); //.execute();

      if (userQuery == null || userQuery.isEmpty) {
        emit(state.copyWith(
            errMsg: 'No user found. Please register your details.'));
      } else {
        emit(
          state.copyWith(
            errMsg: 'You have successfully logged In.',
          ),
        );
      }
    } catch (e) {
      print('authentificaion faild: $e');
      emit(state.copyWith(
        errMsg: 'An error occurred during login.',
      ));
    }
  }

  void _passwordChanged(PasswordChanged event, Emitter<LoginState> emit) {
    emit(state.copyWith(password: event.password));
  }

  void _emailChanged(EmailChanged event, Emitter<LoginState> emit) {
    emit(state.copyWith(email: event.email));
  }
}
