import 'package:blue_dog/forgot_password.dart';
import 'package:blue_dog/logic/email_password_input.dart';
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
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _emailValid = false;
  bool _passwordValid = false;

  Future<void> _login() async {
    if (_emailValid && _passwordValid) {
      //var supabaseClient;
      final email = _emailController.text;
      final password = _passwordController.text;

      await Future.delayed(const Duration(seconds: 60)); // Adjust the duration as needed

      //BuildContext currentContext = context;

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
        final response = await supabase.auth.signUp(
          email: email,
          password: password,
        );

        if (response.user == null) {
          // Successfully logged in
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Logged In'),
                content: const Text('You have been logged in.'),
                actions: <Widget>[
                  TextButton(
                    child: const Text('OK'),
                    onPressed: () {
                      _login();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        } else {
          // Handle login error
          print('Login error: ${response.user!.email}');
          // Display an error message to the user if needed
        }
      }
    }
  }

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
                      builder: (context) => const ForgotPassScreen(),
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
                    _login();
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
                        builder: (context) => const RegisterScreen(),
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
