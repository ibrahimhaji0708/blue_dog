// ignore_for_file: use_build_context_synchronously

import 'package:blue_dog/bloc/auth_event.dart';
import 'package:blue_dog/bloc/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase/supabase.dart';

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

  void _loginPressed(
      LoginButtonPressed event, Emitter<LoginState> emit) async {
    emit(state.copyWith(loggingIn: true));
    if (state.email.isEmpty || state.email.length < 5) {
      emit(state.copyWith(
          loggingIn: false,
          errMsg: 'ur email has to be more than 5 chars long..'));
      return;
    }

    if (state.password.length < 6) {
      emit(state.copyWith(
          loggingIn: false,
          errMsg: 'Password must be at least 6 characters long'));
      return;
    }

    if (!state.email.contains('@') || !state.email.contains('.com')) {
      emit(state.copyWith(errMsg: 'Error in EMail', loggingIn: false));
      return;
    }

    final res = await supabase.auth.signInWithPassword(
      email: state.email,
      password: state.password,
    );
    if (res.user == null) {
      emit(state.copyWith(
          errMsg: 'login failed plz try again..', loggingIn: false));
      return;
    }

    emit(state.copyWith(loggedIn: true, loggingIn: false));
  }

  void _checkLogin(CheckLogin event, Emitter<LoginState> emit) async {
    final userQuery = await supabase.from('users').select().eq('email', event);
    // .execute(); //.execute() if the login doesn't work

    if (userQuery.data == null || userQuery.data.isEmpty) {
      emit(state.copyWith(errMsg: 'null'));
    }
  }

  void _passwordChanged(PasswordChanged event, Emitter<LoginState> emit) {
    emit(state.copyWith(password: event.password));
  }

  void _emailChanged(EmailChanged event, Emitter<LoginState> emit) {
    emit(state.copyWith(email: event.email));
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
