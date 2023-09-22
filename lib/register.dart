//import 'package:blue_dog/main.dart';
import 'package:blue_dog/check_email.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({
    super.key,
  });

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> createUser() async {
    final supabase = SupabaseClient(
      'https://ydvzfbbrjpyccxoabdxz.supabase.co',
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InlkdnpmYmJyanB5Y2N4b2FiZHh6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTQ3ODAwMDQsImV4cCI6MjAxMDM1NjAwNH0.wkQE09ZoNK5PQBa89Pp17CYitzf6h_kp6O1fPFfCwO4',
    );

    final email = _emailController.text;
    final password = _passwordController.text;

    final response = await supabase.from('users').upsert([
      {
        'email': email,
        'password': password,
      },
    ]);

    if (response != null && response.error != null) {
      print('Error: ${response.error!.message}');
    }

    if (response != null && response.error == null) {
      // Navigate to CheckEmailScreen and pass the registered email
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => CheckEmailScreen(email: email),
        ),
      );
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
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  hintText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10.0),
              TextField(
                controller: _passwordController,
                obscureText: true, // For password
                decoration: const InputDecoration(
                  hintText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10.0),
              const TextField(
                obscureText: true, // For password
                decoration: InputDecoration(
                  hintText: 'Confirm Password',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20.0),
              // ignore: sized_box_for_whitespace
              Container(
                width: 350,
                height: 50,
                child: OutlinedButton(
                  onPressed: createUser,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blue),
                    textStyle: MaterialStateTextStyle.resolveWith(
                        (states) => const TextStyle(color: Colors.white)),
                    //side: MaterialStateProperty.all(const BorderSide(color: Colors.red)),
                  ),
                  child: const Text('Register'),
                ),
              ),
              const SizedBox(height: 10.0),
              // ignore: sized_box_for_whitespace
              Container(
                width: 350,
                height: 50,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Login'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
