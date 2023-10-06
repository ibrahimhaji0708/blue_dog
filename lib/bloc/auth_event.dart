//import 'package:blue_dog/bloc/auth_state.dart';

class LoginEvent {
  final String email; 
  final String password;

  LoginEvent({required this.email, required this.password});
}

class EmailPasswordChanged extends LoginEvent {
  EmailPasswordChanged({required super.email, required super.password});
}

class LoginClicked extends LoginEvent {
  LoginClicked({required super.email, required super.password});
}

class CheckLogin extends LoginEvent {
  CheckLogin({required super.email, required super.password});
}