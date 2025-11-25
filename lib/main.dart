import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/login_screen.dart';
import 'firebase_service.dart'; // ✅ Import Firebase service
import 'screens/signup_screen.dart'; // ✅ Import Signup screen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final FirebaseService firebaseService =
      FirebaseService(); // ✅ Create instance

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Women Safety App',
      theme: ThemeData(primarySwatch: Colors.pink),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/signup': (context) => SignupScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
