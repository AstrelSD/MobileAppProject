import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoading = false; // For managing loading state

  // Sign-In Method
  Future<void> _signIn() async {
    setState(() {
      _isLoading = true; // Show loading indicator
    });

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      print('User signed in: ${userCredential.user?.email}');
      // Navigate to the home screen after successful login
      Navigator.pushReplacementNamed(context, '/home'); // Replace '/home' with your route name
    } on FirebaseAuthException catch (e) {
      print('Sign-in error: ${e.message}');
      // Show error message to user
      Fluttertoast.showToast(
        msg: e.message ?? 'Sign-in failed',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    } finally {
      setState(() {
        _isLoading = false; // Hide loading indicator
      });
    }
  }

  // Register Method
  Future<void> _register() async {
    setState(() {
      _isLoading = true; // Show loading indicator
    });

    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      print('User registered: ${userCredential.user?.email}');
      // Navigate to the home screen after successful registration
      Navigator.pushReplacementNamed(context, '/home'); // Replace '/home' with your route name
    } on FirebaseAuthException catch (e) {
      print('Registration error: ${e.message}');
      // Show error message to user
      Fluttertoast.showToast(
        msg: e.message ?? 'Registration failed',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    } finally {
      setState(() {
        _isLoading = false; // Hide loading indicator
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sign In")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator() // Show loading indicator when signing in
                : ElevatedButton(
                    onPressed: _signIn,
                    child: Text("Sign In"),
                  ),
            SizedBox(height: 10),
            // Register Button
            TextButton(
              onPressed: _register,
              child: Text("Don't have an account? Register"),
            ),
          ],
        ),
      ),
    );
  }
}
