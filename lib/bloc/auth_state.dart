class LoginState {
  final String email;
  final String password;
  final bool loggingIn;
  final String errMsg;
  final bool loggedIn;

  LoginState({
    this.email = '',
    this.password = '',
    this.loggingIn = false,
    this.errMsg = '',
    this.loggedIn = false,
  });

  LoginState copyWith(
      {String? errMsg, String? email, String? password, bool? loggingIn, bool? loggedIn}) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      loggingIn: loggingIn ?? this.loggingIn, 
      errMsg: errMsg ?? this.errMsg, 
      loggedIn: loggedIn ?? this.loggedIn, 
    );
  }
}