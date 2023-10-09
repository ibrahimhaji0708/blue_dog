//import 'package:blue_dog/bloc/auth_state.dart';

class LoginEvent {
  
}

class EmailChanged extends LoginEvent {
  final String email;

  EmailChanged({required this.email});
}

class PasswordChanged extends LoginEvent {
  final String password;

  PasswordChanged({required this.password});
}

class LoginClicked extends LoginEvent {
  
}

class CheckLogin extends LoginEvent {
  
}

class LoginButtonPressed extends LoginEvent {
  final String email;
  final String password;

  LoginButtonPressed(this.email, this.password);
}
