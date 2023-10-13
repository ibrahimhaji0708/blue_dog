// ignore_for_file: use_build_context_synchronously

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
        create: (context) => LoginBloc(LoginState()), child: const LoginPage());
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
    emit(state.copyWith(loggingIn: true));
    if ((event.email.isEmpty && event.password.isEmpty)) {
      emit(state.copyWith(
        errMsg: 'Plz fill in your details and try again',
        loggingIn: false,
      ));
      return;
    }
    if ((event.email.length < 5 || !event.email.contains('@')) ||
        (event.password.length < 6 ||
            !event.password.contains(RegExp(r'[0-9]')))) {
      emit(state.copyWith(
        errMsg: 'Invalid email address or pasword.',
        loggingIn: false,
      ));
      return;
    }

    final res = await http.post(
        Uri.parse('https://ydvzfbbrjpyccxoabdxz.supabase.co/auth/v1.signin'),
        body: {
          'email': state.email,
          'password': state.password,
        }); 

    if (res.statusCode == 200 && res.request != null) {
      final user = json.decode(res.body)['user'];

      if (user != null) {
        emit(state.copyWith(
          loggedIn: true,
          loggingIn: false,
          errMsg: 'successfully loggedIn.',
        ));
        return;
      } else {
        emit(state.copyWith(
          loggingIn: false,
          errMsg: 'Invalid details. plz register if u r a new user.',
        ));
        return;
      }
    } else {
      emit(state.copyWith(
        errMsg: 'An error occurred during login.',
        loggingIn: false,
      ));
    }
  }

  void _checkLogin(CheckLogin event, Emitter<LoginState> emit) async {
    try {
      if (event.email.isEmpty || event.password.isEmpty) {
        emit(state.copyWith(
          loggingIn: false,
          errMsg: 'Plz fill in your details and try again',
        ));
        return;
      }
      final userQuery = await supabase
          .from('users')
          .select()
          .eq('email', event.email)
          .eq('password', event.password);

      if (userQuery != null && userQuery.data.isNotEmpty) {
        emit(state.copyWith(
          loggingIn: false,
          loggedIn: true,
        ));
        return;
      } else {
        emit(
          state.copyWith(
            loggingIn: true,
            errMsg: 'No user found. Please register your details.',
          ),
        );
      }
    } catch (e) {
      print('authentificaion faild: $e');
      emit(state.copyWith(
        errMsg: 'An error occurred during login.',
        loggingIn: false,
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
