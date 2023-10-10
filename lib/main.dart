import 'package:blue_dog/bloc/auth_bloc.dart';
import 'package:blue_dog/bloc/auth_event.dart';
import 'package:blue_dog/bloc/auth_state.dart';
import 'package:blue_dog/email_password_input.dart';
import 'package:blue_dog/forgot_password.dart';
import 'package:blue_dog/home_screen.dart';
import 'package:blue_dog/register.dart';
import 'package:blue_dog/verification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() {
  runApp(const BlueDog());
  GoogleSignIn().onCurrentUserChanged.listen((GoogleSignInAccount? account) {
    // Handle the signed-in user (or null if no user is signed in)
  });
}

class BlueDog extends StatelessWidget {
  const BlueDog({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/verify': (context) => const VerificationScreen(),
      },
      debugShowCheckedModeBanner: false,
      title: 'Blue Dog',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 255, 255, 255),
        ),
      ),
      home: BlocProvider(
        create: (context) => LoginBloc(LoginState()),
        child: const LoginPage(),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final loginBloc = LoginBloc(LoginState());
  // final mainCubit = BlocProvider.of<MainCubit>(context);
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool emailValid = false;
  bool passwordValid = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BLUE DOG'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 63.0),
              //Image logo
              Image.asset(
                'assets/images/blue_dog.png',
                height: 150.0,
                width: 150.0,
              ),
              const SizedBox(height: 70.0),
              // error text in both the textfields
              EmailPasswordInput(
                controller: _emailController,
                hintText: 'Email',
                onValidationChanged: (isValid) {
                  emailValid = isValid;
                  BlocProvider.of<LoginBloc>(context)
                      .add(EmailChanged(email: ''));
                },
              ),
              const SizedBox(height: 5),
              EmailPasswordInput(
                controller: _passwordController,
                hintText: 'Password',
                isPassword: true,
                onValidationChanged: (isValid) {
                  passwordValid = isValid;
                  BlocProvider.of<LoginBloc>(context)
                      .add(PasswordChanged(password: ''));
                },
              ),
              const SizedBox(height: 20),
              //
              const SizedBox(height: 10.0),
              //forgot password button
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SendPasswordResetEmail(),
                    ),
                  );
                },
                child: const Text('FORGOT PASSWORD'),
              ),
              // login button
              const SizedBox(height: 20.0),
              // ignore: sized_box_for_whitespace
              Container(
                width: 350,
                height: 50,
                child: BlocBuilder<LoginBloc, LoginState>(
                  builder: (context, state) {
                    return OutlinedButton(
                      onPressed: () {
                        BlocProvider.of<LoginBloc>(context)
                            .add(LoginButtonPressed());
                        BlocProvider.of<LoginBloc>(context).add(CheckLogin());
                        //BlocProvider.of<LoginBloc>(context).add(ShowInvalidPasswordDialog('hello') as LoginEvent);
                        //BlocProvider.of<LoginBloc>(context).add(ShowInvalidEmailDialog('hello') as LoginEvent);
                        //BlocProvider.of<LoginBloc>(context).add(ShowEmptyFieldsDialog('etc') as LoginEvent);
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.blue),
                        textStyle: MaterialStateTextStyle.resolveWith(
                          (states) => const TextStyle(color: Colors.white),
                        ),
                      ),
                      child: const Text('Login'),
                    );
                  },
                ),
              ),
              //register button
              const SizedBox(height: 10.0),
              // ignore: sized_box_for_whitespace
              Container(
                width: 350,
                height: 50,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const RegisterUser(),
                      ),
                    );
                  },
                  child: const Text('Register'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginWIdgets extends StatelessWidget {
  const LoginWIdgets({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is ShowInvalidEmailDialog) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Error'),
                content: Text(state.message),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        } else if (state is ShowInvalidPasswordDialog) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Error'),
                content: Text(state.message),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        } else if (state is ShowEmptyFieldsDialog) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Error'),
                content: Text(state.message),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        } else {
          (state is LoggedInState);
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const HomeScreen()));
        }
        //const LoginPage();
      },
      child: const LoginPage(),
    );
  }
}
