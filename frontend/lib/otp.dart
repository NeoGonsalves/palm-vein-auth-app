import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:get/get.dart';
//import 'package:zk_palmscanner_app/screens/phoneauth.dart';
import 'package:zk_palmscanner_app/wrapper.dart';

class OtpPage extends StatefulWidget {
  final String vid;
  final String phonenumber1;
  const OtpPage({super.key, required this.vid, required this.phonenumber1});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  var code = '';
  signIn() async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: widget.vid,
      smsCode: code,
    );
    try {
      await FirebaseAuth.instance.signInWithCredential(credential).then((
        value,
      ) {
        Get.offAll(Wrapper());
      });
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error has Occured', e.code);
    } catch (e) {
      Get.snackbar('Error has occured', e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Color.fromRGBO(239, 211, 255, 1),
      body: SingleChildScrollView(
        child: ListView(
          shrinkWrap: true,
          children: [
            Image.asset('images/otp.png', height: 200, width: 200),
            Center(
              child: Text('OTP verification', style: TextStyle(fontSize: 30)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              child: Text(
                'Enter OTP sent to +91 ${widget.phonenumber1}',
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20),
            textcode(),
            SizedBox(height: 80),
            button(),
          ],
        ),
      ),
    );
  }

  Widget button() {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          signIn();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Color.fromRGBO(239, 160, 255, 1),
          padding: const EdgeInsets.all(16.0),
        ),
        child: Text(
          'Verify & Proceed',
          style: TextStyle(
            fontSize: 18.0,
            color: const Color.fromARGB(255, 255, 255, 255),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget textcode() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Pinput(
          length: 6,
          defaultPinTheme: PinTheme(
            width: 56,
            height: 56,
            textStyle: TextStyle(fontSize: 20, color: Colors.white),
            decoration: BoxDecoration(
              color: Color.fromRGBO(239, 160, 255, 1),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onChanged: (value) {
            setState(() {
              code = value;
            });
          },
        ),
      ),
    );
  }
}
