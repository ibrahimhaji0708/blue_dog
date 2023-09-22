import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart';

class CheckEmailScreen extends StatelessWidget {
  CheckEmailScreen({super.key, this.email});

  final String? email;
  final supabase = SupabaseClient(
    'https://ydvzfbbrjpyccxoabdxz.supabase.co',
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InlkdnpmYmJyanB5Y2N4b2FiZHh6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTQ3ODAwMDQsImV4cCI6MjAxMDM1NjAwNH0.wkQE09ZoNK5PQBa89Pp17CYitzf6h_kp6O1fPFfCwO4',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BLUE DOG'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const Center(
              child: Text('A Verification link has been sent to:'),
            ),
            const SizedBox(height: 6),
            Center(
              child: Text(email!),
            ),
            const SizedBox(height: 50),
            Image.asset(
              'assets/images/check_pass.png',
              height: 150.0,
              width: 150.0,
            ),
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                //var supabaseClient;
                //final response = await supabaseClient.auth.signOut();
                //if (response.error == null) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Logged Out'),
                      content: const Text('You have been logged out.'),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('OK'),
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
