//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

final supabase = SupabaseClient(
  'https://ydvzfbbrjpyccxoabdxz.supabase.co',
  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InlkdnpmYmJyanB5Y2N4b2FiZHh6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTQ3ODAwMDQsImV4cCI6MjAxMDM1NjAwNH0.wkQE09ZoNK5PQBa89Pp17CYitzf6h_kp6O1fPFfCwO4',
  
    // 'providers': ['google'],
    // 'google': {
    //   'clientId': 'your-google-client-id',
    //   'secret': 'your-google-client-secret',
    // },
  
);

class _VerificationScreenState extends State<VerificationScreen> {
  String verificationResult = ''; // To store the verification result

  @override
  void initState() {
    super.initState();
    final token = ModalRoute.of(context)!.settings.arguments as String;
    verifyToken(token);
  }

  Future<void> verifyToken(String token) async {
    final verificationResponse = await yourVerificationAPI(token);

    if (verificationResponse == 'success') {
      setState(() {
        verificationResult = 'Verification successful!';
      });
    } else {
      setState(() {
        verificationResult = 'Verification failed. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verification'),
      ),
      body: Center(
        child: Text(
          verificationResult,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

// Replace this function with your actual verification API call
Future<String> yourVerificationAPI(String token) async {
  // Simulate a delay to mimic an API call
  await Future.delayed(const Duration(seconds: 2));

  // Replace with your verification logic
  if (token == 'your_valid_token_here') {
    return 'success';
  } else {
    return 'failure';
  }
}
