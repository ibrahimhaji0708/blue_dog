import 'package:blue_dog/email_password_input.dart';
import 'package:blue_dog/forgot_password.dart';
import 'package:blue_dog/home_screen.dart';
import 'package:blue_dog/register.dart';
import 'package:blue_dog/splash/splash_screen.dart';
import 'package:blue_dog/verification.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase/supabase.dart';

void main() {
  runApp(const BlueDog());
}

final supabase = SupabaseClient(
  'https://ydvzfbbrjpyccxoabdxz.supabase.co',
  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InlkdnpmYmJyanB5Y2N4b2FiZHh6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTQ3ODAwMDQsImV4cCI6MjAxMDM1NjAwNH0.wkQE09ZoNK5PQBa89Pp17CYitzf6h_kp6O1fPFfCwO4',
);
final TextEditingController _emailController = TextEditingController();
final TextEditingController _passwordController = TextEditingController();
bool _emailValid = false;
bool _passwordValid = false;
String? emailError;
String? passwordError;

Future<void> _saveLoginState(bool loggedIn) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('loggedIn', loggedIn);
}

Future<bool> _getLoginState() async {
  final prefs = await SharedPreferences.getInstance();
  final loggedIn = prefs.getBool('loggedIn');
  return loggedIn ?? false;
}

Future<void> _exitApp() async {
  await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
}

Future<void> _login(context) async {
  if (_emailValid && _passwordValid) {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    await Future.delayed(const Duration(seconds: 2));
    await _saveLoginState(true);

    if (email.isEmpty || password.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Email and password are required.'),
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
    } else if (password.length < 6 ||
        !email.contains('@') ||
        !email.contains('.com')) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Validation Error'),
            content: const Text('Please check email and password format.'),
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
      final userQuery =
          await supabase.from('users').select().eq('email', email);
      if (userQuery is List && userQuery.isEmpty) {
        // User not found.
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text('User not found.'),
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
      } else if (userQuery is List && userQuery.isNotEmpty) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const HomeScreen()));
      }
    }
  }
}

class BlueDog extends StatelessWidget {
  const BlueDog({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/verify': (context) => const VerificationScreen(),
      },
      debugShowCheckedModeBanner: false,
      title: 'Blue Dog',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 255, 255, 255),
        ),
        useMaterial3: true,
      ),
      //home: const LoginPage(),
      home: const SplashScreenRouter()
    );
  }
}

class SplashScreenRouter extends StatefulWidget {
  const SplashScreenRouter({super.key});

  @override
  State<SplashScreenRouter> createState() => _SplashScreenRouterState();
}

class _SplashScreenRouterState extends State<SplashScreenRouter> {
  bool _showLoginPage = false;

  @override
  void initState() {
    super.initState();
    _loadLoginPage();
  }

  Future<void> _loadLoginPage() async {
    await Future.delayed(const Duration(seconds: 2));
    //set the state to true 
    setState(() {
      _showLoginPage = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    //if check if showlogin page is true go to Loginpage() else don't change the state 
    if (_showLoginPage) {
      return const LoginPage();
    } else {
      return const SplashScreen();
    }
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();

    _getLoginState().then((loggedIn) {
      if (loggedIn) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const HomeScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        await _saveLoginState(true);
        await _exitApp();
        return true;
      },
      child: Scaffold(
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
                  controller: _emailController,
                  hintText: 'Email',
                  onValidationChanged: (isValid) {
                    setState(() {
                      _emailValid = isValid;
                    });
                  },
                ),
                EmailPasswordInput(
                  controller: _passwordController,
                  hintText: 'Password',
                  onValidationChanged: (isValid) {
                    setState(() {
                      _passwordValid = isValid;
                    });
                  },
                ),
                // IconButton(
                //   onPressed: () {
                //     setState(() {
                //       _obscurePassword = !_obscurePassword;
                //     });
                //   },
                //   icon: Icon(_obscurePassword
                //       ? Icons.visibility
                //       : Icons.visibility_off),
                // ),
                const SizedBox(height: 20),
                const SizedBox(height: 10.0),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const SendPasswordResetEmail(),
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
                      _login(context);
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
                          builder: (context) => const RegisterUser(),
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
      ),
    );
  }
}
