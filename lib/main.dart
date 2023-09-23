import 'package:blue_dog/forgot_password.dart';
import 'package:blue_dog/email_password_input.dart';
import 'package:blue_dog/register.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase/supabase.dart';

import 'bloc/main_bloc.dart';

void main() {
  runApp(const BlueDog());
}

final supabase = SupabaseClient(
  'https://ydvzfbbrjpyccxoabdxz.supabase.co',
  'YOUR_SUPABASE_API_KEY',
);

class BlueDog extends StatelessWidget {
  const BlueDog({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MainBloc(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Blue Dog',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 255, 255, 255),
          ),
          useMaterial3: true,
        ),
        home: const LoginPage(),
      ),
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final mainBloc = BlocProvider.of<MainBloc>(context);

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
                controller: TextEditingController(text: mainBloc.state.email),
                hintText: 'Email',
                onValidationChanged: (isValid) {
                  mainBloc.add(EmailChanged(mainBloc.state.email));
                },
              ),
              EmailPasswordInput(
                controller: TextEditingController(text: mainBloc.state.password),
                hintText: 'Password',
                isPassword: true,
                onValidationChanged: (isValid) {
                  mainBloc.add(PasswordChanged(mainBloc.state.password));
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
                    // Dispatch a login event to MainBloc
                    mainBloc.add(const LoginPage() as MainEvent);
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
