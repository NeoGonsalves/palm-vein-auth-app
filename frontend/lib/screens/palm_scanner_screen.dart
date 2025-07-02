import 'package:flutter/material.dart';
import '../palm_scanner.dart'; // This imports the MethodChannel wrapper

class PalmScannerScreen extends StatefulWidget {
  const PalmScannerScreen({super.key});

  @override
  State<PalmScannerScreen> createState() => _PalmScannerScreenState();
}

class _PalmScannerScreenState extends State<PalmScannerScreen> {
  String log = 'Tap the button to start palm scan';

  Future<void> _startScan() async {
    setState(() => log = '⏳ Starting palm scan...');

    final result = await PalmScanner.startScan(); // Native MethodChannel call

    setState(() => log = '✅ Response:\n$result');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Palm Scanner')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _startScan,
              child: const Text('Start Palm Scan'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    log,
                    style: const TextStyle(
                      color: Colors.greenAccent,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
