import 'package:flutter/material.dart';
import '../firebase_service.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseService firebaseService = FirebaseService();
  bool isLoading = false;

  void signup() async {
    setState(() => isLoading = true);
    String? error = await firebaseService.signUp(
      name: nameController.text,
      email: emailController.text,
      password: passwordController.text,
    );
    setState(() => isLoading = false);

    if (error == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Signup successful")));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
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
                    onPressed: signup,
                    child: Text('Sign Up'),
                  ),
          ],
        ),
      ),
    );
  }
}
