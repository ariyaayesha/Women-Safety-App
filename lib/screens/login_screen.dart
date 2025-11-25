import 'package:flutter/material.dart';
import '../firebase_service.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseService firebaseService = FirebaseService();
  bool isLoading = false;

  void login() async {
    setState(() => isLoading = true);
    String? error = await firebaseService.signIn(
      email: emailController.text,
      password: passwordController.text,
    );
    setState(() => isLoading = false);

    if (error == null) {
      // Navigate to home or SOS screen
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Login successful")));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            SizedBox(height: 20),
            isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: login,
                    child: Text('Login'),
                  ),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/signup'),
              child: Text("Don't have an account? Sign up"),
            )
          ],
        ),
      ),
    );
  }
}
