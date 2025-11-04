import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'transactions_page.dart'; // Import the new screen

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  void signOut() async {
    await FirebaseAuth.instance.signOut();
    // Navigator.pushReplacement(...) to go to login screen if needed
  }

  void openTransactions() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TransactionsPage()),
    );
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

      // Floating Action Button for Transactions
      floatingActionButton: FloatingActionButton.extended(
        onPressed: openTransactions,
        icon: const Icon(Icons.receipt_long),
        label: const Text("Transactions"),
        backgroundColor: Colors.green.shade700,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
