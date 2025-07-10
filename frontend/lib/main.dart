import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zk_palmscanner_app/wrapper.dart';
import '../screens/register_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
    
    apiKey: "AIzaSyAqQghgtvYYV-2Y7RvAxtVbNTWRx_pSDCE",
  authDomain: "react-netflix-19671.firebaseapp.com",
  projectId: "react-netflix-19671",
  storageBucket: "react-netflix-19671.firebasestorage.app",
  messagingSenderId: "574315337428",
  appId: "1:574315337428:web:801754855e1b0265fb8d41",
  ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'BioPay',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: const RegisterScreen(),
    );
  }
}
