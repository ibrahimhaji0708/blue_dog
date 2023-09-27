import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegistrationState {
  final bool isLoading;
  final bool isRegistered;

  RegistrationState({
    required this.isLoading,
    required this.isRegistered,
  });

  factory RegistrationState.initial() {
    return RegistrationState(isLoading: false, isRegistered: false);
  }

  RegistrationState copyWith({
    bool? isLoading,
    bool? isRegistered,
  }) {
    return RegistrationState(
      isLoading: isLoading ?? this.isLoading,
      isRegistered: isRegistered ?? this.isRegistered,
    );
  }
}

class RegisterUser extends StatefulWidget {
  const RegisterUser({Key? key}) : super(key: key);

  @override
  State<RegisterUser> createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {
  final supabase = SupabaseClient(
    'https://ydvzfbbrjpyccxoabdxz.supabase.co',
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InlkdnpmYmJyanB5Y2N4b2FiZHh6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTQ3ODAwMDQsImV4cCI6MjAxMDM1NjAwNH0.wkQE09ZoNK5PQBa89Pp17CYitzf6h_kp6O1fPFfCwO4',
  );

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;
  bool isRegistered = false;

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
                decoration: InputDecoration(
                  hintText: 'Email',
                  errorText: isRegistered || isLoading
                      ? null
                      : 'Please enter a valid email',
                ),
              ),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  hintText: 'Password',
                  errorText: isRegistered || isLoading
                      ? null
                      : 'Password must be at least 6 characters',
                ),
                obscureText: true,
              ),
              const SizedBox(height: 10.0),
              const TextField(
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Confirm Password',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20.0),
              Container(
                width: 350,
                height: 50,
                child: OutlinedButton(
                  onPressed: () async {
                    final email = _emailController.text;
                    final password = _passwordController.text;

                    setState(() {
                      isLoading = true;
                      isRegistered = false;
                    });

                    final response = await supabase.from('users').upsert([
                      {
                        'email': email,
                        'password': password,
                      },
                    ]);

                    if (response != null && response.error!.message.isNotEmpty) {
                      print('Error: ${response.error!.message}');
                      setState(() {
                        isLoading = false;
                      });
                    } else {
                      setState(() {
                        isLoading = false;
                        isRegistered = true;
                      });

                      showDialog(
                        context: context,
                        builder: (context) {
                          return const AlertDialog(
                            title: Text('Registered'),
                            content: Text('You are successfully registered.'),
                          );
                        },
                      );
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blue),
                    textStyle: MaterialStateTextStyle.resolveWith(
                        (states) => const TextStyle(color: Colors.white)),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator() // Show loading indicator
                      : const Text('Register'),
                ),
              ),
              const SizedBox(height: 10.0),
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
