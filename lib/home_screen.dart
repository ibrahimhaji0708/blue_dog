import 'package:blue_dog/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _logOut(BuildContext context) async {
    // final prefs = await SharedPreferences.getInstance();
    // await prefs.remove('user_token');
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.logout();

    // Navigate back to the login page
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return PopScope(
      canPop: true,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('home page'),
          leading: Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
          ),
          actions: [
            if (authProvider.isLoggedIn)
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                _logOut(context);
              },
            ),
          ],
        ),
        drawer: const Drawer(
          child: Center(
            child: Text('hello there', textAlign: TextAlign.center),
          ),
        ),
        body: Container(
          // Add your home screen content here
        ),
      ),
    );
  }
}
