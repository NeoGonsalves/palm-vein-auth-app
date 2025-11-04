import 'package:flutter/material.dart';

class TransactionsPage extends StatelessWidget {
  const TransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock transaction data
    final transactions = [
      {"title": "Coffee Shop", "amount": "-₹120"},
      {"title": "UPI Received", "amount": "+₹500"},
      {"title": "Recharge", "amount": "-₹249"},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Recent Transactions")),
      body: ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final txn = transactions[index];
          return ListTile(
            leading: const Icon(Icons.payment),
            title: Text(txn["title"]!),
            trailing: Text(
              txn["amount"]!,
              style: TextStyle(
                color: txn["amount"]!.contains('-') ? Colors.red : Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        },
      ),
    );
  }
}
