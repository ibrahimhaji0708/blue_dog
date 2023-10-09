//import 'package:flutter/material.dart';

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

// class LoggingInState extends LoginState {}

// class LoadingState extends LoginState {}

// class LoggedInState extends LoginState {
//   //final String message;

//   //LoggedInState(this.message);
// }

// class ErrorState extends LoginState {
//   // final String error;
//   // ErrorState(this.error);

//   void showErrorDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Error'),
//           content: const Text(
//               'You haven\'t registered yet. Please register your details and try logging in again.'), // Provide the error message here.
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // Close the dialog.
//               },
//               child: const Text('OK'),
//             ),
//           ],
//         );
//       },
//     );
//     showDialog(
//       context: context,
//       builder: (BuildContext context) => const AlertDialog(
//         title: Text('Validation Error'),
//         content: Text(
//             'Please correct the inputs'),
//       ),
//     );
//     showDialog(
//       context: context,
//       builder: (BuildContext context) => const AlertDialog(
//         title: Text('Validation Error'),
//         content: Text(
//             'Please correct the inputs'),
//       ),
//     );
//   }
// }
