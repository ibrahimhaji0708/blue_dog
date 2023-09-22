//import 'package:blue_dog/check_email.dart';
import 'package:blue_dog/check_email.dart';
import 'package:blue_dog/main.dart';
import 'package:flutter/material.dart';
//import 'package:supabase_flutter/supabase_flutter.dart';

class ForgotPassScreen extends StatefulWidget {
  const ForgotPassScreen({super.key});

  @override
  State<ForgotPassScreen> createState() => _ForgotPassScreenState();
}

class _ForgotPassScreenState extends State<ForgotPassScreen> {
  final TextEditingController _emailController = TextEditingController();

  //void _sendPasswordResetEmail() async {
  // await supabase.auth.resetPasswordForEmail(
  //     _emailController.text); //sendPasswordResetEmail(_emailController.text)

  void _sendPasswordResetEmail() async {
    final email = _emailController.text;
    try {
      await supabase.auth.resetPasswordForEmail(email);

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => CheckEmailScreen(email: email),
        ),
      );
    } catch (e) {
      print('Error sending password reset email: $e');
    }
  }

  //}

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
            //mainAxisAlignment: MainAxisAlignment.center,
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
                decoration: const InputDecoration(
                  hintText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 30.0),

              // ignore: sized_box_for_whitespace
              Container(
                width: 350,
                height: 50,
                child: OutlinedButton(
                  onPressed: _sendPasswordResetEmail,
                  // onPressed: () {
                  //   Navigator.of(context).push(MaterialPageRoute(
                  //       builder: () => const CheckEmailScreen()));
                  // },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blue),
                    textStyle: MaterialStateTextStyle.resolveWith(
                        (states) => const TextStyle(color: Colors.white)),
                    //side: MaterialStateProperty.all(const BorderSide(color: Colors.red)),
                  ),
                  child: const Text('Send Link'),
                ),
              ),
              const SizedBox(height: 30.0),
              // ignore: sized_box_for_whitespace
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
