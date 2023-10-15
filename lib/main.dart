import 'package:blue_dog/email_password_input.dart';
import 'package:blue_dog/forgot_password.dart';
import 'package:blue_dog/home_screen.dart';
import 'package:blue_dog/register.dart';
import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart';

void main() {
  runApp(const BlueDog());
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

Future<void> _login(context) async {
  final email = _emailController.text.trim();
  final password = _passwordController.text.trim();

  if (email.isEmpty || password.isEmpty) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: const Text('Email and password are required.'),
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
  } else if (!_isEmailValid(email) || password.length < 6) {
    // Handle email format and password length errors
    // Show a validation error dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Validation Error'),
          content: const Text('Please check email and password format.'),
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
    try {
      // Check if the user exists in Supabase
      final userQuery =await supabase.from('users').select().eq('email', email);

      if (userQuery.error != null) {
        print('Error querying user: ${userQuery.error!.message}');
      }
      else if (userQuery.data == null || userQuery.data.isEmpty) {
        // User doesn't exist
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Registration Required'),
              content: const Text('You haven\'t registered yet.'),
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
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const HomeScreen()));
                },
              ),
            ],
            title: const Text('You have been logged in successfully.'),
          ),
        );
      }
    } catch (e) {
      print("Error: $e");
    }
  }
}

bool _isEmailValid(String email) {
  final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
  return emailRegex.hasMatch(email);
}

class BlueDog extends StatelessWidget {
  const BlueDog({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Blue Dog',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 255, 255, 255),
        ),
        useMaterial3: true,
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
