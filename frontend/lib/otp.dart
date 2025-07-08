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
      body: SingleChildScrollView(
        child: ListView(
          shrinkWrap: true,
          children: [
            Image.asset('images/enterphone.jpg', height: 330, width: 330),
            Center(
              child: Text('OTP verification', style: TextStyle(fontSize: 30)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              child: Text(
                'Enter OTP sent to ${widget.phonenumber1}',
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
          backgroundColor: Color.fromRGBO(206, 69, 233, 1),
          padding: const EdgeInsets.all(16.0),
        ),
        child: Text(
          'Verify & Proceed',
          style: TextStyle(
            fontSize: 18.0,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget textcode() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Pinput(
          length: 6,
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
