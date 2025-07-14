import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'otp.dart';

class PhoneHome extends StatefulWidget {
  const PhoneHome({super.key});

  @override
  State<PhoneHome> createState() => _PhoneHomeState();
}

class _PhoneHomeState extends State<PhoneHome> {
  TextEditingController phonenumber = TextEditingController();
  bool agreed = true;
  bool isLoading = false;

  sendcode() async {
    if (!agreed) {
      Get.snackbar(
        'Consent Required',
        'Please agree to Terms & Privacy Policy',
      );
      return;
    }

    if (phonenumber.text.length != 10 ||
        !RegExp(r'^[0-9]+$').hasMatch(phonenumber.text)) {
      Get.snackbar(
        'Invalid Number',
        'Please enter a valid 10-digit phone number',
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+91${phonenumber.text}',
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance.signInWithCredential(credential);
          Get.snackbar('Success', 'Phone number automatically verified');
        },
        verificationFailed: (FirebaseAuthException e) {
          Get.snackbar('Verification Failed', '${e.code} — ${e.message}');
        },
        codeSent: (String vid, int? token) {
          Get.to(OtpPage(vid: vid, phonenumber1: phonenumber.text));
        },
        codeAutoRetrievalTimeout: (vid) {},
      );
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9), // Off-white background
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Row(
                children: const [
                  Icon(
                    Icons.fingerprint,
                    size: 32,
                    color: Color(0xFF1B5E20), // Dark green
                  ),
                  SizedBox(width: 10),
                  Text(
                    'BioPay',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1B5E20),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'UPI • Palm Authentication',
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 40),
              const Text(
                'Enter mobile number',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: phonenumber,
                keyboardType: TextInputType.phone,
                maxLength: 10,
                decoration: InputDecoration(
                  prefixText: '+91 ',
                  counterText: '',
                  hintText: 'Enter 10-digit mobile number',
                  prefixIcon: const Icon(Icons.phone, color: Colors.black45),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFF1B5E20)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xFF1B5E20),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Checkbox(
                    value: agreed,
                    activeColor: const Color(0xFF1B5E20),
                    checkColor: Colors.white,
                    onChanged: (val) => setState(() => agreed = val!),
                  ),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        text: 'I agree to ',
                        style: const TextStyle(color: Colors.black54),
                        children: [
                          TextSpan(
                            text: 'terms of use',
                            style: const TextStyle(
                              color: Color(0xFF1B5E20),
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          const TextSpan(text: ' & '),
                          TextSpan(
                            text: 'privacy policy',
                            style: const TextStyle(
                              color: Color(0xFF1B5E20),
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Color(0xFF1B5E20),
                          ),
                        ),
                      )
                    : ElevatedButton(
                        onPressed: sendcode,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1B5E20),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Get OTP',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
