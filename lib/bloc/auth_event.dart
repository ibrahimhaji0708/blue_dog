//import 'package:blue_dog/bloc/auth_state.dart';

class LoginEvent {}

class EmailChanged extends LoginEvent {
  final String email;

  EmailChanged({required this.email});
}

class PasswordChanged extends LoginEvent {
  final String password;

  PasswordChanged({required this.password});
}

class LoginButtonPressed extends LoginEvent {
  final bool loggingIn; 
  final bool loggedIn; 

  LoginButtonPressed({required this.loggingIn, required this.loggedIn});
}

class CheckLogin extends LoginEvent {}
