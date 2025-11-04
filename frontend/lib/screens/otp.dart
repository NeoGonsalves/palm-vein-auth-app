import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:zk_palmscanner_app/screens/wrapper.dart';

class OtpPage extends StatefulWidget {
  final String vid;
  final String phonenumber1;
  const OtpPage({super.key, required this.vid, required this.phonenumber1});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  String code = '';

  Future<void> signIn() async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: widget.vid,
      smsCode: code,
    );
    try {
      await FirebaseAuth.instance.signInWithCredential(credential);

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                'assets/animations/lock_tick.json',
                height: 150,
                fit: BoxFit.contain,
                frameRate: FrameRate.max, // Ensures maximum possible FPS
              ),
              const SizedBox(height: 16),
              const Text(
                "Verified Successfully!",
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      );

      await Future.delayed(const Duration(seconds: 2));
      Navigator.of(context).pop(); // Close dialog
      Get.offAll(() => const Wrapper());
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error', e.code);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 252, 245), // Off-white
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 60),
              const Text(
                'OTP Verification',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 5, 68, 4), // Dark green
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Enter OTP sent to +91 ${widget.phonenumber1}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.black54, fontSize: 14),
              ),
              const SizedBox(height: 40),
              buildOtpInput(),
              const SizedBox(height: 60),
              buildVerifyButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildOtpInput() {
    final defaultTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 20,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 232, 255, 232), // light green box
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color.fromARGB(255, 5, 68, 4),
        ), // dark green border
      ),
    );

    return Pinput(
      length: 6,
      defaultPinTheme: defaultTheme,
      focusedPinTheme: defaultTheme.copyWith(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 89, 212, 40), // light green
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(
          color: Colors.black,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      onChanged: (value) {
        setState(() => code = value);
      },
    );
  }

  Widget buildVerifyButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: signIn,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 5, 68, 4), // dark green
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: const Text(
          'Verify & Proceed',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
