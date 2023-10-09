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

class LoginButtonPressed extends LoginEvent {}

class LoginClickedToVerifyAuth extends LoginEvent {}

class CheckLogin extends LoginEvent {}


class PerformLogin extends LoginEvent {}

class LoginErrorState extends LoginEvent {}

class ShowInvalidEmailDialog extends LoginEvent {
  final String message;

  ShowInvalidEmailDialog(this.message);
}

class ShowInvalidPasswordDialog extends LoginEvent {
  final String message;

  ShowInvalidPasswordDialog(this.message);
}

// Define more events for other dialogs if needed
