import 'package:flutter_bloc/flutter_bloc.dart';

class MainEvent {}

class EmailChanged extends MainEvent {
  final String email;

  EmailChanged(this.email);
}

class PasswordChanged extends MainEvent {
  final String password;

  PasswordChanged(this.password);
}

class MainState {
  final String email;
  final String password;
  final bool isEmailValid;
  final bool isPasswordValid;

  MainState({
    required this.email,
    required this.password,
    required this.isEmailValid,
    required this.isPasswordValid,
  });

  // Define a copyWith method to create a new instance with modified values.
  MainState copyWith({
    String? email,
    String? password,
    bool? isEmailValid,
    bool? isPasswordValid,
  }) {
    return MainState(
      email: email ?? this.email,
      password: password ?? this.password,
      isEmailValid: isEmailValid ?? this.isEmailValid,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
    );
  }
}

class MainBloc extends Bloc<MainEvent, MainState> {
  MainBloc() : super(MainState(email: '', password: '', isEmailValid: false, isPasswordValid: false));

  Stream<MainState> mapEventToState(MainEvent event) async* {
    if (event is EmailChanged) {
      // Handle email validation and update state
      final isEmailValid = event.email.contains('@') && event.email.contains('.');
      yield state.copyWith(email: event.email, isEmailValid: isEmailValid);
    } else if (event is PasswordChanged) {
      // Handle password validation and update state
      final isPasswordValid = event.password.length >= 6 &&
          RegExp(r'[!@#$%^&*(),.?":{}|<>0-9]').hasMatch(event.password);
      yield state.copyWith(password: event.password, isPasswordValid: isPasswordValid);
    }
  }
}
