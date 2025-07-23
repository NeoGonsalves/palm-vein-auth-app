import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'wrapper.dart';

class TransitionScreen extends StatelessWidget {
  const TransitionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () {
      Get.off(() => const Wrapper());
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F2),
      body: Center(
        child: Lottie.asset(
          'assets/animations/Transition_Get_to_Wrapper.json',
          frameRate: FrameRate.max,
          height: 200,
        ),
      ),
    );
  }
}
