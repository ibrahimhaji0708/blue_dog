//import 'auth_bloc.dart';

class LoginState {
  final String email;
  final String password;
  final bool loggingIn;
  final String errMsg;
  final bool loggedIn;
  final bool isloading; 

  LoginState({
    this.email = '',
    this.password = '',
    this.loggingIn = false,
    this.errMsg = '',
    this.loggedIn = false,
    this.isloading = false, 
  });

  LoginState copyWith(
      {String? errMsg, String? email, String? password, bool? loggingIn, bool? loggedIn, bool? isloading}) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      loggingIn: loggingIn ?? this.loggingIn,
      errMsg: errMsg ?? this.errMsg,
      loggedIn: loggedIn ?? this.loggedIn,
      isloading: isloading ?? this.isloading,
    );
  }
}

class LoggingInState extends LoginState {}

class LoadingState extends LoginState {}

class LoggedInState extends LoginState {}

class ErrorState extends LoginState {
  final String error;

  ErrorState(this.error);
}