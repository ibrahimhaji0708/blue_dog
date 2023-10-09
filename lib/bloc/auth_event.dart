//import 'package:blue_dog/bloc/auth_state.dart';

abstract class LoginEvent {}

class EmailChanged extends LoginEvent {
  final String email;

  EmailChanged({required this.email});
}

class PasswordChanged extends LoginEvent {
  final String password;

  PasswordChanged({required this.password});
}

class LoginClicked extends LoginEvent {}

class CheckLogin extends LoginEvent {}

class LoginButtonPressed extends LoginEvent {}

class LoginErrorState extends LoginEvent {
  final String message;

  LoginErrorState(this.message);
}
