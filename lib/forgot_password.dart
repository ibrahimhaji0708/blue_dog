// ignore_for_file: use_build_context_synchronously

import 'package:blue_dog/reset_password.dart';
import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart';

class SendPasswordResetEmail extends StatefulWidget {
  const SendPasswordResetEmail({Key? key}) : super(key: key);

  @override
  State<SendPasswordResetEmail> createState() => _SendPasswordResetEmailState();
}

void navigateToResetPassword(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => const ResetPassword(),
    ),
  );
}

class _SendPasswordResetEmailState extends State<SendPasswordResetEmail> {
  final supabase = SupabaseClient(
    'https://ydvzfbbrjpyccxoabdxz.supabase.co',
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InlkdnpmYmJyanB5Y2N4b2FiZHh6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTQ3ODAwMDQsImV4cCI6MjAxMDM1NjAwNH0.wkQE09ZoNK5PQBa89Pp17CYitzf6h_kp6O1fPFfCwO4',
  );

  final TextEditingController _emailController = TextEditingController();
  bool isLoading = false;
  bool isEmailSent = false;

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
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: 'Email',
                  errorText: isEmailSent || isLoading
                      ? null
                      : 'Please enter a valid email',
                ),
              ),
              const SizedBox(height: 30),
              Container(
                width: 350,
                height: 50,
                child: OutlinedButton(
                  onPressed: () async {
                    final email = _emailController.text;

                    setState(() {
                      isLoading = true;
                      isEmailSent = false;
                    });

                    try {
                      await supabase.auth.resetPasswordForEmail(email);

                      setState(() {
                        isLoading = false;
                        isEmailSent = true;
                      });

                      if (!isLoading && isEmailSent == true) {
                        navigateToResetPassword(context);
                      }

                      showDialog(
                        context: context,
                        builder: (context) {
                          return const AlertDialog(
                            title: Text('Email Sent'),
                            content:
                                Text('Password reset link sent successfully.'),
                          );
                        },
                      );
                    } catch (e) {
                      print('Error sending password reset email: $e');
                      setState(() {
                        isLoading = false;
                      });
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blue),
                    textStyle: MaterialStateTextStyle.resolveWith(
                        (states) => const TextStyle(color: Colors.white)),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator() // Show loading indicator
                      : const Text('Send Link'),
                ),
              ),
              const SizedBox(height: 30.0),
              Container(
                width: 350,
                height: 50,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Back'),
                ),
              ),
              const SizedBox(height: 10.0),
            ],
          ),
        ),
      ),
    );
  }
}
