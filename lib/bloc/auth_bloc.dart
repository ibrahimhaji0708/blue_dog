// ignore_for_file: use_build_context_synchronously, curly_braces_in_flow_control_structures

import 'package:blue_dog/bloc/auth_event.dart';
import 'package:blue_dog/bloc/auth_state.dart';
import 'package:blue_dog/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase/supabase.dart';

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
    emit(state.copyWith(loggingIn: true));
    if (event.loggingIn) {
      if (state.email.isEmpty ||
          state.password.isEmpty ||
          state.email.length < 5 ||
          (!state.email.contains('@') || !state.email.contains('.'))) {
        emit(state.copyWith(
          loggingIn: false,
          errMsg: 'Invalid email address.',
        ));
      }
      return;
    }

    if (event.loggingIn) {
      if (state.password.length < 6 ||
          !state.password.contains(RegExp(r'[0-9]'))) {
        emit(state.copyWith(
          loggingIn: false,
          errMsg: 'Invalid password.',
        ));
      }
      return; 
    }

    // api call to sign-in
    // if (event.loggingIn) {
    final res = await supabase.auth.signInWithPassword(
      email: state.email,
      password: state.password,
    );
    try {
      if (event.loggingIn) {
        if (res.user != null) {
          // 3rd
          emit(state.copyWith(
            loggedIn: true,
            loggingIn: false,
            errMsg: 'You have successfully logged in.',
          ));
        } else {
          if (event.loggedIn && state.loggingIn) {
            // 4th
            emit(state.copyWith(
                loggedIn: false,
                loggingIn: false,
                errMsg: 'Invalid details. plz register if u r a new user.'));
          }
        }
      }
    } catch (e) {
      print('no user found : $e');
    }
    return;
  }

  void _checkLogin(CheckLogin event, Emitter<LoginState> emit) async {
    try {
      final userQuery = await supabase
          .from('users')
          .select()
          .eq('email', event)
          .eq('password', event); //.execute();

      if (userQuery.data == null || userQuery.data.isEmpty) {
        // else in 5th
        emit(state.copyWith(
            loggingIn: false,
            loggedIn: false,
            errMsg: 'No user found. Please register your details.'));
      } else {
        if (state.loggedIn && state.loggingIn) {
          //5th
          // Handle the case when a user is found.
          emit(state.copyWith(
              loggedIn: true,
              loggingIn: false,
              errMsg: 'You have successfully logged In.'));
        }
      }
    } catch (e) {
      // Handle errors here, e.g., network errors or unexpected exceptions.
      print('authentificaion faild: $e');
      emit(state.copyWith(
        loggedIn: false,
        loggingIn: false,
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
