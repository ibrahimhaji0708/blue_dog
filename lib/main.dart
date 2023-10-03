import 'package:blue_dog/forgot_password.dart';
import 'package:blue_dog/email_password_input.dart';
import 'package:blue_dog/register.dart';
//import 'package:blue_dog/';
import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart';
//import 'package:firebase_auth/firebase_auth.dart';

void main() {
  runApp(const BlueDog());
  GoogleSignIn().onCurrentUserChanged.listen((GoogleSignInAccount? account) {
    // Handle the signed-in user (or null if no user is signed in)
  });
}

final supabase = SupabaseClient(
  'https://ydvzfbbrjpyccxoabdxz.supabase.co',
  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InlkdnpmYmJyanB5Y2N4b2FiZHh6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTQ3ODAwMDQsImV4cCI6MjAxMDM1NjAwNH0.wkQE09ZoNK5PQBa89Pp17CYitzf6h_kp6O1fPFfCwO4',
);

final TextEditingController _emailController = TextEditingController();
final TextEditingController _passwordController = TextEditingController();
bool _emailValid = false;
bool _passwordValid = false;
String? emailError;
String? passwordError;

Future<void> _handleSignIn() async {
  try {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    // Now you can use googleUser to access user information.
  } catch (error) {
    // Handle sign-in errors
    print(error);
  }
}


Future<void> _login(context) async {
  if (_emailValid && _passwordValid) {
    //var supabaseClient;
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    await Future.delayed(const Duration(seconds: 2));

    // Check if the user exists in Supabase
    final userQuery =
        await supabase.from('users').select().eq('email', email).execute();

    if (userQuery.data == null || userQuery.data.isEmpty) {
      // User doesn't exist, show a message to register
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Registration Required'),
            content: const Text(
                'You haven\'t registered yet. Please register your details and try logging in again.'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      // User exists, perform login
      // showDialog(
      //   context: context,
      //   builder: (BuildContext context) {
      //     return AlertDialog(
      //       title: const Text('User has been Logged In'),
      //       content: const Text(''),
      //       actions: <Widget>[
      //         TextButton(
      //           child: const Text('OK'),
      //           onPressed: () {
      //             Navigator.of(context).pop();
      //           },
      //         ),
      //       ],
      //     );
      //   },
      // );
    }

    // Perform email validation
    if (email.isEmpty || !email.contains('@') || !email.contains('.com')) {
      emailError = 'Invalid email address';
    } else {
      emailError = null;
    }

    // Perform password validation
    if (password.length < 2 /*|| !password.contains(RegExp(r'[0-9]'))*/) {
      passwordError =
          'Password must be at least 6 characters and contain numbers';
    } else {
      passwordError = null;
    }

    if (emailError == null && passwordError == null) {
      if (password.length < 6) {
        passwordError = 'Password must be at least 6 characters long';
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Validation Error'),
            content: Text('Please correct the following errors:\n\n' +
                (emailError != null ? '- $emailError\n' : '') +
                (passwordError != null ? '- $passwordError\n' : '')),
          ),
        );
      } else {
        // Attempt login
        showDialog(
          context: context,
          builder: (context) => const AlertDialog(
            title: Text('U have been logged in successfully '),
          ),
        );
      }
    }
  } else {
    // Display error message for invalid email or password
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Validation Error'),
        content: Text('Please correct the following errors:\n\n' +
            (emailError != null ? '- $emailError\n' : '') +
            (passwordError != null ? '- $passwordError\n' : '')),
      ),
    );
  }
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
                controller: _emailController,
                hintText: 'Email',
                onValidationChanged: (isValid) {
                  setState(() {
                    _emailValid = isValid;
                  });
                },
              ),
              EmailPasswordInput(
                controller: _passwordController,
                hintText: 'Password',
                isPassword: true,
                onValidationChanged: (isValid) {
                  setState(() {
                    _passwordValid = isValid;
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
                    _login(context);
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
