import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/blue_dog.png', height: 170, width: 170),
            const SizedBox(height: 16.0),
            const CircularProgressIndicator(), 
          ],
        ),
      ),
    );
  }
}
