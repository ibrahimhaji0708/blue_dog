import 'package:blue_dog/main.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const BlueDog()));
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
    );
  }
}
