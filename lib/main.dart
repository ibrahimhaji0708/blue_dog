import 'package:blue_dog/forgot_password.dart';
import 'package:blue_dog/email_password_input.dart';
import 'package:blue_dog/register.dart';
import 'package:blue_dog/verification.dart';
import 'package:flutter/material.dart';
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
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // final mainCubit = BlocProvider.of<MainCubit>(context);
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
              Image.asset(
                'assets/images/blue_dog.png',
                height: 150.0,
                width: 150.0,
              ),
              const SizedBox(height: 70.0),
              EmailPasswordInput(
                controller: _passwordController,
                hintText: 'Email',
                onValidationChanged: (isValid) {
                  bool emailValid = false;
                  setState(() {
                    emailValid = isValid;
                  });
                },
              ),
              EmailPasswordInput(
                controller: _emailController,
                hintText: 'Password',
                isPassword: true,
                onValidationChanged: (isValid) {
                  bool passwordValid = false;
                  setState(() {
                    passwordValid = isValid;
                  });
                },
              ),
              const SizedBox(height: 20),
              const SizedBox(height: 10.0),
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
              const SizedBox(height: 20.0),
              // ignore: sized_box_for_whitespace
              Container(
                width: 350,
                height: 50,
                child: OutlinedButton(
                  onPressed: () {
                    //_login(context);
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blue),
                    textStyle: MaterialStateTextStyle.resolveWith(
                      (states) => const TextStyle(color: Colors.white),
                    ),
                  ),
                  child: const Text('Login'),
                ),
              ),
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
