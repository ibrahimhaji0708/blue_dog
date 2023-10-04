import 'package:blue_dog/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
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

Future<void> _handleGoogleSignIn() async {
  try {
    final GoogleSignInAccount? googleUser =
        await GoogleSignIn().signIn(); // Perform Google Sign-In

    if (googleUser == null) {
      print('Google Sign-In canceled or failed.');
    } else {
      print('Google Sign-In successful!');
      print('User ID: ${googleUser.id}');
      print('User Display Name: ${googleUser.displayName}');
      print('User Email: ${googleUser.email}');
    }
  } catch (error) {
    // Handle sign-in errors
    print(error);
  }
}

final supabase = SupabaseClient(
  'https://ydvzfbbrjpyccxoabdxz.supabase.co',
  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InlkdnpmYmJyanB5Y2N4b2FiZHh6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTQ3ODAwMDQsImV4cCI6MjAxMDM1NjAwNH0.wkQE09ZoNK5PQBa89Pp17CYitzf6h_kp6O1fPFfCwO4',
);

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
              const SizedBox(height: 50.0),
              //const SizedBox(height: 40.0),
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
              //const SizedBox(height: 20.0),
              const SizedBox(height: 10),
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

                    if (response != null &&
                        response.error!.message.isNotEmpty) {
                      print('Error: ${response.error!.message}');
                      setState(() {
                        isLoading = false;
                      });
                    } else {
                      setState(() {
                        isLoading = false;
                        isRegistered = true;
                      });

                      // ignore: use_build_context_synchronously
                      showDialog(
                        context: context,
                        builder: (context) {
                          return  AlertDialog(
                            title: const Text('Registered'),
                            content: const Text('You are successfully registered.'),
                            actions: [
                              TextButton(onPressed: Navigator.of(context).pop(), child: const Text('Ok'))
                              //Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HomeScreen()))
                            ],
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
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () async {
                  await _handleGoogleSignIn();
                  final response = await supabase.auth.signInWithOAuth(
                    Provider.google,
                    redirectTo:
                        'https://ydvzfbbrjpyccxoabdxz.supabase.co/auth/v1/callback',
                    //'381200983373-96u7a9n6h7d4hfppq041d9jr8skkbk04.apps.googleusercontent.com',
                  );
                  if (response) {
                    // ignore: use_build_context_synchronously
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('You have been signed up!'),
                          content: const Text(
                              'You have been signed up using your google account.'),
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
                    // Navigator.of(context).push(MaterialPageRoute(
                    //     builder: (context) => const HomeScreen()));
                  } else {
                    // Handle sign-up error
                    // ignore: use_build_context_synchronously
                    showDialog(
                      context: context,
                      builder: (context) {
                        return const AlertDialog(
                          title: Text('Error'),
                          content: Text('You have an error on google signin'),
                        );
                      },
                    );
                  }
                },
                icon: const Icon(Icons.g_translate),
                label: const Text('Sign Up with Google'),
              ),
              const SizedBox(height: 10.0), // Add some spacing
              ElevatedButton.icon(
                onPressed: () async {
                  final response = await supabase.auth.signInWithOAuth(
                    Provider.github,
                    redirectTo:
                        'https://ydvzfbbrjpyccxoabdxz.supabase.co/auth/v1/callback',
                  );

                  if (response) {
                    // ignore: use_build_context_synchronously
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('You have been signed up!'),
                          content: const Text(
                              'You have been signed up using your github account.'),
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
                    // Handle sign-up error
                    // ignore: use_build_context_synchronously
                    showDialog(
                      context: context,
                      builder: (context) {
                        return const AlertDialog(
                          title: Text('Error'),
                          content: Text('You have an error on github signin.'),
                        );
                      },
                    );
                  }
                },
                icon: const Icon(Icons.gite),
                label: const Text('Sign Up with GitHub'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
