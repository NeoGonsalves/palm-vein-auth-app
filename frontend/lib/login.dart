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
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('images/background.jpg', fit: BoxFit.cover),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  Row(
                    children: const [
                      Icon(
                        Icons.fingerprint_outlined,
                        size: 32,
                        color: Color.fromARGB(255, 89, 212, 40),
                      ),
                      SizedBox(width: 8),
                      Text(
                        'BioPay',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 89, 212, 40),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Secure UPI • PalmPay',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                    textDirection: TextDirection.ltr,
                  ),
                  const SizedBox(height: 60),

                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Enter mobile number',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  TextField(
                    controller: phonenumber,
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    style: const TextStyle(
                      color: Color.fromARGB(255, 89, 212, 40),
                    ),
                    decoration: InputDecoration(
                      prefixText: '+91 ',
                      prefixIcon: Icon(Icons.phone),
                      prefixStyle: const TextStyle(color: Colors.white),
                      counterText: '',
                      hintText: 'XXXXXXXXXX',
                      hintStyle: const TextStyle(color: Colors.white38),
                      filled: true,
                      fillColor: const Color.fromARGB(255, 16, 70, 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color.fromARGB(255, 89, 212, 40),
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Checkbox(
                        value: agreed,
                        activeColor: const Color.fromARGB(255, 89, 212, 40),
                        checkColor: Colors.black,
                        onChanged: (val) => setState(() => agreed = val!),
                      ),
                      const Expanded(
                        child: Text.rich(
                          TextSpan(
                            text: 'I agree to ',
                            style: TextStyle(color: Colors.white70),
                            children: [
                              TextSpan(
                                text: 'terms of use',
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: Color.fromARGB(255, 89, 212, 40),
                                ),
                              ),
                              TextSpan(text: ' & '),
                              TextSpan(
                                text: 'privacy policy',
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: Color.fromARGB(255, 89, 212, 40),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    child: isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Color.fromARGB(255, 255, 255, 255),
                              ),
                            ),
                          )
                        : ElevatedButton(
                            onPressed: sendcode,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(
                                255,
                                42,
                                105,
                                17,
                              ),
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'Get OTP',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
