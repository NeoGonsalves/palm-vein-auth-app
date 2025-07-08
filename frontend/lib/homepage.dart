import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  void signOut() async {
    await FirebaseAuth.instance.signOut();
    // Optionally: Navigator.pushReplacement(...) to go to login screen
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Homepage'),
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: signOut),
        ],
      ),
      body: Center(
        child: Text(
          user != null ? 'Logged in as ${user.phoneNumber}' : 'No user found',
        ),
      ),
    );
  }
}
