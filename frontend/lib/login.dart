import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'otp.dart';
import 'package:pinput/pinput.dart';

class PhoneHome extends StatefulWidget {
  const PhoneHome({super.key});

  @override
  State<PhoneHome> createState() => _PhoneHomeState();
}

class _PhoneHomeState extends State<PhoneHome> {
  TextEditingController phonenumber = TextEditingController();

  sendcode() async {
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+91${phonenumber.text}',
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {
          print('FIREBASE ERROR:\nCode: ${e.code}\nMessage: ${e.message}');
          Get.snackbar('Verification Failed', '${e.code} — ${e.message}');
        },

        codeSent: (String vid, int? token) {
          Get.to(OtpPage(vid: vid, phonenumber1: phonenumber.text));
        },
        codeAutoRetrievalTimeout: (vid) {},
      );
    } catch (e) {
      if (Get.overlayContext != null) {
        Get.snackbar('Error has occurred', e.toString());
      } else {
        debugPrint('Snackbar error (no overlay): $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 100),
        children: [
          Center(
            child: Text(
              'Phone Login',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 30),
          phonetext(),
          const SizedBox(height: 30),
          button(),
        ],
      ),
    );
  }

  Widget button() {
    return Center(
      child: ElevatedButton(
        onPressed: sendcode,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromRGBO(206, 69, 233, 1),
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
        ),
        child: const Text(
          'GET OTP',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget phonetext() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Enter Phone Number',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Pinput(
            length: 10,
            controller: phonenumber,
            keyboardType: TextInputType.number,
            defaultPinTheme: PinTheme(
              width: 50,
              height: 56,
              textStyle: const TextStyle(fontSize: 20, color: Colors.black),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.deepPurple),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
