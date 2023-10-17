// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final supabase = SupabaseClient(
    'https://ydvzfbbrjpyccxoabdxz.supabase.co',
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InlkdnpmYmJyanB5Y2N4b2FiZHh6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTQ3ODAwMDQsImV4cCI6MjAxMDM1NjAwNH0.wkQE09ZoNK5PQBa89Pp17CYitzf6h_kp6O1fPFfCwO4',
  );
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool isLoading = false;
  bool isPasswordChanged = false;
  String? passwordErrorText;

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
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(height: 65.0),
              Image.asset(
                'assets/images/blue_dog.png',
                height: 150.0,
                width: 150.0,
              ),
              const SizedBox(height: 110.0),
              TextField(
                controller: _oldPasswordController,
                decoration: const InputDecoration(
                  hintText: 'Enter your Old Password',
                ),
              ),
              TextField(
                controller: _newPasswordController,
                decoration: InputDecoration(
                  hintText: 'Enter Your New Password',
                  errorText: passwordErrorText,
                ),
                obscureText: true,
              ),
              TextField(
                controller: _confirmPasswordController,
                decoration: const InputDecoration(
                  hintText: 'Confirm Your Password',
                ),
                obscureText: true,
              ),
              const SizedBox(height: 30),
              Container(
                width: 350,
                height: 50,
                child: OutlinedButton(
                  onPressed: () async {
                    final oldPassword = _oldPasswordController.text;
                    final newPassword = _newPasswordController.text;
                    final confirmPassword = _confirmPasswordController.text;
                    // final newPassword = _passwordController.text;
                    // const token = 'token_received_from_reset_email';

                    if (newPassword != confirmPassword) {
                      setState(() {
                        passwordErrorText =
                            "The passwords don't match. Please try again.";
                      });
                    } else if (newPassword.length < 6 ||
                        !newPassword.contains(RegExp(r'[0-9]'))) {
                      setState(() {
                        passwordErrorText = "Please enter a valid password.";
                      });
                    } else {
                      setState(() {
                        isLoading = true;
                      });

                      try {
                        await supabase.auth
                            .updateUser(UserAttributes(password: newPassword));

                        setState(() {
                          isLoading = false;
                          isPasswordChanged = true; 
                        });

                        showDialog(
                          context: context,
                          builder: (context) {
                            return const AlertDialog(
                              title: Text('Password Reset'),
                              content:
                                  Text('Password has been reset successfully.'),
                            );
                          },
                        );
                      } catch (e) {
                        print('Error updating password: $e');
                        setState(() {
                          isLoading = false;
                        });
                      }
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blue),
                    textStyle: MaterialStateTextStyle.resolveWith(
                        (states) => const TextStyle(color: Colors.white)),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator() // Show loading indicator
                      : const Text('Reset Password'),
                ),
                // ... Rest of your code
              ),
            ],
          ),
        ),
      ),
    );
  }
}
